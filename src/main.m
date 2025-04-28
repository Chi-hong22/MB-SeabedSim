%% main - 地形生成与处理主程序
%
% 功能描述：
%   此脚本用于生成随机地形数据，并通过傅里叶变换和滤波器处理，生成具有自然特征的地形高度图。
%   支持地形数据的可视化、分辨率转换、边缘缓冲处理以及数据存储功能。
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
%       + 实现基础的地形生成与处理功能
%       + 支持随机噪声生成、傅里叶变换、滤波器应用
%       + 添加地形数据的可视化与存储功能
%
% 输入参数：
%   无直接输入参数，所有参数在脚本内部定义。
%
% 输出参数：
%   无直接返回值，处理结果通过可视化展示并保存到指定路径。
%
% 注意事项：
%   1. 内存要求：建议可用内存 > 地形数据大小 * 2
%   2. 处理时间：与地形数据大小成正比
%   3. 数据存储：结果将保存到当前脚本路径的上一级文件夹下的data文件夹中
%
% 调用示例：
%   % 直接运行脚本
%   main;
%
% 依赖工具箱：
%   - MATLAB (fft2, ifft2, fftshift, ifftshift, imagesc, surf, colormap, terrainmap, rescale)
%
% 参见函数：
%   fft2, ifft2, fftshift, ifftshift, imagesc, surf, colormap, terrainmap, rescale

%% 初始化
clc;
close;

%% 随机噪声生成
rng(8,'twister') % 设置随机数生成器种子，确保每次生成相同的随机结果   5
% 定义地形矩阵大小，必须为偶数以保证傅里叶变换的对称性
matrixSize = 2000; % 矩阵大小参数
noiseMatrix = randn(matrixSize); % 生成初始随机噪声矩阵

%% 二维快速傅里叶变换
% 对噪声矩阵进行二维快速傅里叶变换，并将频谱中心移动到矩阵中心
fourierMatrix = fftshift(fft2(noiseMatrix));

%% 创建频率滤波器
% 使用1/f^α 分形噪声模型创建滤波器，用于模拟自然地形的特征
powerExponent = 2; % 频率滤波器指数，控制地形的粗糙度
distanceSquared = ((1:matrixSize)-(matrixSize/2)-1).^2;
distanceMatrix = sqrt(distanceSquared(:) + distanceSquared(:)');
freqFilter = distanceMatrix .^ -powerExponent; % 创建频率域滤波器
freqFilter(isinf(freqFilter)) = 1; % 处理零频率处的无穷大值

%% 应用滤波器
filteredSpectrum = fourierMatrix .* freqFilter;

%% 逆傅里叶变换
% 将滤波后的频谱转换回空间域，得到地形高度图

minTerrainHeight= -20;% 表示最低地形高度（海底深度）
maxTerrainHeight= 5; % 表示最高地形高度（海平面）

heightMapRaw = ifft2(ifftshift(filteredSpectrum));

terrainHeightMap = rescale(heightMapRaw, minTerrainHeight, maxTerrainHeight);  % 将高度值缩放到[-20,5]范围

%% 可视化地形结果
% 第一视图：使用sky颜色映射显示地形
figure()
imagesc(terrainHeightMap)
set(gca,'YDir','normal')
colormap(gca,sky(256))
colorbar
title('地形高度图 - Sky配色')

% 第二视图：使用自定义颜色映射terrainmap()显示地形
figure()
imagesc(terrainHeightMap)
set(gca,'YDir','normal')
colormap(gca,terrainmap()) % 自定义颜色映射
colorbar
title('地形高度图 - Terrain配色')

% 第三视图：使用surf函数创建三维地形图
figure()
xCoords = linspace(0, matrixSize, width(terrainHeightMap));
yCoords = linspace(0, matrixSize, height(terrainHeightMap));
surf(xCoords,yCoords,terrainHeightMap,EdgeColor = 'none');
colormap(gca,terrainmap()) % 自定义颜色映射
% axis equal
title('三维地形图')

% 第四视图：使用surf函数创建具有透明度的三维地形图
figure()
s = surf(zeros(matrixSize,matrixSize),FaceColor = [.28 .24 .54],EdgeColor='none',...
    AlphaData=terrainHeightMap,FaceAlpha='flat');
view(2)  % 从侧面查看表面图
title('具有透明度的三维地形图')

%% 地图格式转换
% 设置分辨率和边缘缓冲区
num_bins_high_res = 1100;  % 转换分辨率地图大小
edge_buffer = 100;         % 边缘缓冲区大小
MapResolutionWithBuffer = convertMapResolutionWithBuffer(num_bins_high_res, terrainHeightMap, edge_buffer);

% 直接可视化MapResolutionWithBuffer结果
figure();
imagesc(MapResolutionWithBuffer);
set(gca,'YDir','normal');
colormap(gca, terrainmap());
colorbar;
title('转换分辨率并添加边缘缓冲后的地图');

% 从高分辨率地图数据提取X、Y、Z坐标
[X, Y, Z] = extractMapCoordinates(MapResolutionWithBuffer);

% 使用提取的坐标显示地形
figure();
surf(X, Y, Z, 'EdgeColor', 'none');
shading interp;
title('使用提取坐标显示的地形图');
colormap(terrainmap());

%% 数据存储
% 获取当前脚本所在路径
current_script_path = fileparts(mfilename('fullpath'));
% 设置存储路径为当前脚本路径的上一级文件夹下的data文件夹
save_path = fullfile(current_script_path, '..', 'data');

% 如果目录不存在，则创建它
if ~exist(save_path, 'dir')
    mkdir(save_path);
end

% 获取当前日期时间
save_date_time = datetime('now');
% 构建文件名格式：YYMMDD_文件名
date_prefix = sprintf('%02d%02d%02d', ...
    mod(year(save_date_time),100), month(save_date_time), day(save_date_time));

% 保存原始地形高度图
terrain_filename = sprintf('%s_terrainHeightMap.mat', date_prefix);
save(fullfile(save_path, terrain_filename), 'terrainHeightMap');
fprintf('地形高度图数据保存完成: %s\n', terrain_filename);

% 保存带边缘的高分辨率地形坐标数据
edge_filename = sprintf('%s_terrainHeightMap_edge.mat', date_prefix);
save(fullfile(save_path, edge_filename), 'X', 'Y', 'Z');
fprintf('带边缘的地形坐标数据保存完成: %s\n', edge_filename);