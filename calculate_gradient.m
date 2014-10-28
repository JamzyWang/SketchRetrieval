clear all;clc;

I = imread('bird1.jpg');
I = imresize(I,[256 256]);
I = rgb2gray(I);

fy=[-1 0 1];        %定义垂直方向梯度模板
fx=fy';             %定义水平方向梯度模板

imshow(I);

Gy=imfilter(I,fy,'replicate');    %计算垂直方向梯度
Gx=imfilter(I,fx,'replicate');    %计算水平方向梯度
Ged=sqrt(double(Gx.^2+Gy.^2));    %计算梯度幅值
edge_orientation = atan2(double(Gy), double(Gx)) / pi * 180; %计算梯度方向