%
%文件功能：建立用于检索的图片数据库（需要
%输入参数：图片数据库经过extract_hog_feature_all_points后的数据地址列表，一个txt文件，里面有所有图片的id。
%输出参数：得到一个db.txt 文件，里面包含所有图片经过量化后的数据
%

images_list = textread('feature_database_list_2.txt', '%s');% 经过extract_hog_feature_all_points后的数据列表
len = size(images_list);
len = len(1);
fprintf('len %d\n', len);
% fid = fopen('db.txt', 'w');
% fclose(fid);

fid = fopen('db.txt', 'a');
for i = 1:len %循环处理每一个文件（一个文件表示一副image经过特征提取后的数据）
    imgPath = images_list{i};
    fprintf('creating database: %d processing %s\n', i, imgPath);
    histogram = quantize_image(imgPath); %对image（提取特征后的）进行量化，用词典中的单词表示一副image
    fwrite(fid, histogram, 'single');
end
fclose(fid);


% fid = fopen('db.txt','r');
% db = fread(fid,'single'); % N*1
% db_2 = reshape(db,1000,[]); % 1000*M
% db_3 = db_2'; % M*1000
% fclose(fid);
