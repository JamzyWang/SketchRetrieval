%
%函数功能：对图片进行量化，用词典中的单词表示图片。
%输入参数：图片进行特征提取后的数据。
%输出参数：得到所有图片的经过量化后的特征，一个image对应一个.mat文件。
%

function [histogram] = quantize_local_feature(local_feature,edge_feature,visual_vocabulary)

% local_feature:65536*36
% edge_feature:256*256
% visual_vocabulary:2000*36

%% **********************************************************************************************************************
%   计算local feature时只计算了edge feature中的兴趣点（值为非零的点）
%   同理，量化local feature时也只需要量化计算了local feature的兴趣点即可
%% **********************************************************************************************************************

%PDIST2 Pairwise distance between two sets of observations.
%   D = PDIST2(X,Y) returns a matrix D containing the Euclidean distances
%   between each pair of observations in the MX-by-N data matrix X and
%   MY-by-N data matrix Y. Rows of X and Y correspond to observations,
%   and columns correspond to variables. D is an MX-by-MY matrix, with the
%   (I,J) entry equal to distance between observation I in X and
%   observation J in Y.


%% 为了计算方便，调整 edge_feature:256*256——> 1*65536
% A =
%
%      1     2     3     4
%      5     6     7     8
%      9    10    11    12
%     13    14    15    16
%
% reshape(A',1,[])
% ans =
%
%      1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16
edge_feature = reshape(edge_feature',1,[]);

%%
histogram = zeros(1,size(visual_vocabulary,1));

%%
for i=1:size(edge_feature,2)
    %     fprintf('%d \n', i);
    if edge_feature(i)~=0  %即当前点为兴趣点
        E = pdist2(local_feature(i,:),visual_vocabulary); %  E是65536*2000
        [~,I] = min(E,[],2); % I为距离最近的单词的索引（1~2000中的某一个）
        histogram(i) = I; % 记录当前兴趣点量化后的索引号
    else
        histogram(i) = 0;
    end
end



%%
end % end of function