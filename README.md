# MB-SeabedSim: 海底地形生成工具 (Seabed Terrain Generator)

> Multibeam Bathymetric Terrain Simulation Toolkit

一个基于高级数学模型的MATLAB海底地形生成工具，能够创建逼真的海底地形高度图并提供多种可视化方式。

## 简介

本工具使用高级噪声算法（具体是通过1/f^α噪声模型）来生成自然逼真的海底地形。通过二维傅里叶变换和频率域滤波，可以生成包含深海、浅海和陆地的完整地形模型，适用于海洋地理模拟、游戏开发和海底地形可视化研究。
输出的`terrainHeightMap_edge.mat`参数作为[MB-TerrainSim](https://github.com/Chi-hong22/MB-TerrainSim)的输入地形数据

## 特性

- 使用先进的噪声模型生成自然逼真的海底地形
- 可调节的地形参数（矩阵大小、粗糙度、高度范围等）
- 多种可视化选项：2D高度图、3D表面图
- 自定义地形颜色映射，区分深海、浅海和陆地
- 高度可配置，便于生成不同类型的海底地形

## 安装与使用

1. 克隆仓库到本地
2. 确保已安装MATLAB（推荐R2019b或更新版本）
3. 在MATLAB中打开`main.m`文件并运行

## 参数设置

主要可调参数位于`main.m`文件中，分为以下几类：

### 基础地形生成参数
- `matrixSize`：定义地形矩阵大小（默认2000，更大的矩阵提供更高的细节但需要更多计算资源）
- `powerExponent`：频率滤波器指数，控制地形的粗糙度（默认2，值越大，地形越平滑）
- `minTerrainHeight`：地形最低点高度（默认-20，表示海底最深处）
- `maxTerrainHeight`：地形最高点高度（默认5，表示陆地最高处）
- `rng(8,'twister')`：随机种子，可以更改以生成不同的地形模式

### 地图格式转换参数
- `num_bins_high_res`：转换后的高分辨率地图大小（默认1100）
- `edge_buffer`：边缘缓冲区大小（默认100），用于平滑地形边界

这些参数可以根据具体需求进行调整，以生成不同特性的海底地形。例如：
- 增大`powerExponent`可以生成更平滑的地形
- 调整`minTerrainHeight`和`maxTerrainHeight`可以改变海底深度范围
- 修改`matrixSize`可以控制地形的详细程度和生成时间

## 输出示例

运行脚本后，将产生四种不同的可视化结果：
1. 使用sky颜色映射的2D高度图
2. 使用自定义地形颜色映射的2D高度图（区分深海、浅海和陆地）
3. 3D海底地形表面图
4. 具有透明度的3D海底地形图

## 数据保存

程序会将生成的地形数据自动保存至`data`文件夹中，使用日期前缀命名（格式：YYMMDD）：

1. **原始地形高度图** (`YYMMDD_terrainHeightMap.mat`)
   - 包含变量：`terrainHeightMap`
   - 描述：完整的地形高度矩阵，值范围为设定的`minTerrainHeight`到`maxTerrainHeight`
   - 用途：可用于后续处理或作为其他仿真的输入数据

2. **带边缘的高分辨率地形坐标数据** (`YYMMDD_terrainHeightMap_edge.mat`)
   - 包含变量：`X`、`Y`、`Z`坐标矩阵
   - 描述：经过分辨率转换并添加边缘缓冲区的三维坐标数据
   - 用途：作为[MB-TerrainSim](https://github.com/Chi-hong22/MB-TerrainSim)的输入

所有数据文件使用MATLAB的`.mat`格式保存，可使用`load`函数轻松读取。

## 文件结构

- `main.m` - 主程序文件
- `terrainmap.m` - 自定义颜色映射函数
- `backup/` - 早期版本备份

## 联系方式

- 作者：[Chihong（游子昂）](https://github.com/Chi-hong22)
- 邮箱：`you.ziang@hrbeu.edu.cn`
- 项目地址：[MB-SeabedSim](https://github.com/Chi-hong22/MB-SeabedSim)