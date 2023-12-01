% 清空输入区
close all; clear; % clc;

% 输入图像文件的路径，并判读文件是否合法（是否非空、是否存在、是否为指定的图像格式）
filePath = ' ';
while isempty(filePath) || ~exist(filePath,'file') || ~endsWith(filePath,'.jpg') 
    filePath = input('image:', 's');
end

% 读取图片
I = imread(filePath);

% 获取文件大小，横轴长度为x，纵轴长度为y，z代表描述一个像素值的参数量（此处为R、G、B）
[y, x, z] = size(I);

% 初始化用户输入
inputX = -1;
inputY = -1;

% 获取用户输入的点坐标，并判断是否合法，此处要求用户不能输入最外圈的点坐标
while (inputX < 2) || (inputX > x-1) || (inputY < 2) || (inputY > y-1)
    inputX = input('x:');
    inputY = input('y:');
end

% 通过max、min函数再次检查图像边界，获取(inputX, inputY)及周围8个点坐标的RGB值
for fy = max(inputY - 1, 1) : min(inputY + 1, y)
    for fx = max(inputX - 1, 1) : min(inputX + 1, x)
        fprintf('(%d, %d): (%d, %d, %d)\n', fx, fy, I(fy, fx, 1), I(fy, fx, 2), I(fy, fx, 3));
    end
end