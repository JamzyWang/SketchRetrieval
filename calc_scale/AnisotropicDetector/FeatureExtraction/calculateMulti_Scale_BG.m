function calculateMulti_Scale_BG(startIndex, endIndex, pres)
%% Pres is 'test' or 'train'
sourcePath = ['../data/' pres '/'];
desPath = ['../data/' pres '/raw/MultiBG/'];

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
    clear bg;
    fprintf(2,'Processing image %s\n', filenames(i).name);
    imgPath = fullfile(sourcePath, filenames(i).name);
    img = imread(imgPath);
    grayImg = double(rgb2gray(img)) / 256;
    radius = 0.01;
    for j = 1:nScale
        [bg(:,:,:,j),gtheta] = detBG(grayImg,radius,norient);
        radius = radius * scaleRatio;
    end
    savePath = fullfile(desPath, strrep(filenames(i).name,'jpg','mat'));
    save(savePath, 'bg');
end