%
%脚本功能：对经过local feture提取后的特征进行聚类
%输入参数：所有的local feature
%输出参数：聚类中心(即词典)
%

%%
features_list = textread('local_feature_full_list.txt', '%s'); % local feature列表
len = size(features_list);
len = len(1);
fprintf('len %d\n', len);

feature = zeros(10000000,36);   %存储所有local feature的矩阵
zero_feature = zeros(1,36);

fprintf('collecting feature');

count = 1;
for n = 1:len   % 读入所有local feature文件
    if count~= 10000000
        memory
        count %打印程序执行进度
        featurePath = features_list{n};
        %         fprintf('%d processing %s\n', n, featurePath);
        local_feature = load(featurePath,'hog_feature');
        hog_feature = local_feature.hog_feature;
        for i=1:size(hog_feature,1)
            if hog_feature(i,:) ~= zero_feature
                feature(count,:) = hot_feature(i,:);
                count = count + 1;
            end
        end
        clear local_feature;
        clear hog_feature;
    end
end

fprintf('finished collecting feature');
%%  聚类得到词典

% idx = kmeans(X,k),partition the observations of the n-by-p data matrix X into k clusters,
% and returns an n-by-1 vector (idx) containing cluster indices of each observation.
% Rows of X correspond to points and columns correspond to variables.
% By default, kmeans uses the squared Euclidean distance measure and the k-means++ algorithm for cluster center initialization.
% 矩阵X的每一行代表一个点，每一列代表每个点的变量
%
[IDX,C] = kmeans(feature,200,'MaxIter',100); % 对特征进行kmeans聚类，聚类中心个数有实验效果确定（I_3为输入矩阵，50为聚类中心个数，100为最大的迭代次数）
filename = strcat('visual vocabulary/',vocabulary);
save(filename,'IDX','C');   %   保存生成的词典






