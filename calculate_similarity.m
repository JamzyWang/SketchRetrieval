%
%函数功能：计算sketch和image的相似度
%输入参数：sketch和image量化后的histogram
%输出参数：计算得到的距离
%


function [ distance ] = calculate_similarity(sketch_histogram,image_histogram )
% sketch:1*16384
% image:1*16384
distance = 0;
[~,w] = size(sketch_histogram);

%   fid = fopen('0._scale', 'r');
%   scale = fread(fid,'uchar');
%   fclose(fid);
%   scale = scale';

for i=1:w
    if(image_histogram(1,i)==sketch_histogram(1,i)) %若sketch和image对应位置上市同一个单词，则权重加一。
        distance = distance +1;
    end
end

end

