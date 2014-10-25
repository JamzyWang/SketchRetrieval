%% This is the batch processing of edge detection using scale-selection on 
%% anistotropic edge detector
version = 'v20111126';

methodName = 'SegSelection';
% methodName = 'SegPropagation';
% methodName = 'PixelWise';

% define path to directory that contains the test images
sourcePath = '../data/benchmark/';
% define path to directory that saves all contour images
desPath = '../data/benchmark/';

if exist(desPath, 'dir') == 0
    mkdir(desPath);
end

% List all images in the test dir
filenames = dir([sourcePath '/*.jpg']);

%% Max scale value
Tmax = 30;

lower_t = 3;
sigmaArray = [2.7];
for p = 1:size(sigmaArray, 2)
    sigma = sigmaArray(p);
    
    subdirPath = sprintf('%s\\%s\\Edges/', desPath, methodname);
    if exist(subdirPath, 'dir') == 0
        mkdir(subdirPath);
    end
    
    for j=1:size(filenames,1)
        imgPath = fullfile(sourcePath, filenames(j).name);
        fprintf(2, '[%s] Begin - %d of %d\n', filenames(j).name, j, size(filenames,1));
        
        % First resize image to maximum 640
        img = imread(imgPath);
        resizeRate = 640 / max(size(img,1), size(img,2));
        img = imresize(img, resizeRate);
        imwrite(img, imgPath);
        [ I ] = scale_selection_edgedetector(imgPath, Tmax, sigma, lower_t, Tmax - 3, 0, methodName);

        boundaryImg = I(:,:,:,1);
        savePath = fullfile(subdirPath, strrep(filenames(j).name,'jpg','bmp'));
        
        saveBoundaryImg(boundaryImg, savePath);
        
        fprintf(2,'[%s] Complete!\n', filenames(j).name);
    end
end

