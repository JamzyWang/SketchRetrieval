function [E1,E2,E3,E4,E5,F1,F2,F3,F4,F5,D1,D2,D3,D4,D5] = calculate_interest_points_distribution(image)
%%  计算每个cell的两个参数
%    image_percent:     cell中非零元素占上一层cell中非零元素的比例
%    cell_percent:      cell中非零元素占当前层cell元素总数的比例
%    输入参数：经过边缘提取后的image或者sketch
%    输出参数：E1,E2,E3,E4，E5（每个矩阵中都保存了对应的参数）,矩阵E中第一行是image_percent,第二行是cell_percent

%% 0.原始图像,未分割
C = image;
D = length(find(C>0));
Q = matrix_expand(D);

%% 1.分割为：2*2    每个大小为：128*128
C1 = mat2cell(image,[128 128],[128 128]);
D1 = [];    %   记录当前cell中非零元素的个数
E1 = [];    %   记录当前cell的image_percent
F1 = [];    %   记录当前cell的cell_percent
for i=1:2
    for j=1:2
        count_interest_point = length(find(C1{i,j}>0)); %   计算当前cell中非零元素的个数
        D1(i,j)= count_interest_point;
        if Q(i,j)==0 %  上一层cell中全为0
            image_percent = -1;
            cell_percent = -1;
        else
            image_percent = D1(i,j) / Q(i,j);   %   计算当前cell的两个参数....Q(i,j)可能为0
            cell_percent = D1(i,j) / (128*128);
        end
        E1 = [E1 image_percent];
        F1 = [F1 cell_percent];
%         fprintf('C1 %d %d: %d\n',i,j,count_interest_point);
        
    end
end
Q1 = matrix_expand(D1);    %    扩展D1用于下一步计算

%% 2.分割为：4*4    每个大小为：64*64
C2 = mat2cell(image,[64 64 64 64],[64 64 64 64]);
D2 = [];
E2 = [];
F2 = [];
for i=1:4
    for j=1:4
        count_interest_point = length(find(C2{i,j}>0)); %   计算当前cell中非零元素的个数
        D2(i,j)= count_interest_point;
        if Q1(i,j) == 0
            image_percent = -1;
            cell_percent = -1;
        else
            image_percent = D2(i,j) / Q1(i,j);   %   计算当前cell的两个参数
            cell_percent = D2(i,j) / (64*64);
        end
        E2 = [E2 image_percent];
        F2 = [F2 cell_percent];
%         fprintf('C2 %d %d: %d\n',i,j,count_interest_point);
    end
end
Q2 = matrix_expand(D2);    %    扩展D2用于下一步计算

%% 3.分割为：8*8    每个大小为：32*32
C3 = mat2cell(image,[32 32 32 32 32 32 32 32],[32 32 32 32 32 32 32 32]);
D3 = [];
E3 = [];
F3 = [];
for i=1:8
    for j=1:8
        count_interest_point = length(find(C3{i,j}>0));
        D3(i,j)= count_interest_point;
        if Q2(i,j)==0
            image_percent = -1;
            cell_percent = -1;
        else
            
            image_percent = D3(i,j) / Q2(i,j);   %   计算当前cell的两个参数
            cell_percent = D3(i,j) / (32*32);
        end
        E3 = [E3 image_percent];
        F3 = [F3 cell_percent];
%         fprintf('C3 %d %d: %d\n',i,j,count_interest_point);
    end
end
Q3 = matrix_expand(D3);    %    扩展D3用于下一步计算

%% 4.分割为: 16*16   每个大小为：16*16
C4 = mat2cell(image,[16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16],[16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]);
D4 = [];
E4 = [];
F4 = [];
for i=1:16
    for j=1:16
        count_interest_point = length(find(C4{i,j}>0));
        D4(i,j)= count_interest_point;
        if Q3(i,j) == 0
            image_percent = -1;
            cell_percent = -1;
        else
            
            image_percent = D4(i,j) / Q3(i,j);   %   计算当前cell的两个参数
            cell_percent = D4(i,j) / (16*16);
        end
        E4 = [E4 image_percent];
        F4 = [F4 cell_percent];
%         fprintf('C4 %d %d: %d\n',i,j,count_interest_point);
    end
end
Q4 = matrix_expand(D4);    %    扩展D4用于下一步计算

%% 5.分割为：32*32  每个大小为：8*8
C5 = mat2cell(image,[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8],[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8]);
D5 = [];
E5 = [];
F5 = [];
for i=1:32
    for j=1:32
        count_interest_point = length(find(C5{i,j}>0));
        D5(i,j)= count_interest_point;
        if Q4(i,j) == 0
            image_percent = -1;
            cell_percent = -1;
        else
            
            image_percent = D5(i,j) / Q4(i,j);   %   计算当前cell的两个参数
            cell_percent = D5(i,j) / (8*8);
        end
        E5 = [E5 image_percent];
        F5 = [F5 cell_percent];
%         fprintf('C5 %d %d: %d\n',i,j,count_interest_point);
    end
end

%%

end %   end of function
