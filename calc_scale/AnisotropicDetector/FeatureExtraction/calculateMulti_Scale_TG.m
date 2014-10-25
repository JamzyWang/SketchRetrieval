function calculateMulti_Scale_TG(startIndex, endIndex)

sourcePath = ['../data/' pres '/'];
desPath = ['../data/' pres '/raw/MultiTG/'];

nScale = 4;
% scaleRatio = sqrt(2);
scaleRatio = 1.1;

if exist(desPath, 'dir') == 0
    mkdir(desPath);
end
norient = 8;
% List all images in the test dir
filenames = dir([sourcePath '/*.jpg']);

for i = startIndex: min(endIndex,size(filenames,1))
    clear tg;
    fprintf(2,'Processing image %s\n', filenames(i).name);
    imgPath = fullfile(sourcePath, filenames(i).name);
    img = imread(imgPath);
    grayImg = double(rgb2gray(img)) / 256;
    radius = 0.02;
    for j = 1:nScale
%         grayImg = imresize(grayImg, 1/scaleRatio);
        [tg(:,:,:,j),gtheta] = detTG(grayImg,radius,norient);
        radius = radius * scaleRatio;
    end
    savePath = fullfile(desPath, strrep(filenames(i).name,'jpg','mat'));
    save(savePath, 'tg');
end