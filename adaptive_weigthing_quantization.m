function [ output_args ] = adaptive_weigthing_quantization(local_feature,edge_feature,visual_vocabulary,window_size,paramater_orientation,paramater_distance )
%ADAPTIVE_WEIGTHING_QUANTIZATION 此处显示有关此函数的摘要
%   此处显示详细说明


% local_feature:65536*36
% edge_feature:256*256
% visual_vocabulary:2000*36
% histogram:1*65536(每一个值表示词典中的某一个单词)

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

%% 计算梯度值

[~,~,~,gradient_orientation] = calculate_gradient(edge_feature); %返回的是一个256*256矩阵，矩阵中的元素的值是梯度的方向
edge_map = edge_feature; % 一个256*256的矩阵
codebook = visual_vocabulary; %一个N*36维的矩阵

local_feature_index_matrix = zeros(1,size(local_feature,2));
for k = 1:size(local_feature,2)
    local_feature_index_matrix(k)=k;
end
local_feature_index_matrix = reshape(local_feature_index_matrix',[256 256]);
%%

%% 记录量化后的索引：256*256的矩阵
histogram = zeros(size(edge_feature,1), size(edge_feature,2));

%%
for i=1:size(edge_map,1)
    for j=1:size(edge_map,2)
        %     fprintf('%d \n', i);
        if edge_map(i,j)~=0     %即当前点为兴趣点,计算当前点的local feature应该被量化为哪个codeword
            
            %% 计算窗口大小
            row_start = i-window_size; %起始行
            if(row_start<1)
                row_start=1;
            end
            
            row_end = i+window_size; %终止行
            if(row_end>size(gradient_orientation,1))
                row_end=size(gradient_orientation,1);
            end
            
            column_start = j-window_size;%起始列
            if(column_start<1)
                column_start=1;
            end
            
            column_end = j+window_size;%终止列
            if(column_end>size(gradient_orientation,2))
                column_end=size(gradient_orientation,2);
            end
            
            %% 获得梯度方向矩阵：一个窗口大小
            gradient_orientation_matrix = gradient_orientation(row_start:row_end,column_start:column_end);
            
            %% 计算梯度方向距离矩阵：一个窗口大小
            % 在新的窗口中，当前兴趣点的坐标为：（i-row_start+1,j-colume_start+1）
            row_index =  i-row_start+1;
            column_index = j-column_start+1;
            
            gradient_orientation_distance_matrix =zeros(size(gradient_orientation,1),size(gradient_orientation,2));
            for m=1:size(gradient_orientation,1)
                for n=1:size(gradient_orientation,2)
                    %计算梯度方向差值:方向插值的平方（用弧度计算）
                    gradient_orientation_distance_matrix(m,n)= ((gradient_orientation_matrix(m,n) - gradient_orientation_matrix(row_index,column_index))/(2*pi))^2;
                end
            end
            
            %% 计算兴趣点距离矩阵：一个窗口大小
            distance_matrix = zeros(size(gradient_orientation,1),size(gradient_orientation,2));
            for m=1:size(gradient_orientation,1)
                for n=1:size(gradient_orientation,2)
                    %计算距离插值：坐标索引差值的平方
                    distance_matrix(m,n)=(m-row_index)^2 +(n-column_index)^2;
                end
            end
            
            %% 计算权重矩阵：一个窗口大小
            weigthing_matrix = zeros(size(gradient_orientation,1),size(gradient_orientation,2));
            for m=1:size(gradient_orientation,1)
                for n=1:size(gradient_orientation,2)
                    weigthing_matrix(m,n)=( exp(-gradient_orientation_distance_matrix(m,n)/(paramater_orientation^2)) * exp(-distance_matrix(m,n)/(paramater_distance^2)))/N;
                    %计算距离插值:paramater_orientation和paramater_distance是公式中的两个参数，N是一个正则项
                end
            end
            
            %% 提取边缘矩阵:一个窗口大小
            edge_map_matrix_window = edge_map(row_start:row_end,column_start:column_end);
            
            %% 提取局部特征索引矩阵：一个窗口大小
            local_feature_index_matrix_window = local_feature_index_matrix(row_start:row_end,column_start:column_end);
            
            %% 量化特征
            codeword_index = quantize_local_feature(weigthing_matrix,local_feature_index_matrix_window,edge_map_matrix_window);
            %% 记录codeword的索引号
            histogram(i,j) = codeword_index; % 记录当前兴趣点量化后的索引号
            
            
        else
            histogram(i,j) = 0;  %非兴趣点不需要被量化，直接标识为0
        end
    end
end


    function [distance] = quantize_local_feature(weigthing_matrix,local_feature_index_matrix_window,edge_map_matrix_window)
        
        
        % 计算窗口中的值——to do list
        E = pdist2(local_feature(i,:),visual_vocabulary); %  E是65536*2000
        [~,I] = min(E,[],2); % I为距离最近的单词的索引（1~2000中的某一个）
        
    end

end

