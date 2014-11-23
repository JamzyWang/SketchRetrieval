function [] = divide_image_and_save(image)

%%  原始图像：未分割
% figure; 
% imshow(image);

%%  分割为：2*2    每个大小为：128*128
% figure(1);
% count = 1;
C1 = mat2cell(image,[128 128],[128 128]);
for i=1:2
    for j =1:2
        filename = strcat(strcat(strcat(strcat('C1_',int2str(i)),'_'),int2str(j)), '.png');
%         imwrite(C1{i,j},filename);
%         subplot(2,2,count);
%         count = count +1 ;
%         imshow(C1{i,j});
    end
end
%  print(1, '-dpng', 'C1');   
    
%%  分割为：4*4    每个大小为：64*64
% figure(2);
% count = 1;
C2 = mat2cell(image,[64 64 64 64],[64 64 64 64]);
for i=1:4
    for j =1:4
        filename = strcat(strcat(strcat(strcat('C2_',int2str(i)),'_'),int2str(j)), '.png');
%         imwrite(C2{i,j},filename);
%         subplot(4,4,count);
%         count = count +1 ;
%         imshow(C2{i,j});
    end
end
%  print(2, '-dpng', 'C2');   
%%  分割为：8*8    每个大小为：32*32
% figure(3);
% count = 1;
C3 = mat2cell(image,[32 32 32 32 32 32 32 32],[32 32 32 32 32 32 32 32]);
for i=1:8
    for j =1:8
        filename = strcat(strcat(strcat(strcat('C3_',int2str(i)),'_'),int2str(j)), '.png');
        imwrite(C3{i,j},filename);
%         subplot(8,8,count);
%         count = count +1 ;
%         imshow(C3{i,j});
    end
end
%  print(3, '-dpng', 'C3');   
%%  分割为:16*16   每个大小为：16*16
% figure;
% count = 1;
C4 = mat2cell(image,[16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16],[16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]);
for i=1:16
    for j =1:16
        filename = strcat(strcat(strcat(strcat('C4_',int2str(i)),'_'),int2str(j)), '.png');
%         imwrite(C4{i,j},filename);
%         subplot(16,16,count);
%         count = count +1 ;
%         imshow(C4{i,j});
    end
end

%%分割为：32*32  每个大小为：8*8
% figure;
% count = 1;
C5 = mat2cell(image,[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8],[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8]);
for i=1:32
    for j =1:32
        filename = strcat(strcat(strcat(strcat('C5_',int2str(i)),'_'),int2str(j)), '.png');
%         imwrite(C5{i,j},filename);
%         subplot(32,32,count);
%         count = count +1 ;
%         imshow(C5{i,j});
    end
end

%%
end % end of function