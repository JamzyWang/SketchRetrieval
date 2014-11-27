
%%
%脚本功能：对local feture进行聚类得到visual vocabulary
%输入参数：一个local feature文件（去除了所有全0矩阵）
%输出参数：聚类中心(即词典)
%

%%  聚类得到词典

% idx = kmeans(X,k),partition the observations of the n-by-p data matrix X into k clusters,
% and returns an n-by-1 vector (idx) containing cluster indices of each observation.
% Rows of X correspond to points and columns correspond to variables.
% By default, kmeans uses the squared Euclidean distance measure and the k-means++ algorithm for cluster center initialization.
% 矩阵X的每一行代表一个点，每一列代表每个点的变量
%
clc;
clear;

local_feature = load('visual_vocabulary/feature.mat');
feature = local_feature.feature;

fprintf('start to kmeans\n');

[IDX,C] = kmeans(feature,1500,'MaxIter',100, 'Emptyaction','singleton'); % 对特征进行kmeans聚类，聚类中心个数有实验效果确定（I_3为输入矩阵，50为聚类中心个数，100为最大的迭代次数）

fprintf('finished kmenas\n');

filename = strcat('visual_vocabulary/','vocabulary_1500');
save(filename,'IDX','C');   %   保存生成的词典






