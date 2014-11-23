function [ sketchFeature ] = sketch_preprocessing( sketchPath )
%%  SKETCH_PREPROCESSING 此处显示有关此函数的摘要
%   此处显示详细说明

%   先判断sketch的类型，是RGB，gray，binary？若不是怎么处理？
%   canny 边缘检测后的图像是binary型的
%   灰度图可以转化为binary型的gray2bin
%   GFHOG（RGB类型）:33*10=330；image——>canny
%   Benchmark（RGB类型）:31个sketch（每个sketch对应40张image）；image——>canny边缘检测
%   how（gray类型）:250类sketch，总共20000个
%   Tensor:image——>灰度图；sketch——> binary
%   ARP：image——>canny边缘检测——>Gaussian变换;sketch——> thinned version
%   ERH：image——>multiple resolution Canny edge detection.
%   Key shapes: image——> Canny operator in a multi scale manner; sketch——>a thinning operation instead of the Canny operator.
%   a thinning operation :edge(rgb2gray(gfhog),'zerocross');

%%
sketch = imresize(sketchPath,[256 256]);
fprintf('a thinning operation to sketch');
if ndims(sketch) == 3
    sketch = rgb2gray(sketch);
end
sketchFeature = edge(sketch,'zerocross');
end   %end of function
