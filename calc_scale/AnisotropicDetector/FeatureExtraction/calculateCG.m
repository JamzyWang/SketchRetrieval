function calculateCG( startIndex, endIndex, pres )

sourcePath = ['../data/' pres '/'];
desPath = ['../data/' pres '/raw/CG/'];

if exist(desPath, 'dir') == 0
    mkdir(desPath);
end
norient = 8;
% List all images in the test dir
filenames = dir([sourcePath '/*.jpg']);

for i = startIndex: min(endIndex,size(filenames,1))
    clear cg;
    fprintf(2,'Processing image %s\n', filenames(i).name);
    imgPath = fullfile(sourcePath, filenames(i).name);
    img = imread(imgPath);
    img = double(img) / 256;
    radius = 0.02 / sqrt(2);
    [cg,gtheta] = detCG(img,radius,norient);
    
    savePath = fullfile(desPath, strrep(filenames(i).name,'jpg','mat'));
    save(savePath, 'cg');
end

end