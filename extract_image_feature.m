%
%函数功能：计算image的特征
%输入参数：image的地址
%输出参数：image的特征
%

function [ img_feature ] = extract_image_feature( imgPath )
    fprintf('Extracting image feature: %s\n', imgPath);
    I1 = imresize(imread(imgPath), [128 128]);
    
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
    
    [filethstr, name, ext] = fileparts(imgPath);
    fid = fopen(fullfile(filethstr, strcat(name, '._s')), 'w');%特征结果保存在image._s中
    hog_feature_2 = hog_feature';
    fwrite(fid, hog_feature_2, 'single');
    fclose(fid);

end

