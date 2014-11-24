%
%函数功能：对图片进行量化，用词典中的单词表示图片。
%输入参数：图片进行特征提取后的数据
%输出参数：得到所有图片的hog特征，一个image对应一个_.s文件，生成所有图片的_.s文件。
%

function [histogram] = quantize_image(imgPath) % imgPath 经过特征提取后的数据

fprintf('quantize:  %s\n',imgPath);
fid = fopen(imgPath, 'r');
feature_1 = fread(fid,'single');
fclose(fid); %注意：随时关闭已经打开的文件句柄

feature_2 = reshape(feature_1,36,[]);
feature_3 = feature_2'; % image_feture 16384*36
[i,j] =size(feature_3);
histogram = zeros(1,i) ;


for k = 1:i %循环对每一个区域进行量化
    name = num2str(k);
    fid_v = fopen(fullfile('all_vocabulary',strcat(name, '._v')), 'r'); % 一个区域需要用该区域特定的词典进行量化
    vocabulary = fread(fid_v,'single');
    fclose(fid_v);
    vocabulary_2 = reshape(vocabulary,36,[]);
    vocabulary_3 = vocabulary_2';
    
    % 自适应加权计算特征距离单词的距离
    % 获得窗口中的每一个向量的值
    adaptive_vector = [];
    if((k>=1)&&(k<=128)) %image的第一行
        if(k==1)
            adaptive_vector =[zeros(1,36);zeros(1,36);zeros(1,36);zeros(1,36);feature_3(1,:);feature_3(2,:);zeros(1,36);feature_3(129,:);feature_3(130,:)];
        elseif(k==128)
            adaptive_vector =[zeros(1,36);zeros(1,36);zeros(1,36);feature_3(127,:);feature_3(128,:);zeros(1,36);feature_3(255,:);feature_3(256,:);zeros(1,36)];
        else
            adaptive_vector = [zeros(1,36);zeros(1,36);zeros(1,36);feature_3(k-1,:);feature_3(k,:);feature_3(k+1,:);feature_3(k+127,:);feature_3(k+128,:);feature_3(k+129,:)];
        end
    end
    
    
    if((k>=16257)&&(k<=16384))% image的最后一行
        if(k==16257)
            adaptive_vector = [zeros(1,36);feature_3(16129,:);feature_3(16130,:);zeros(1,36);feature_3(16257,:);feature_3(16258,:);zeros(1,36);zeros(1,36);zeros(1,36)];
        elseif(k==16384)
            adaptive_vector = [feature_3(16255,:);feature_3(16256,:);zeros(1,36);feature_3(16383,:);feature_3(16384,:);zeros(1,36);zeros(1,36);zeros(1,36);zeros(1,36)];
        else
            adaptive_vector = [feature_3(k-129,:);feature_3(k-128,:);feature_3(k-127,:);feature_3(k,:);feature_3(k-1,:);feature_3(k+1,:);zeros(1,36);zeros(1,36);zeros(1,36)];
        end
    end
    
    if((k>128)&&(k<16257))%image的中间行
        if (rem(k,128)==1) %每一行的第一个元素
            adaptive_vector = [zeros(1,36);feature_3(k-128,:);feature_3(k-127,:);zeros(1,36);feature_3(k,:);feature_3(k+1,:);zeros(1,36);feature_3(k+128,:);feature_3(k+129,:)];
        elseif(rem(k,128)==0) %每一行的最后一个元素
            adaptive_vector = [feature_3(k-129,:);feature_3(k-128,:);zeros(1,36);feature_3(k-1,:);feature_3(k,:);zeros(1,36);feature_3(k+127,:);feature_3(k+128,:);zeros(1,36)];
        else
            adaptive_vector = [feature_3(k-129,:);feature_3(k-128,:);feature_3(k-127,:);feature_3(k-1,:);feature_3(k,:);feature_3(k+1,:);feature_3(k+127,:);feature_3(k+128,:);feature_3(k+129,:)];
        end
    end
    
    % calculate distance，9*50 ，假设窗口为3*3,每一个区域的词典大小为50
    E = pdist2(adaptive_vector,vocabulary_3,'euclidean'); 
    [~,v] = size(E);
    distance_vector = zeros(1,50);
    for j=1:v
        % 窗口中的各个区域的进行加权处理
        d = (E(1,j)+E(2,j)+E(3,j)+E(4,j)+E(5,j)+E(6,j)+E(7,j)+E(8,j)+E(9,j))/9;
        distance_vector(j) = d;
    end
    [~,I] = min(distance_vector,[],2); % 取距离最近的单词作为对应区域量化后对应的单词
    histogram(k) = I;
end
end