%
%函数功能：提取单个sketch的特征
%输入参数：sketch的地址
%输出参数：sketch的特征,一个（N*N）*36的矩阵，其中N*N为图像的大小，36为特征的维度（HOG特征）
%

function [ hog_feature ] = extract_sketch_feature( sketchPath )
    fprintf('extract sketch hog feature:  %s\n',sketchPath);
    I = imresize(imread(sketchPath), [128 128]);
    
    %   预先判断sketch的类型。sketch是灰度图，二值图？
    
    % 
    %   sketch预处理（可以用一个swith case对应各种情况的预处理选择）
    %
    %   预处理方法1：提取特征前先进行边缘检测（进行cannny边缘检测前须先把RGB图像转化为灰度图）
    mysize=size(I);
    if numel(mysize)>2
        img=rgb2gray(I);
    else
        img=I;
    end
    img = edge(img,'canny'); 
    
    %   预处理方法2：提取特征前不进行边缘检测
    %     img = I;
    
    % 
    %   HOG特征提取：对sketch上的每一个非零像素点计算HOG特征（以这个非零像素点为中心的窗口计算一个HOG特征）
    %
    hog_feature = []; % 提取的sketch的HOG特征
    for i=1:128
        for j=1:128
            [hog, ~, ~] = extractHOGFeatures(img, [i j]); % 计算以[i,j]为中心的HOG特征
            len = size(hog);
            len = len(1);
            if (len == 0) 
                hog_feature = vertcat(hog_feature,zeros(1,36));
            else
                hog_feature = vertcat(hog_feature,hog);
            end
        end
    end
    %   HOG特征保存到同sketch相同文件名，文件后缀为.hog的为文件中
    
    
    [filethstr, name, ~] = fileparts(sketchPath);
    save(fullfile(filethstr, strcat(name, '_HogFeature.mat')),'hog_feature');
    
%     [filethstr, name, ext] = fileparts(sketchPath);
%     fid = fopen(fullfile(filethstr, strcat(name, '.hog')), 'w');
%     hog_feature_2 = hog_feature';
%     fwrite(fid, hog_feature_2, 'single');
%     fclose(fid);
    
end

