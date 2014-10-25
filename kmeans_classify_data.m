%
%文件功能：对经过calssify_features.m处理后的特征进行聚类（需要聚类128*128次）
%输入参数：分类后的特征数据，一个txt文件，里面有所有特征的id。
%输出参数：得到128*128个词典，一个位置对应一个_.v文件
%

features_list = textread('test.txt', '%s'); %classify_data_list.txt 分类后的特征数据列表
len = size(features_list);
len = len(1);
fprintf('len %d\n', len);
for n = 1:len %循环处理每个文件
    featurePath = features_list{n};
    fprintf('%d processing %s\n', n, featurePath);
    fid = fopen(featurePath,'r');
    I = fread(fid,'single');
    fclose(fid);
    I_2 = reshape(I,36,[]);
    I_3 = I_2';
    [IDX,C] = kmeans(I_3,200,'MaxIter',100); % 对特征进行kmeans聚类，聚类中心个数有实验效果确定（I_3为输入矩阵，50为聚类中心个数，100为最大的迭代次数）
    
    D = C';
    vocabulary = reshape(D,1,[]);
    [filethstr, name, ext] = fileparts(featurePath);
    fid_f = fopen(fullfile('test',strcat(name, '._v')), 'w'); %聚类结果（即词典）写入_.v文件中
    fwrite(fid_f, vocabulary, 'single');
    fclose(fid_f);
end