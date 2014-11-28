%
%文件功能：建立用于检索的图片数据库
%输入参数：所有图像经过量化后的local feature，所有图像的分割情况
%输出参数：得到一个db.txt 文件，里面包含所有图片经过量化后的数据
%

%%  建立local feature的数据库
local_feature_list = textread('local_feature_after_quantization_list.txt', '%s');% 经过extract_hog_feature_all_points后的数据列表
len = size(local_feature_list);
len = len(1);
fprintf('len %d\n', len);
% fid = fopen('db.txt', 'w');
% fclose(fid);
len
local_feature_database = zeros(len*65536,36);   %   内存不足


% fid = fopen('db.txt', 'a');
% for i = 1:len %循环处理每一个文件（一个文件表示一副image经过特征提取后的数据）
%     imgPath = local_feature_list{i};
%     fprintf('creating database: %d processing %s\n', i, imgPath);
%     histogram = quantize_image(imgPath); %对image（提取特征后的）进行量化，用词典中的单词表示一副image
%     fwrite(fid, histogram, 'single');
% end
% fclose(fid);

% fid = fopen('db.txt','r');
% db = fread(fid,'single'); % N*1
% db_2 = reshape(db,1000,[]); % 1000*M
% db_3 = db_2'; % M*1000
% fclose(fid);

%%  建立分割情况的数据库


