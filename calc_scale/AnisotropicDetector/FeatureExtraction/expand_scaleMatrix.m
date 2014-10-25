% Expand the contours to RMatrix and scaleMatrix

%All image: List
pres = 'train';
% pres = 'test';
sourcePath = ['../data/' pres '/contours/';
desPath = ['../data/' pres '/RS/'];

if exist(desPath, 'dir') == 0
    mkdir(desPath);
end

% List all images in the test dir
filenames = dir([sourcePath '/*.mat']);

for i=1:size(filenames,1)
    contourFilePath = fullfile(sourcePath, filenames(i).name);

    fprintf(2, 'Processing %d / %d images...\n', i, size(filenames,1));
    load(contourFilePath);
    RSMatrix = zeros(cdata.contours.m, cdata.contours.n, 3);
%     RSMatrix(:,:,1) = cdata.contours.RMatrix;
    RSMatrix(:,:,1) = cdata.contours.allR;
    RSMatrix(:,:,2) = zeros(size(cdata.contours.RMatrix));
    RSMatrix(:,:,3) = zeros(size(cdata.contours.RMatrix));
    
    imgSize = sqrt(cdata.contours.m^2 + cdata.contours.n^2);
    
    segmentNum = length(cdata.contours.segments);
    scaleArray = zeros(segmentNum, 1);
    for j = 1:segmentNum
        segment = cdata.contours.segments{j};
        scaleArray(j) = segment.scale;
    end
    
    maxScale = max(scaleArray);
    
    for j = 1:segmentNum
        segment = cdata.contours.segments{j};
        for k = 1:segment.length
            RSMatrix(segment.segment(k,1), segment.segment(k,2), 2) = segment.scale / maxScale;
%             RSMatrix(segment.segment(k,1), segment.segment(k,2), 2) = segment.scale;
            RSMatrix(segment.segment(k,1), segment.segment(k,2), 3) = segment.length / imgSize;
        end
    end
    
    savePath = fullfile(desPath, filenames(i).name);
    
    save(savePath, 'RSMatrix');
end