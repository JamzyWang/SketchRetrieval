%
%文件功能：在构造词典过程中，把extract_hog_feature_all_points.m处理后得到的特征按区域进行分类，I(x,y)分类到一起。
%输入参数：特征数据地址列表，一个txt文件，里面有所有特征的id。
%输出参数：得到分类后的特征数据，一个(x,y)对应一个_.f文件。
%

features_list = textread('features_from_benchmark_list.txt', '%s'); %features_from_benchmark_list.txt 特征数据列表
len = size(features_list);
len = len(1);
fprintf('len %d\n', len);
for n = 1:len  % 循环处理每一个特征文件（一副image对应一个特征文件）
    featurePath = features_list{n};
    fprintf('%d processing %s\n', n, featurePath);
    fid = fopen(featurePath);
    I = fread(fid,'single');
    I_2 = reshape(I,36,[]);
    I_3 = I_2';
    [i,j] = size(I_3);
    for k = 1:i % 循环处理每一个位置上的特征
        name = num2str(k);
        fid_f = fopen(fullfile('classify_data',strcat(name, '._f')), 'a');
        feature = I_3(k,:);
        fwrite(fid_f, feature, 'single');
        fclose(fid_f);
    end
    fclose(fid);
end

