function map = terrainmap(n, waterRatio)
    % 创建一个地形颜色映射，下半部分使用蓝色阴影表示水体，上半部分使用陆地阴影。
    % Danz 231126
    % 地形色彩映射（colormap）该色彩映射在下半部分使用蓝色阴影，代表水体，而在上半部分使用陆地阴影。
    
    % 如果未提供水体比例参数，则默认设置为0.5（即一半水体一半陆地）
    if nargin < 2
        waterRatio = 1;
    end
    
    % 如果未提供颜色映射长度参数n，则从当前图形或默认图形中获取颜色映射长度
    if nargin < 1
        f = get(groot, 'CurrentFigure');
        if isempty(f)
            n = size(get(groot, 'DefaultFigureColormap'), 1);
        else
            n = size(f.Colormap, 1);
        end
    else
        % 断言n必须是一个非负标量
        assert(isscalar(n) && n >= 0, 'n必须是一个非负标量。');
    end
    
    % 断言waterRatio必须是一个介于0和1之间的标量
    assert(isscalar(waterRatio) && waterRatio >= 0 && waterRatio <= 1, 'waterRatio必须是一个介于0和1之间的标量。');
    
    % 根据waterRatio计算水体和陆地的颜色映射长度
    nWater = ceil(n * waterRatio);
    nLand = n - nWater;
    
    % 创建水体颜色映射
    rc = zeros(nWater, 1);
    gc = max(0, linspace(-1, 1, nWater)).';
    bc = min(1, linspace(0, 2, nWater) + 0.2).';
    waterCM = [rc, gc, bc];
    
    % 创建陆地颜色映射
    nGreen = ceil(nLand / 2);
    nBrown = nLand - nGreen;
    brownCM = [linspace(0.6, 0.4, nBrown)', linspace(0.4, 0.2, nBrown)', linspace(0.2, 0.1, nBrown)'];
    greenCM = summer(nGreen);
    greenBrownCM = [greenCM; brownCM];
    landCM = movmean(greenBrownCM, ceil(max(1, nLand) * 0.1)); % 混合以去除接缝
    
    % 创建组合颜色映射
    map = [waterCM; landCM];
end