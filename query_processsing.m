%% 
%   脚本功能：批处理所有sketch的检索，用于统计实验效果
%   输入：sketch的列表文件
%   输出：所有sketch的处理结果
%

%%  计算检索结果

[retrieval_result] =retrieval(sketchPath);

%%  对得到的所有匹配结果进行rank，返回top K（对返回结果后期可以考虑做Re_rank）

[sv,si]=sort(retrieval_result,1,'descend'); %   结果排序
