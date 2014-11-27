%%
%脚本功能：对经过local feture提取后的特征进行聚类
%输入参数：所有的local feature
%输出参数：聚类中心(即词典)
%

%%
clc;
clear;

%%
features_list = textread('local.txt', '%s'); % local feature列表
len = size(features_list);
len = len(1);
fprintf('len %d\n', len);

feature = zeros(10000,36);   %存储所有local feature的矩阵
zero_feature = zeros(1,36);
fprintf('start collecting feature \n');

count = 1;
for n = 1:len   % 读入所有local feature文件
        fprintf('正在读取第 %d 个文件\n',n);
        featurePath = features_list{n};
        local_feature = load(featurePath,'hog_feature');
        hog_feature = local_feature.hog_feature;
        for i=1:size(hog_feature,1)
            if hog_feature(i,:) ~= zero_feature
                feature(count,:) = hog_feature(i,:);
                count = count + 1;
            end
        end
        clear local_feature;
        clear hog_feature;
end   % end of for n=1:len

fprintf('finished collecting feature \n');
filename = strcat('visual_vocabulary/','feature');
save(filename,'feature');   %   保存feature