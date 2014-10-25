%
%函数功能：提取sketch的特征
%输入参数：sketch
%输出参数：sketch的特征数据
%


function [ hog_feature ] = extract_sketch_hog_feature( sketchPath )
    fprintf('extract sketch hog feature:  %s\n',sketchPath);
    I1 = imresize(imread(sketchPath), [128 128]);
       
    %方法1：提取特征时先进行边缘检测
    mysize=size(I1);
    if numel(mysize)>2
        img=rgb2gray(I1);
    else
        img=I1;
    end
    img = edge(img,'canny'); %进行cannny边缘检测前必须先把图像转化为灰度图
    
    % 方法2：提取特征时不进行边缘检测
    %     img = I1;
    
    
    
    hog_feature = [];
    for i=1:128
        for j=1:128
            [hog, ~, ~] = extractHOGFeatures(img, [i j]);
            len = size(hog);
            len = len(1);
            if (len == 0)
                hog_feature = vertcat(hog_feature,zeros(1,36));
            else
                hog_feature = vertcat(hog_feature,hog);
            end
        end
    end
    
    [filethstr, name, ext] = fileparts(sketchPath);
    fid = fopen(fullfile(filethstr, strcat(name, '._s')), 'w');
    hog_feature_2 = hog_feature';
    fwrite(fid, hog_feature_2, 'single');
    fclose(fid);
    
end

