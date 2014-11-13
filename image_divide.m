function [ C] = image_divide( image,cell_percent,image_percent_1,image_percent_2)
%IMAGE_DIVIDE 此处显示有关此函数的摘要
%   此处显示详细说明
%   这个函数用于图像分割，把输入的图像分为2*2个cell
%   C = mat2cell(image,[size(image,1)/2 size(image,1)/2],[size(image,1)/2 size(image,1)/2]);
%   256*256,128*128,64*64,32*32,16*16,8*8
%   length(find(A>0));计算矩阵A中非零元素的个数
%
%   输入参数：
%       image:图像矩阵
%       cell_percent:cell中非零元素占整个cell元素的比例
%       image_percent_1:cell中非零元素占整个image中非零元素的比例
%       image_percent_2:cell中非零元素占整个image元素的比例
%
%   cell_percent和image_percent_1和image_percent_2决定是否继续对cell进行分割
%
%   分割后的C，C的取值方法是C{1,1}，C{1,2}，C{2,1}，C{2,2}
%
%
%   输出：分割情况。需要考虑的问题，如何根据分割情况把image提取特征后的矩阵进行划分，即按照何种形式组织整幅图像的特征。
%
%
%

[percent_1,percent_2,percent_3,percent_4,C]  = calculate(image);
%
%
%
%
%
%   divid_condition：构造一个分割条件，若cell满足这个条件就进行分割，若不满足这个条件就不分割。
%
%
%
end

function [proportion_1,proportion_2,proportion_3,proportion_4,C] = calculate(image)
    C = mat2cell(image,[size(image,1)/2 size(image,1)/2],[size(image,1)/2 size(image,1)/2]);
    number_of_image = length(find(image>0));
    fprintf('number_of_image: %d \n ',number_of_image);

    number_of_cell_1 = length(find(C{1,1 }>0));
    proportion_1 =number_of_cell_1 /number_of_image;
    fprintf('number_of_cell_1: %d proportion_1:%d \n ',number_of_cell_1,proportion_1);

    number_of_cell_2 = length(find(C{1,2}>0));
    proportion_2 =number_of_cell_2 /number_of_image;
    fprintf('number_of_cell_2: %d proportion_2:%d \n ',number_of_cell_2,proportion_2);

    number_of_cell_3 = length(find(C{2,1}>0));
    proportion_3 =number_of_cell_3 /number_of_image;
    fprintf('number_of_cell_3: %d proportion_3:%d \n ',number_of_cell_3,proportion_3);

    number_of_cell_4 = length(find(C{2,2}>0));
    proportion_4 =number_of_cell_4 /number_of_image;
    fprintf('number_of_cell_1: %d proportion_1:%d \n ',number_of_cell_4,proportion_4);

end
%
% imwrite(a,'bird_wzm.png');
% imwrite(C{1,1},'bird_cell_1.png');
% imwrite(C{1,2},'bird_cell_2.png');
% imwrite(C{2,1},'bird_cell_3.png');
% imwrite(C{2,2},'bird_cell_3.png');