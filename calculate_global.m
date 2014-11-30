

%%  ****************************计算某个cell中的每一个兴趣点的global feature**************************
function [global_feature] =calculate_global(cell)

global_feature =zeros(size(cell,1),size(cell,1));   %记录cell中每个点的global feature的值，非兴趣点的值为0

for i=1:size(cell,1)
    for j=1:size(cell,2)
        if cell(i,j)~=0 %   只计算cell中的兴趣点的global feature,不考虑非兴趣点
            global_feature(i,j) = calculate_one_interest_ponit(cell,i,j);
        else
            global_feature(i,j) =0;
        end
    end
end

end %end of function

%%  **计算某一个兴趣点的global feature,是一个长度为6的数组，数组元素是0或者1，为了方便，我们把这个数组表示为了10进制数**************************************
function [return_feature] = calculate_one_interest_ponit(cell,i,j)

distance_array =zeros(1,length(find(cell>0))); %记录距离值的数组的长度等于cell中兴趣点的个数
count = 1;
for m=1:size(cell,1)
    for n=1:size(cell,2)
        if cell(m,n)~=0
            distance_array(count) = norm([i,j]-[m,n]); %计算兴趣点之间的欧式距离，用范数的形式计算
            count = count +1;
        end
    end
end

%   *************************自此，得到了距离数组，接下来需要考虑如何构造global feature**********
mean_value = mean(distance_array);
interest_point_number = length(find(cell>0));

%   计算每一个圆环区域中的兴趣点个数，并进行归一化
A = length(find(distance_array < (mean_value/8)))/interest_point_number;
B = (length(find(distance_array > (mean_value/8)))-length(find(distance_array> (mean_value/4))))/interest_point_number;
C = (length(find(distance_array> (mean_value/4)))-length(find(distance_array> (mean_value/2))))/interest_point_number;
D = (length(find(distance_array> (mean_value/2)))-length(find(distance_array> (mean_value))))/interest_point_number;
E = (length(find(distance_array> (mean_value)))- length(find(distance_array> (2*mean_value))))/interest_point_number;
F = length(find(distance_array> (2*mean_value)))/interest_point_number;
%   量化，为了方便存储，把这个长度为6的数组当做二进制数，并把这个二进制数转换为10进制
% real_feature = [quantize_global_feature(A),quantize_global_feature(B),quantize_global_feature(C),quantize_global_feature(D),quantize_global_feature(E),quantize_global_feature(F)];
return_feature =bin2dec(strcat(int2str(quantize_global_feature(A)),int2str(quantize_global_feature(B)),int2str(quantize_global_feature(C)),int2str(quantize_global_feature(D)),int2str(quantize_global_feature(E)),int2str(quantize_global_feature(F))));

end %end of function
%% *************************************量化global feature**********************************
function [return_value] = quantize_global_feature(value)
if value>0.1
    return_value = 1;
else
    return_value = 0;
end
end