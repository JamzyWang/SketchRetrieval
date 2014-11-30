%%
%函数功能：检索与输入sketch相似的图片
%输入参数：sketch地址
%输出参数：得到相似图片
%

%%
% function [retrieval_result] =retrieval(sketchPath)

function [retrieval_result,sketch_edge_feature,sketch_local_feature_before_quantization,sketch_local_feature,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5,sketch_G1,sketch_G2,sketch_G3,sketch_G4,sketch_G5,image_local_feature,image_edge_feature,image_G1,image_G2,image_G3,image_G4,image_G5] =retrieval(sketchPath)
    
%%  ****************************对sketch预处理得到edge feature**********************************************************
fprintf('1.对sketch预处理 \n');
[sketch_edge_feature] = sketch_processing(sketchPath);

%%  ****************************对sketch提取local feature****************************************************
fprintf('2.对sketch提取local feature \n');
[sketch_local_feature_before_quantization] = feature_extraction_local(sketch_edge_feature);

%%  ****************************对sketch的lcoal feature进行量化******************************************
fprintf('3.对sketch的local feature进行量化 \n');
Mat = load('visual_vocabulary/vocabulary_2000.mat','C'); %  读取visual vocabulary
visual_vocabulary = Mat.C;
clear Mat;

%sketch_histogram是一个1*65536的矩阵(每一个值表示词典中的某一个单词)
[sketch_local_feature] = quantize_local_feature(sketch_local_feature_before_quantization,sketch_edge_feature,visual_vocabulary);

%%  ******************************计算sketch的分割情况*****************************************************
fprintf('4.计算sketch的分割情况\n');
cell_percent = 0.2; %   定义两个参数
image_percent = 0.2;%   定义两个参数

[~,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5] = divide_function(sketch_edge_feature,cell_percent,image_percent);

%%  ******************************计算sketch的global feature*************************************************
fprintf('5.计算sketch的global feature \n');
[sketch_G1,sketch_G2,sketch_G3,sketch_G4,sketch_G5] = feature_extraction_global(sketch_edge_feature,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5);

%%  *******************************整理sketch的特征[global feture,local feature]****************************************

fprintf('6.整理sketch的特征 \n');
% local feature:一个1*65536的矩阵(每一个值表示词典中的某一个单词)
% sketch_local_feature;
% global fature:G1,G2,G3,G4,G5
% sketch_G1,sketch_G2,sketch_G3,sketch_G4,sketch_G5;

%% *******************************************************************************************************


%%  *********************************循环处理每一张image**********************************************************************

fprintf('7.循环计算每一张图像的匹配值\n');

%%  读取图像的local feature文件
image_local_feature_list = textread('local_feature_after_quantization_list_test.txt', '%s'); %读取量化后的local feature
len = size(image_local_feature_list);
len = len(1);
fprintf('len %d\n', len);
%%  读取图像的边缘图像文件
image_edge_list = textread('edge_full_list_test.txt', '%s');   %读取edge feature

%%  ************************记录检索结果********************************************
retrieval_result = zeros(2,len); %第一行记录匹配值，第二行记录对应的image_id
%% ********************************************************************************

for i = 1:len
    %%   读取image的local feature
    local_feature_Path = image_local_feature_list{i};
    fprintf('%d local feature %s\n', i, local_feature_Path);
    image = load(local_feature_Path);
    image_local_feature = image.histogram; % image_local_feature:一个1*65536的矩阵(每一个值表示词典中的某一个单词)
    
    %%   读取image的edge feature
    edge_Path = image_edge_list{i};
    fprintf('%d edge feature %s\n', i, edge_Path);
    edge = load(edge_Path);
    image_edge_feature = edge.a; % image_edge_feature:一个256*256的矩阵(每一个非零值代表图像边缘)
    
    %%   根据sketch的分割情况计算image的global feature
     %    函数原型：function [G1,G2,G3,G4,G5] = feature_extraction_global(image,D1,D2,D3,D4,D5)
    [image_G1,image_G2,image_G3,image_G4,image_G5] = feature_extraction_global(image_edge_feature,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5);
    
    %% ***************************整理image的特征[global feature,local feature]***************
     % local feature:一个1*65536的矩阵(每一个值表示词典中的某一个单词)
     % image_local_feature;
     % global feature:image_G1,image_G2,image_G3,image_G4,image_G5
     % image_G1,image_G2,image_G3,image_G4,image_G5;
     
    %%   计算sketch和image的匹配情况，记录匹配值
    [similarity] = calculate_matching_cost(sketch_local_feature,image_local_feature,sketch_G1,sketch_G2,sketch_G3,sketch_G4,sketch_G5,image_G1,image_G2,image_G3,image_G4,image_G5,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5);
       
    %   [filethstr, name, ext] = fileparts(local_feature_Path);
    [~, name, ~] = fileparts(local_feature_Path); % name为“1000004_edge_local_quan.mat”这种形式
    
    image_id = str2double(strrep(name,'_edge_local_quan',''));
   
    %% 对于每一个image,需要记录[similarity , name]
    retrieval_result(1,i) = similarity;
    retrieval_result(2,i) = image_id;
    
    
end

fprintf('8.返回匹配结果 \n');

end % end of function




