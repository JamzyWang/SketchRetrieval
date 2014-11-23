%%  计算每个图像的特征：feature_extraction函数
%    输入：edge_full.list文件中含有所有需要预处理的image的地址。edge_full.list文件位于根目录下
%    输出：每一个图像对应一个.mat文件，表示图像的特征。所有.mat文件位于image_feature目录下


%%  读取图像列表文件
images_list = textread('edge_full.list', '%s');
len = size(images_list);
len = len(1);
fprintf('len %d\n', len);

%%  对每一个图像进行边缘提取
for i = 1:len
  imgPath = images_list{i};
  fprintf('%d feature extraction %s\n', i, imgPath);
  
  feature = feature_extraction(imgpath);    %计算每个图像的feature(global_feature+local feature)
  
  [filethstr, name, ext] = fileparts(imgPath);
  str = strcat('image_after_edge_detection/',name);
  filename = strcat(str,'_edge');
  save(filename,'a');   %   保存每一个边缘提取后的图像

end
%% quit;
