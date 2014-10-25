function calculateTG(startIndex, endIndex, pres )

sourcePath = ['../data/' pres '/'];
desPath = ['../data/' pres '/raw/TG/'];

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
    radius = 0.02 / sqrt(2);
    [tg,gtheta] = detTG(grayImg,radius,norient);
    
    savePath = fullfile(desPath, strrep(filenames(i).name,'jpg','mat'));
    save(savePath, 'tg');
end

end