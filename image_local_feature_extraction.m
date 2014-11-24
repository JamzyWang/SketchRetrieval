%
%�ļ����ܣ���������ͼƬ��local feature
%��������� ������Ե����ͼ��
%��������� ͼƬ��local feature��һ��image��Ӧһ��.mat�ļ�
%
images_list = textread('edge_full.list', '%s'); % edge_full.listΪ������Ե��ȡ���ͼ���ļ����б�
len = size(images_list);
len = len(1);
fprintf('len %d\n', len);
for n = 1:len  % ѭ������ÿһ��ͼƬ
    imgPath = images_list{n};
    
    fprintf('%d processing %s\n', n, imgPath);
    image = load(imgPath,'a');
    
    [hog_feature] = feature_extraction_local( image.a);
    
    [filethstr, name, ext] = fileparts(imgPath);
    str = strcat('image_feature/',name);
    filename = strcat(str,'_local');
    save(filename,'hog_feature');   %   ����local feature
    
    fprintf('%d finished %s\n', n, imgPath);    
end


