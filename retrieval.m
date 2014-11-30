%%
%函数功能：检索与输入sketch相似的图片
%输入参数：sketch地址
%输出参数：得到相似图片
%

%%
function [retrieval_result] =retrieval(sketchPath)


%%  ****************************对sketch进行预处理**********************************************************
fprintf('对sketch预处理 \n');
[sketch_after_processing] = sketch_processing(sketchPath);

%%  ****************************对sketch提取local feature****************************************************
fprintf('对sketch提取local feature \n');
[sketch_local_feature] = feature_extraction_local(sketch_after_processing);

%%  ****************************对sketch的lcoal feature进行量化******************************************
fprintf('对sketch的local feature进行量化 \n');
Mat = load('visual_vocabulary/vocabulary.mat','C'); %  读取visual vocabulary
visual_vocabulary = Mat.C;
clear Mat;

[sketch_histogram] = quantize_local_feature(sketch_local_feature,sketch_after_processing,visual_vocabulary);

%%  ******************************计算sketch的分割情况*****************************************************
fprintf('计算sketch的分割情况\n');
cell_percent = 0.2; %   定义两个参数
image_percent = 0.2;%   定义两个参数

[sketch_D,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5] = divide_function(sketch_after_processing,cell_percent,image_percent);

%%  ******************************计算sketch的global feature*************************************************
fprintf('计算sketch的global feature \n');
[sketch_global_feature] = feature_extraction_global(sketch_after_processing,sketch_D,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5);

%%  *******************************整理sketch的特征[global feture,local feature]****************************************

fprintf('整理sketch的特征 \n');

sketch_global_feature
sketch_histogram

%%  *********************************循环处理每一张image**********************************************************************

fprintf('循环计算每一张图像的匹配值\n');

%  读取文件
local_feature_list = textread('local_feature_after_quantization_list.txt', '%s'); %读取量化后的local feature
len = size(local_feature_list);
len = len(1);
fprintf('len %d\n', len);

edge_list = textread('edge_full_list.txt', '%s');   %读取edge feature

%   检索结果
retrieval_result = zeros()

for i = 1:len
    %   读取image的local feature
    local_feature_Path = local_feature_list{i};
    fprintf('%d local feature %s\n', i, local_feature_Path);
    image = load(local_feature_Path);
    local_feature = image.hog_feature;
    
    %   读取image的edge feature
    edge_Path = edge_list{i};
    fprintf('%d edge feature %s\n', i, edge_Path);
    edge = load(edge_Path);
    edge_feature = edge.a;
    
    %   根据sketch的分割情况计算image的global feature
    %   函数原型：function [G1,G2,G3,G4,G5] = feature_extraction_global(image,D1,D2,D3,D4,D5)
    [G1,G2,G3,G4,G5] = feature_extraction_global(edge_feature,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5);
    
    %   整理image的特征[global feature,local feature]
    
    
    %   计算sketch和image的匹配情况，记录匹配值
    [similarity] = calculate_matching_cost(sketch_feature,image_feature,sketch_D,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5);
    
    
    %   [filethstr, name, ext] = fileparts(local_feature_Path);
    [~, name, ~] = fileparts(local_feature_Path);
    
    %对于每一个image,需要记录[similarity , name]
    retrieval_result
    
end

fprintf('返回匹配结果 \n');

end % end of function




