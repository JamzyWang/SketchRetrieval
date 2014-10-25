% function [f,y] = sampleTrainingData(nPer, buffer)
% Sample training data
iids = imgList('train');

% number of samples for each training image
nPer = 5000;
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
    
    TGFilePath = sprintf('../data/train/raw/TG/%d.mat', iid);
    BGFilePath = sprintf('../data/train/raw/BG/%d.mat', iid);
    CGFilePath = sprintf('../data/train/raw/CG/%d.mat', iid);
    
    load(TGFilePath);
    load(BGFilePath);
    load(CGFilePath);
    
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
    
    feature = [ ones(size(b)) t bb l a b]';
%     feature = [t bb l a b]';

    onidx = find(bmap)';
    offidx = find(dmap>buffer)';
    
    ind = [ onidx offidx ];
    
    cnt = numel(ind);
    idx = randperm(cnt);
    
    idx = idx(1:min(cnt,nPer));
    y = [y bmap(ind(idx))];
    
    f = [f feature(:, ind(idx))];
    
    fprintf(2,'  %d samples.\n',numel(idx));
    toc;
end