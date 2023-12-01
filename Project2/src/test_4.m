% 读取图片文件
I = imread('test4.jpg');

% 如果不是灰度图，转化为灰度图
if size(I, 3) == 3
    I = rgb2gray(I);
end

% 叠加密度为0.04的椒盐噪声
imageNoise= imnoise(I, 'salt & pepper', 0.04); 

% 使用窗口大小为3×3的中值滤波去噪
imageMedian = medfilt2(imageNoise,[3 3]);

% 使用窗口大小为3×3的均值滤波去噪
imageAverage=imfilter(imageNoise, fspecial('average',[3 3]));

% 展示原图片、加椒盐噪音后的图片、中值滤波后的图片、均值滤波后的图片
figure
subplot(2, 2, 1), imshow(I), title("原图");
subplot(2, 2, 2), imshow(imageNoise), title("椒盐噪声图");
subplot(2, 2, 3), imshow(imageMedian), title("中值滤波图");                    
subplot(2, 2, 4), imshow(imageAverage), title("均值滤波图");