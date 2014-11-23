function [D,D1,D2,D3,D4,D5] = image_divide( image,cell_percent,image_percent)

%%IMAGE_DIVIDE 此处显示有关此函数的摘要
%   此处显示详细说明
%   这个函数用于图像分割，把输入的图像分为若干个cell
%   C = mat2cell(image,[size(image,1)/2 size(image,1)/2],[size(image,1)/2 size(image,1)/2]);
%   分割后的C，C的取值方法是C{1,1}，C{1,2}，C{2,1}，C{2,2}
%   256*256,128*128,64*64,32*32,16*16,8*8
%   length(find(A>0));计算矩阵A中非零元素的个数
%
%   输入参数：
%       image:图像矩阵
%       image_percent:     cell中非零元素占上一层cell中非零元素的比例
%       cell_percent:      cell中非零元素占当前层cell元素总数的比例
%
%   cell_percent和image_percent决定是否继续对cell进行分割
%
%
%
%   输出：分割情况。需要考虑的问题，如何根据分割情况把image提取特征后的矩阵进行划分，即按照何种形式组织整幅图像的特征。
%
%
%
%%
image_condition = cell_percent;
cell_condition = image_percent;

%% 矩阵E中第一行是image_percent,第二行是cell_percent
[E1,E2,E3,E4,E5,F1,F2,F3,F4,F5] = calculate_interest_points_distribution(image); 
D =[1];
Q = matrix_expand(D);

%%
D1=[];  %   记录分割情况，元素值为1表示分割，元素值为0表示不分割
E1 = reshape(E1,[2 2])';
F1 = reshape(F1,[2 2])';
for i=1:size(E1,2)
    for j=1:size(E1,2)
        if (Q(i,j) == 0 || Q(i,j) ==-1)
            D1(i,j) = -1;
        else
            [result] = calculate_condition(E1(i,j),F1(i,j)); %给定一组image_percent,cell_percent判断它是否需要分割
            D1(i,j) = result; 
        end 
    end
end
Q1 = matrix_expand(D1);

%%
D2=[];  %   记录分割情况，元素值为1表示分割，元素值为0表示不分割
E2 = reshape(E2,[4 4])';
F2 = reshape(F2,[4 4])';
for i=1:size(E2,2)
    for j=1:size(E2,2)
        if (Q1(i,j) == 0 || Q1(i,j) == -1)
            D2(i,j) = -1;
            fprintf('sadfasfa');
        else
            [result] = calculate_condition(E2(i,j),F2(i,j)); %给定一组image_percent,cell_percent判断它是否需要分割
            D2(i,j) = result; 
        end 
    end
end
Q2 = matrix_expand(D2);

%%
D3=[];  %   记录分割情况，元素值为1表示分割，元素值为0表示不分割
E3 = reshape(E3,[8 8])';
F3 = reshape(F3,[8 8])';
for i=1:size(E3,2)
    for j=1:size(E3,2)
        if (Q2(i,j) == 0 || Q2(i,j) == -1)
            D3(i,j) = -1;
        else
            [result] = calculate_condition(E3(i,j),F3(i,j)); %给定一组image_percent,cell_percent判断它是否需要分割
            D3(i,j) = result; 
        end 
    end
end
Q3 = matrix_expand(D3);
%%
D4=[];  %   记录分割情况，元素值为1表示分割，元素值为0表示不分割
E4 = reshape(E4,[16 16])';
F4 = reshape(F4,[16 16])';
for i=1:size(E4,2)
    for j=1:size(E4,2)
        if (Q3(i,j) == 0 || Q3(i,j) == -1)
            D4(i,j) = -1;
        else
            [result] = calculate_condition(E4(i,j),F4(i,j)); %给定一组image_percent,cell_percent判断它是否需要分割
            D4(i,j) = result; 
        end 
    end
end
Q4 = matrix_expand(D4);

%%
D5=[];  %   记录分割情况，元素值为1表示分割，元素值为0表示不分割
E5 = reshape(E5,[32 32])';
F5 = reshape(F5,[32 32])';
for i=1:size(E5,2)
    for j=1:size(E5,2)
        if (Q4(i,j) == 0 || Q4(i,j) == -1)
            D5(i,j) = -1;
        else
            [result] = calculate_condition(E5(i,j),F5(i,j)); %给定一组image_percent,cell_percent判断它是否需要分割
            D5(i,j) = result; 
        end 
    end
end
Q5 = matrix_expand(D5);


%% divid_condition：构造一个分割条件，若cell满足这个条件就进行分割，若不满足这个条件就不分割。
    function [result] = calculate_condition(image_percent,cell_percent)
        result = 0;
        if ((image_percent>image_condition) || (cell_percent>cell_condition)) %这个公式以后作为判断是否分割的依据
            result =1;
        end     
    end


%%
end %   end of function
