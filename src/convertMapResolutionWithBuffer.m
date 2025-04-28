%% convertMapResolutionWithBuffer - 转换地图分辨率并填充边缘缓冲区域
%
% 功能描述：
%   此函数将原始地图数据转换为指定分辨率的地图，并在边缘区域添加缓冲，
%   确保地图数据在边缘区域的连续性和完整性。
%
% 作者信息：
%   作者：Chihong（游子昂）
%   邮箱：you.ziang@hrbeu.edu.cn
%   单位：哈尔滨工程大学
%
% 版本信息：
%   当前版本：v1.0
%   创建日期：250428
%   最后修改：250428
%
% 版本历史：
%   v1.0 (250428) - 首次发布
%       + 实现基础的地图分辨率转换功能
%       + 支持边缘缓冲区的添加
%       + 添加基本的错误处理
%
% 输入参数：
%   target_resolution - [int] 目标地图的分辨率/尺寸（如1100表示1100x1100的地图）
%                       必选参数，范围>0
%   original_map      - [matrix] 原始地图数据，为n×n的矩阵，每个元素表示对应位置的高程值
%                       必选参数，需确保矩阵为方阵
%   edge_buffer       - [int] 边缘缓冲区大小（默认为100，单位：像素）
%                       可选参数，范围>=0
%
% 输出参数：
%   map - [matrix] 生成的带边缘缓冲的转换分辨率地图数据矩阵
%
% 注意事项：
%   1. 内存要求：建议可用内存 > 原始地图大小 * 2
%   2. 处理时间：与地图大小成正比
%   3. 边缘缓冲区：确保缓冲区大小不超过地图尺寸的一半
%
% 调用示例：
%   % 示例1：基础调用（默认边缘缓冲区）
%   map = convertMapResolutionWithBuffer(1100, original_map);
%
%   % 示例2：完整参数调用（自定义边缘缓冲区）
%   map = convertMapResolutionWithBuffer(1100, original_map, 150);
%
% 依赖工具箱：
%   - MATLAB (griddata函数)
%
% 参见函数：
%   griddata, meshgrid, linspace

function map = convertMapResolutionWithBuffer(target_resolution, original_map, edge_buffer)
        % 若未提供边缘缓冲区参数，则设置默认值为100
        if nargin < 3
            edge_buffer = 100;
        end
        
        % 计算地图范围
        min_coord = -(target_resolution/10 - edge_buffer);
        max_coord = target_resolution/10 - (-min_coord);
        
        % 处理输入矩阵
        [height, width] = size(original_map);
        [x_original, y_original] = meshgrid(1:width, 1:height);
        
        % 准备用于插值的数据
        x_coords = x_original(:);  % 转换为列向量
        y_coords = y_original(:);
        z_values = original_map(:);  % 矩阵值转为列向量
        
        % 创建目标分辨率的网格
        [x_grid, y_grid] = meshgrid(linspace(1, width, target_resolution), ...
                                    linspace(1, height, target_resolution));
        
        % 进行分辨率转换插值
        map = griddata(x_coords, y_coords, z_values, x_grid, y_grid, 'cubic');
        
        % 确保没有NaN值
        if any(isnan(map(:)))
            % 使用最近邻插值填充NaN值
            map_nearest = griddata(x_coords, y_coords, z_values, x_grid, y_grid, 'nearest');
            nan_mask = isnan(map);
            map(nan_mask) = map_nearest(nan_mask);
        end
        
        % 使用硬编码的方式定义有效数据边界
        valid_area_start = abs(min_coord) * 10 + 1;
        valid_area_end = max_coord * 10;
        
        % 填充左边缘 - 使用每行最左侧的有效值
        for i = valid_area_start:valid_area_end
            map(i, 1:valid_area_start-1) = map(i, valid_area_start);
        end
        
        % 填充右边缘 - 使用每行最右侧的有效值
        for i = valid_area_start:valid_area_end
            map(i, valid_area_end+1:target_resolution) = map(i, valid_area_end);
        end
        
        % 填充上边缘 - 使用每列最上方的有效值
        for j = valid_area_start:valid_area_end
            map(1:valid_area_start-1, j) = map(valid_area_start, j);
        end
        
        % 填充下边缘 - 使用每列最下方的有效值
        for j = valid_area_start:valid_area_end
            map(valid_area_end+1:target_resolution, j) = map(valid_area_end, j);
        end
        
        % 填充四个角
        % 左上角 - 使用(valid_area_start, valid_area_start)的值
        map(1:valid_area_start-1, 1:valid_area_start-1) = map(valid_area_start, valid_area_start);
        
        % 右上角 - 使用(valid_area_start, valid_area_end)的值
        map(1:valid_area_start-1, valid_area_end+1:target_resolution) = map(valid_area_start, valid_area_end);
        
        % 左下角 - 使用(valid_area_end, valid_area_start)的值
        map(valid_area_end+1:target_resolution, 1:valid_area_start-1) = map(valid_area_end, valid_area_start);
        
        % 右下角 - 使用(valid_area_end, valid_area_end)的值
        map(valid_area_end+1:target_resolution, valid_area_end+1:target_resolution) = map(valid_area_end, valid_area_end);
    end