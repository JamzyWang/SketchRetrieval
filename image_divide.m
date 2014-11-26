%%  预处理所有image：用divide_fcuntion处理
%    输入：edge_full.list文件中含有所有经过边缘提取后的image地址(一个图像对应一个.mat文件)。edge_full.list文件位于根目录下
%    输出：每一个图像对应一个.mat文件，存储分割矩阵。所有.mat文件位于image_matrix_after_divide目录下
%    function [D,D1,D2,D3,D4,D5] = image_divide( image,cell_percent,image_percent)

%%  参数设置
image_percent = 0.2;    % cell中非零元素占上一层cell中非零元素的比例
cell_percent = 0.2;     % cell中非零元素占当前层cell元素总数的比例

%%  读取图像列表文件
images_list = textread('edge_full_list.txt', '%s');
len = size(images_list);
len = len(1);
fprintf('len %d\n', len);

%%  对每一个图像进行分割处理
for i = 1:len
  imgPath = images_list{i};
  fprintf('%d processing %s\n', i, imgPath);
  
  image = load(imgPath,'a');    % 读取图像经过边缘检测后的数据（a为256*256的矩阵）
  [D,D1,D2,D3,D4,D5] = divide_function( image.a,cell_percent,image_percent);
  
  [filethstr, name, ext] = fileparts(imgPath);
  str = strcat('image_matrix_after_divide/',name);
  filename = strcat(str,'_divide');
  save(filename,'D','D1','D2','D3','D4','D5');   %   保存分割矩阵
end
%% quit;
