%% extractMapCoordinates - 从地图数据中提取坐标和高程值
%
% 功能描述：
%   此函数将地图数据转换为X、Y平面坐标和Z高程值矩阵，用于可视化和分析。
%   通过生成均匀分布的X和Y坐标，并将地图数据作为高程值，便于后续的三维可视化或地形分析。
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
%       + 实现基础的地图坐标提取功能
%       + 支持均匀分布的X、Y坐标生成
%
% 输入参数：
%   mapData - [matrix] 地图数据矩阵，每个元素表示对应位置的高程值
%             必选参数，需确保矩阵为二维矩阵
%
% 输出参数：
%   X - [matrix] 采样点X坐标矩阵，范围为[-1, 1]
%   Y - [matrix] 采样点Y坐标矩阵，范围为[-1, 1]
%   Z - [matrix] 对应点的地形高程值矩阵
%
% 注意事项：
%   1. 内存要求：建议可用内存 > 地图数据大小 * 2
%   2. 处理时间：与地图数据大小成正比
%   3. 坐标范围：X和Y坐标范围为[-1, 1]，便于标准化处理
%
% 调用示例：
%   % 示例1：基础调用
%   [X, Y, Z] = extractMapCoordinates(mapData);
%
% 依赖工具箱：
%   - MATLAB (meshgrid函数)
%
% 参见函数：
%   meshgrid, linspace, size
function [X, Y, Z] = extractMapCoordinates(mapData)
    % 获取地图尺寸
    [map_height, map_width] = size(mapData);
    
    % 生成均匀分布的X和Y坐标，范围为[-1, 1]
    x_values = linspace(-1, 1, map_width);
    y_values = linspace(-1, 1, map_height);
    
    % 创建坐标网格
    [X, Y] = meshgrid(x_values, y_values);
    
    % 将地图数据作为高程值
    Z = mapData;
end
