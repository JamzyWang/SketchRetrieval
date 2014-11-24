%
%文件功能：计算所有图片的hog特征（把image上的所有点作为兴趣点）
%输入参数：图片数据地址列表，一个txt文件，里面有所有图片的id。
%输出参数：得到所有图片的hog特征，一个image对应一个_.s文件，生成所有图片的_.s文件。
%
images_list = textread('images_from_benchmark_list.txt', '%s'); % images_from_benchmark_list.txt 数据集图片地址列表
len = size(images_list);
len = len(1);
fprintf('len %d\n', len);
for n = 1:len  % 循环处理每一副图片
    imgPath = images_list{n};
    fprintf('%d processing %s\n', n, imgPath);
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


% fid = fopen('3888._s');
% I = fread(fid,'single');
% I_2 = reshape(I,36,[]);
% I_3 = I_2';

