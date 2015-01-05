function   [similarity_1,similarity_2,similarity_3,similarity_4,similarity_5] = calculate_matching_cost(sketch_local_feature,image_local_feature,sketch_G1,sketch_G2,sketch_G3,sketch_G4,sketch_G5,image_G1,image_G2,image_G3,image_G4,image_G5,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5);

%%  CALCULATE_MATCHING_COST 此处显示有关此函数的摘要
%   脚本功能：计算sketch和image的匹配值
%   输入参数：
%%     local_feature的形式：:   一个1*65536的矩阵(每一个值表示词典中的某一个单词)
%       sketch的local_feature:   sketch_local_feature
%       image的local_feature:    image_local_feature

%%     global feature的形式：   G1 = mat2cell(image,[128 128],[128 128]);% 保存这一层的兴趣点的global feature的值
%       sketch的global feature:  sketch_G1,sketch_G2,sketch_G3,sketch_G4,sketch_G5
%       image的global feature:   image_G1,image_G2,image_G3,image_G4,image_G5

%%     sketch的分割情况的形式：一个矩阵
%       sketch的分割情况: sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5

%   输出参数：
%       sketch和image的匹配值

%%  整理local feature

sketch_local_feature = reshape(sketch_local_feature,256,[])';   %sketch的local feature:256*256
image_local_feature = reshape(image_local_feature,256,[])';     %image的local feature:256*256

%% *****************************计算第1层的匹配值：2*2   ***************************************
% sketch:sketch_local_feature,sketch_G1
% image:image_local_feature,image_G1
%
fprintf('计算第1层的匹配值 \n');
sketch_local_feature_1 = mat2cell(sketch_local_feature,[128 128],[128 128]);
image_local_feature_1 = mat2cell(image_local_feature,[128 128],[128 128]);

similarity_1 = 0; %记录第1层的匹配值
for i=1:2
    for j=1:2
        if sketch_D1(i,j)==0    %D(i,j)=0，表示需要计算这个cell中的兴趣点的匹配值
            [result] = similarity_calculate_per_cell(sketch_local_feature_1{i,j},image_local_feature_1{i,j},sketch_G1{i,j},image_G1{i,j});
            similarity_1 = similarity_1+result;
        end
    end
end


%% *****************************计算第2层的匹配值：4*4   ***************************************

fprintf('计算第2层的匹配值 \n');
sketch_local_feature_2 = mat2cell(sketch_local_feature,[64 64 64 64],[64 64 64 64]);
image_local_feature_2 = mat2cell(image_local_feature,[64 64 64 64],[64 64 64 64]);

similarity_2 = 0; %记录第2层的匹配值
for i=1:4
    for j=1:4
        if sketch_D2(i,j)==0    %D(i,j)=0，表示需要计算这个cell中的兴趣点的匹配值
            [result] = similarity_calculate_per_cell(sketch_local_feature_2{i,j},image_local_feature_2{i,j},sketch_G2{i,j},image_G2{i,j});
            similarity_2 = similarity_2+result;
        end
    end
end


%% *****************************计算第3层的匹配值：8*8   ***************************************

fprintf('计算第3层的匹配值 \n');
sketch_local_feature_3 = mat2cell(sketch_local_feature,[32 32 32 32 32 32 32 32],[32 32 32 32 32 32 32 32]);
image_local_feature_3 = mat2cell(image_local_feature,[32 32 32 32 32 32 32 32],[32 32 32 32 32 32 32 32]);

similarity_3 = 0; %记录第一层的匹配值
for i=1:8
    for j=1:8
        if sketch_D3(i,j)==0    %D(i,j)=0，表示需要计算这个cell中的兴趣点的匹配值
            [result] = similarity_calculate_per_cell(sketch_local_feature_3{i,j},image_local_feature_3{i,j},sketch_G3{i,j},image_G3{i,j});
            similarity_3 = similarity_3+result;
        end
    end
end


%% *****************************计算第4层的匹配值：16*16 ***************************************
fprintf('计算第4层的匹配值 \n');
sketch_local_feature_4 = mat2cell(sketch_local_feature,[16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16],[16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]);
image_local_feature_4 = mat2cell(image_local_feature,[16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16],[16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]);

similarity_4 = 0; %记录第一层的匹配值
for i=1:16
    for j=1:16
        if sketch_D4(i,j)==0    %D(i,j)=0，表示需要计算这个cell中的兴趣点的匹配值
            [result] = similarity_calculate_per_cell(sketch_local_feature_4{i,j},image_local_feature_4{i,j},sketch_G4{i,j},image_G4{i,j});
            similarity_4 = similarity_4+result;
        end
    end
end


%% *****************************计算第五层的匹配值：32*32 ***************************************

fprintf('计算第5层的匹配值 \n');
sketch_local_feature_5 =  mat2cell(sketch_local_feature,[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8],[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8]);
image_local_feature_5 =  mat2cell(image_local_feature,[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8],[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8]);

similarity_5 = 0; %记录第一层的匹配值
for i=1:32
    for j=1:32
        if sketch_D5(i,j)==0    %D(i,j)=0，表示需要计算这个cell中的兴趣点的匹配值
            [result] = similarity_calculate_per_cell(sketch_local_feature_5{i,j},image_local_feature_5{i,j},sketch_G5{i,j},image_G5{i,j});
            similarity_5 = similarity_5+result;
        end
    end
end


end %end of function

%% 匹配值计算函数
function  [similarity_value] = similarity_calculate_per_cell(sketch_local_feature,image_local_feature,sketch_global_feature,image_global_feature)
%传入的4个参数都是N*N的形式，如128*128,64*64,32*32，16*16，8*8

sketch_global_feature = sketch_global_feature+1; %把global feature的取值范围从0~63变为1~64
image_global_feature = image_global_feature+1;   %把global feature的取值范围从0~63变为1~64

%% *********************把image和sketch的特征整理成直方图的形式*************************************************

% 这里2000为词典的大小，histogram(i,j)表示global feature为i,local feature为j的feature的个数
histogram_sketch = zeros(64,2000);
histogram_image = zeros(64,2000);
len = size(sketch_local_feature,1);

%处理sketch
for i=1:len
    for j=1:len
        if sketch_local_feature(i,j)>0 %只处理兴趣点
            histogram_sketch(sketch_global_feature(i,j),sketch_local_feature(i,j)) =  histogram_sketch(sketch_global_feature(i,j),sketch_local_feature(i,j))+1;
        end
    end
end


%处理image
for i=1:len
    for j=1:len
        if image_local_feature(i,j)>0 %只处理兴趣点
            histogram_sketch(image_global_feature(i,j),image_local_feature(i,j)) =  histogram_image(image_global_feature(i,j),image_local_feature(i,j))+1;
        end
    end
end

%计算匹配值
similarity_value = 0;
for i=1:64
    for j=1:2000 %需要根据词典大小修改
        similarity_value =  similarity_value+ min(histogram_image(i,j),histogram_sketch(i,j));
    end
end

end



