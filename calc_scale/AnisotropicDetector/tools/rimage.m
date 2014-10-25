%% Reverse the grey level of images
sourcePath = 'BoundaryDetectionResults/scale-specific/';

filenames = dir([sourcePath '/*.bmp']);

for i = 1:size(filenames,1)
    imgPath = fullfile(sourcePath, filenames(i).name);
    img = imread(imgPath);
    imwrite(255-img, imgPath);
end