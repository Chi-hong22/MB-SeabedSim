# MB-SeabedSim: 海底地形生成工具 (Seabed Terrain Generator)

> Multibeam Bathymetric Terrain Simulation Toolkit

一个基于高级数学模型的MATLAB海底地形生成工具，能够创建逼真的海底地形高度图并提供多种可视化方式。

## 简介

本工具使用高级噪声算法（具体是通过1/f^α噪声模型）来生成自然逼真的海底地形。通过二维傅里叶变换和频率域滤波，可以生成包含深海、浅海和陆地的完整地形模型，适用于海洋地理模拟、游戏开发和海底地形可视化研究。

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

主要可调参数位于`main.m`文件开头：

- `matrixSize`：定义地形矩阵大小（更大的矩阵提供更高的细节但需要更多计算资源）
- `powerExponent`：频率滤波器指数，控制地形的粗糙度（值越大，地形越平滑）
- `minTerrainHeight`/`maxTerrainHeight`：地形高度范围
- `rng(8,'twister')`：随机种子，可以更改以生成不同的地形

## 输出示例

运行脚本后，将产生四种不同的可视化结果：
1. 使用sky颜色映射的2D高度图
2. 使用自定义地形颜色映射的2D高度图（区分深海、浅海和陆地）
3. 3D海底地形表面图
4. 具有透明度的3D海底地形图

## 文件结构

- `main.m` - 主程序文件
- `terrainmap.m` - 自定义颜色映射函数
- `backup/` - 早期版本备份

## 联系方式

- 作者：[Chihong（游子昂）](https://github.com/Chi-hong22)
- 邮箱：`you.ziang@hrbeu.edu.cn`
- 项目地址：[MB-SeabedSim](https://github.com/Chi-hong22/MB-SeabedSim)