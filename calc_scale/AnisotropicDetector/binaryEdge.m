%Generate binary edge

sourcePath = 'data/test/';
contourPath = 'data/test/contours/';
desPath = 'D:\user\v-xialiu\BoundaryDetectionEvaluation\BENCH6\color\binaryEdge\';

if exist(desPath, 'dir') == 0
    mkdir(desPath);
end

threshold = 0.02;

% List all images in the test dir
filenames = dir([sourcePath '/*.jpg']);

for i=1:size(filenames,1)
    imgPath = fullfile(sourcePath, filenames(i).name);
    fprintf(2, '[%s] Begin - %d of %d\n', filenames(i).name, i, size(filenames,1));
    
    savePath = fullfile(desPath, strrep(filenames(i).name,'jpg','bmp'));
    contourFile = fullfile(contourPath, strrep(filenames(i).name,'jpg','mat'));
    load(contourFile);
    
    m = cdata.contours.m;
    n = cdata.contours.n;
    
    edgeImg = zeros(m,n);
    
    for j = 1:length(cdata.contours.segments)
        segment = cdata.contours.segments{j};
        for k = 1:segment.length
            if segment.segment(k,4) > threshold
                edgeImg(segment.segment(k,1), segment.segment(k,2)) = 1;
            end
        end
    end
    imwrite(edgeImg, savePath);
%     saveBoundaryImg(boundaryImg(:,:,:,1), savePath);
    fprintf(2,'[%s] Complete!\n', filenames(i).name);
end