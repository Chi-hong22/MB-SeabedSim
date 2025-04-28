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
surf(xCoords,yCoords,terrainHeightMap,EdgeColor='none')
colormap(gca,terrainmap()) % 自定义颜色映射
% axis equal
title('三维地形图')

% 第四视图：使用surf函数创建具有透明度的三维地形图
figure()
s = surf(zeros(matrixSize,matrixSize),FaceColor=[.28 .24 .54],EdgeColor='none',...
    AlphaData=terrainHeightMap,FaceAlpha='flat');
view(2)  % 从侧面查看表面图
title('具有透明度的三维地形图')
