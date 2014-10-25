% This file is used to count the distribution of scales, R, length... for
% boundaries.

iids = imgList('train');

scaleDistribution = [];
pixelRDistribution = [];
segRDistribution = [];
segLengthDistribution = [];

for i = 1:numel(iids)
    tic;
    iid = iids(i);
    fprintf(2,'Processing image %d/%d (iid=%d)...\n',i,numel(iids),iid);
    
    fprintf(2,'  Loading segmentations...\n');
    segs = readSegs('color',iid);
    bmap = zeros(size(segs{1}));
    
    for j = 1:numel(segs),
        bmap = bmap | seg2bmap(segs{j});
    end
    
    % Compute distance map to the nearest boundary pixel for each point
    dmap = bwdist(bmap);
    binaryMap = dmap <= 2;
    
    % Read feature
    fprintf(2,'  Reading Feature...\n');
    clear cdata;
    
    contourFilePath = sprintf('../data/train/contours/%d.mat', iid);
    
    if ~exist(contourFilePath, 'file')
        continue;
    end
    
    load(contourFilePath); 

    % largest scale
    imgSize = sqrt(cdata.contours.m^2 + cdata.contours.n^2);
    
    % sample
    fprintf(2,'  Sampling...\n');
    % Sample each segment
    
    segmentNum = length(cdata.contours.segments);
    
    scaleArray = zeros(segmentNum, 1);
    for j = 1:segmentNum
        segment = cdata.contours.segments{j};
        scaleArray(j) = segment.scale;
    end
    maxScale = max(scaleArray);
    
    for j = 1:segmentNum
        segment = cdata.contours.segments{j};
        segScale = segment.scale / maxScale;
        segR = segment.r;
        segLength = segment.length;
        % sample each and determine it to be positive or negative
        for k = 1:segLength
            pos_x = segment.segment(k,1);
            pos_y = segment.segment(k,2);
            
            if binaryMap(pos_x, pos_y)
                pixelR = segment.segment(k,4);
                %update distribution
                scaleDistribution = [scaleDistribution segScale];
                pixelRDistribution = [pixelRDistribution pixelR];
                segRDistribution = [segRDistribution segR];
                segLengthDistribution = [segLengthDistribution segLength / imgSize];
            end
        end
    end
    toc;
end

%into histogram
[scaleHist, scaleCenters] = hist(scaleDistribution, 100);
[pixelRHist, pixelRCenters] = hist(pixelRDistribution, 100);
[segRHist, segRCenters] = hist(segRDistribution, 100);
[segLengthHist, segLengthCenters] = hist(segLengthDistribution, 100);

clear scaleDistributioon;
clear pixelRDistribution;
clear segRDistribution;
clear segLengthDistribution;

%plot
disp('Ploting...');
figure;
plot(scaleCenters,scaleHist);

figure;
plot(pixelRCenters,pixelRHist);

figure;
plot(segRCenters, segRHist);

figure;
plot(segLengthCenters, segLengthHist);