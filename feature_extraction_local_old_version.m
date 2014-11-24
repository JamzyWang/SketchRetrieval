function [ hog_feature] = feature_extraction_local_old_version( imgPath )
%FEATURE_EXTRACTION_LOCAL_OLD_VERSION 此处显示有关此函数的摘要
%   此处显示详细说明
    img = imgPath;
    hog_feature = [];
    for i=1:128 % 循环处理图片上每一个像素点
        for j=1:128
            [hog, validPoints, ptVis] = extractHOGFeatures(img, [i j]);
            %可视化hog特征
            %             if ((i == 16) && (j == 9))
            %                 figure;
            %                 imshow(img); hold on;
            %                 plot(ptVis, 'Color','green');
            %             end
            len = size(hog);
            len = len(1);
            if (len == 0)
                hog_feature = vertcat(hog_feature,zeros(1,36));
            else
                hog_feature = vertcat(hog_feature,hog);
            end
        end
    end

end

