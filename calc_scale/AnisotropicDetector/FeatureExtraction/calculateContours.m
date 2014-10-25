function calculateContours(startIndex, endIndex)

%All image: List
sourcePath = '../data/train/';
desPath = '../data/train/contours/';

if exist(desPath, 'dir') == 0
    mkdir(desPath);
end

t = 30;
sigma = 2.7;
% List all images in the test dir
filenames = dir([sourcePath '/*.jpg']);

for i=startIndex:min(endIndex, size(filenames,1))
    imgPath = fullfile(sourcePath, filenames(i).name);
    
    img = imread(imgPath);
    [ y, scaleMat, R, dx0, dy0, contours]  = andiff( img, [], linspace(1.2,16,t),sigma,3, 1000,t);
    
    contourFileName = fullfile(desPath, strrep(filenames(i).name,'jpg','mat'));
    
    cdata.scaleMat = scaleMat;
    cdata.R = R;
    cdata.contours = contours;
    
    save(contourFileName, 'cdata');
end