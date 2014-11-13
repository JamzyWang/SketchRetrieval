function [ output_args ] = image_preprocessing( input_args )
%IMAGE_PREPROCESSING 此处显示有关此函数的摘要
%   此处显示详细说明
%   GFHOG（RGB类型）:33*10=330；image——>canny
%   Benchmark（RGB类型）:31个sketch（每个sketch对应40张image）；image——>canny边缘检测
%   how（gray类型）:250类sketch，总共20000个
%   Tensor:image——>灰度图；sketch——> binary
%   ARP：image——>canny边缘检测——>Gaussian变换;sketch——> thinned version
%   ERH：image——>multiple resolution Canny edge detection.
%   Key shapes: image——> Canny operator in a multi scale manner; sketch——>a thinning operation instead of the Canny operator.
%
%   BW = EDGE(I,'canny',THRESH,SIGMA) specifies the Canny method, using
%   SIGMA as the standard deviation of the Gaussian filter. The default
%   SIGMA is sqrt(2); the size of the filter is chosen automatically, based
%   on SIGMA.



end

