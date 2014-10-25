%% This is the batch processing of edge detection using scale-selection on 
%% anistotropic edge detector
version = 'v20120409';

methodName = 'SegSelection';
% methodName = 'SegPropagation';
% methodName = 'PixelWise';

% define path to directory that contains the test images
sourcePath = '../data/test/';
% define path to directory that saves all contour images
desPath = 'D:\user\v-xialiu\BoundaryDetectionEvaluation\BENCH12\color';

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
    
    for i = 1:length(lower_t)
        t_i = lower_t(i);
        subdirPath = sprintf('%s\\NonTG_%s_%s_t = %d/', desPath, methodname, version, t_i);
        if exist(subdirPath, 'dir') == 0
            mkdir(subdirPath);
        end
        
        %% Write Name.txt file
        fid = fopen([subdirPath, '\name.txt'],'wt');
        fprintf(fid, 'NonTG + %s + %s + t=%d', methodname, version, t_i);
        fclose(fid);
    end
    
    for j=1:size(filenames,1)
        imgPath = fullfile(sourcePath, filenames(j).name);
        fprintf(2, '[%s] Begin - %d of %d\n', filenames(j).name, j, size(filenames,1));
        
        [ I ] = scale_selection_edgedetector(imgPath, Tmax, sigma, lower_t, Tmax - 3, 18, methodName);
        
        for i = 1:length(lower_t)
            t_i = lower_t(i);
            subdirPath = sprintf('%s\\NonTG_%s_%s_t = %d/', desPath, methodname, version, t_i);
            boundaryImg = I(:,:,:,i);
            savePath = fullfile(subdirPath, strrep(filenames(j).name,'jpg','bmp'));
            
            saveBoundaryImg(boundaryImg, savePath);
        end
        
        fprintf(2,'[%s] Complete!\n', filenames(j).name);
    end
end

