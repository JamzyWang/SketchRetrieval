%%
%函数功能：对图片进行量化，用词典中的单词表示图片。
%输入参数：图片进行特征提取后的数据
%输出参数：得到所有图片的hog特征，一个image对应一个_.s文件，生成所有图片的_.s文件。
%
%%
clc;
clear;

%%  读取文件
local_feature_list = textread('local_feature_full_list.txt', '%s'); %读取local feature
len = size(local_feature_list);
len = len(1);
fprintf('len %d\n', len);

edge_list = textread('edge_full_list.txt', '%s');   %读取edge feature

%%  读取visual vocabulary
Mat = load('visual_vocabulary/vocabulary_2000.mat','C');
visual_vocabulary = Mat.C;
clear Mat;

%%
for i = 1:len
    %   读取local feature
    local_feature_Path = local_feature_list{i};
    fprintf('%d local feature %s\n', i, local_feature_Path);
    image = load(local_feature_Path);
    local_feature = image.hog_feature;
    
    %   读取edge feature
    edge_Path = edge_list{i};
%     fprintf('%d edge feature %s\n', i, edge_Path);
    edge = load(edge_Path);
    edge_feature = edge.a;
    
    [histogram] = quantize_local_feature(local_feature,edge_feature,visual_vocabulary);
    
    
    [filethstr, name, ext] = fileparts(local_feature_Path);
    str = strcat('local_feature_after_quantization/',name);
    filename = strcat(str,'_quan');
    save(filename,'histogram');   %   保存每一个边缘提取后的图像
    
end
%%
