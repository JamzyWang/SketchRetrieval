%%  预处理所有image：用AnisotropicDetector进行边缘提取
%    输入：image_full.list文件中含有所有需要预处理的image的地址。image_full.list文件位于根目录下
%    输出：每一个图像对应一个.mat文件，表示进行边缘提取后的图像。所有.mat文件位于image_after_edge_detection目录下

%%  image预处理分析
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


%% addpath(genpath('F:\paper\experiment\sketch_retrieval_project\AnisotropicDetector\'));
addpath(fullfile(pwd,'AnisotropicDetector'));

%%  参数设置
t = 30;
sigma = 6;
lowScale = 2:3:17;

%%  读取图像列表文件
images_list = textread('images_full.list', '%s');
len = size(images_list);
len = len(1);
fprintf('len %d\n', len);

%%  对每一个图像进行边缘提取
for i = 1:len
  imgPath = images_list{i};
  fprintf('%d processing %s\n', i, imgPath);
  
  img = imresize(imread(imgPath), [256 256]);   %   resize到相同的尺寸
  [result] = andiff( img, linspace(1.2,16,t), sigma, 3, 1000, t);
  a = max(result.scaleMat, [], 3);  %   a为进行边缘提取后的图像
  
  [filethstr, name, ext] = fileparts(imgPath);
  filename = strcat('image_after_edge_detection/',name);
  save(filename,'a');   %   保存每一个边缘提取后的图像
  
%   figure;imshow(a);
%   [filethstr, name, ext] = fileparts(imgPath);
%   fid = fopen(fullfile(filethstr, strcat(name, '._s')), 'w');
%   fid = fopen(fullfile('image_after_edge_detection', strcat(name, '._s')), 'w');
%   fwrite(fid, a', 'uchar');
%   fclose(fid);

end
%% quit;
