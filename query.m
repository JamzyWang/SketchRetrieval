%% 
%函数功能：检索与输入sketch相似的图片
%输入参数：sketch地址
%输出参数：得到相似图片
%

%%
function [sv,si,distance_vector,hog_feature,sketch_histogram] = query(sketchPath)

fid = fopen('db.txt', 'r'); %db.txt图片数据库
db = fread(fid,'single');
fclose(fid);
db = reshape(db,16384,[]);
db = db';    % db:N*16384
[length,~] = size(db);

%先对sketch提取基于单点的hog特征
hog_feature = extract_sketch_hog_feature(sketchPath);

[~, name, ~] = fileparts(sketchPath);
sketch_feature_path = strcat(name, '._s'); %进行特征提取后的数据文件
fprintf('%s \n',sketch_feature_path);
%对sketch进行量化
sketch_histogram = quantize_image(sketch_feature_path); %特征量化

% [a,b] = size(sketch_histogram);
% fprintf('a: %d \n',a);
% fprintf('b: %d \n',b);
% % fid_1 = fopen('sketch_histogram.txt','w');
% % fwrite(fid_1,sketch_histogram,'single');
% % fclose(fid_1);

distance_vector = [];
for i=1:length
    image_histogram = db(i,:);
    distance = calculate_similarity(sketch_histogram,image_histogram);   % 计算sketch和数据库中的image的相似度
    distance_vector = [distance_vector;distance];
end

[sv,si]=sort(distance_vector,1,'descend');


images_list = textread('images_from_benchmark_list.txt', '%s');% 图片数据库的图片地址列表
[si_length,~] = size(si); % si_length图片数据库中图片的数量

fid = fopen('result.txt', 'w'); % 检索结果写入到result.txt中
fclose(fid);

fid = fopen('result.txt', 'a');
for i=1:200 %提取结果中前200的数据
    imgPath = images_list{si(i)};
    fprintf('%d processing %s\n', si(i),imgPath);
    fprintf(fid,'%s\n', imgPath);
%     figure;
%     imshow(imgPath);
end
fclose(fid);
% imshow(sketchPath);
end








