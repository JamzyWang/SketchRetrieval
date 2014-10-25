% function [f,y] = sampleTrainingData(nPer, buffer)
% Sample training data
iids = imgList('train');

% number of samples for each training image
nPer = 10000;
buffer = 2;

y = zeros(1,0);
f = [];

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
    
    % Read feature
    fprintf(2,'  Reading Feature...\n');
    clear tg;
    clear bg;
    clear cg;
    
    RSFilePath = sprintf('../data/train/RS/%d.mat', iid);
    TGFilePath = sprintf('../data/train/raw/TG/%d.mat', iid);
    BGFilePath = sprintf('../data/train/raw/BG/%d.mat', iid);
    CGFilePath = sprintf('../data/train/raw/CG/%d.mat', iid);
        
    if ~exist(RSFilePath, 'file')
        continue;
    end
    
    load(RSFilePath);
    load(TGFilePath);
    load(BGFilePath);
    load(CGFilePath);
    
    RMatrix = RSMatrix(:,:,1);
    
    l = max(squeeze(cg(:,:,1,:)),[],3);
    a = max(squeeze(cg(:,:,2,:)),[],3);
    b = max(squeeze(cg(:,:,3,:)),[],3);
    t = max(tg,[],3);
    bb = max(bg, [], 3);
    l = l(:);
    a = a(:);
    b = b(:);
    t = t(:);
    bb = bb(:);
    rr = RMatrix(:);
    
    feature = [ ones(size(b)) t bb l a b rr]';

    onind = find(bmap)';
%     onind = find(bmap .* RMatrix)';
%     onind2 = find(bmap .* (RMatrix < 0.0001))';
    offind = find((dmap>buffer))';
    
    onidx = randperm(numel(onind));
%     onidx2 = randperm(numel(onind2));
    offidx = randperm(numel(offind));
    
    onidx = onidx(1:min(numel(onidx), 0.2*nPer));
%     onidx2 = onidx(1:min(numel(onidx2), 0.2*nPer));
    offidx = offidx(1:min(numel(offidx), 0.8*nPer));
    
    if numel(onind) > 0
        y = [y bmap(onind(onidx))];
        f = [f feature(:, onind(onidx))];
    end
    
%     if numel(onind2) > 0
%         y = [y bmap(onind(onidx2))];
%         f = [f feature(:, onind2(onidx2))];
%     end
    
    if numel(offind) > 0
        y = [y bmap(offind(offidx))];
        f = [f feature(:, offind(offidx))];
    end
    
    toc;
end