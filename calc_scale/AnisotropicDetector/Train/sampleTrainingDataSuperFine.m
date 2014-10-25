function [f,y] = sampleTrainingDataSuperFine(nPer, buffer, pres)
% Sample training data
iids = imgList(pres);

% number of samples for each training image

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
    
    % The folder TG BG and CG is the feature of super fine scales
    % The multi-scale features are stored at MultiBG, MultiCG, and MultiTG
    TGFilePath = sprintf('../data/%s/raw/TG/%d.mat', pres, iid);
    BGFilePath = sprintf('../data/%s/raw/BG/%d.mat', pres, iid);
    CGFilePath = sprintf('../data/%s/raw/CG/%d.mat', pres, iid);

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

    onind = find(bmap)';
    offind = find((dmap>buffer))';
    
    onidx = randperm(numel(onind));
    offidx = randperm(numel(offind));
    
    onidx = onidx(1:min(numel(onidx), 0.2*nPer));
    offidx = offidx(1:min(numel(offidx), 0.8*nPer));
    
    if numel(onind) > 0
        y = [y bmap(onind(onidx))];
        f = [f feature(:, onind(onidx))];
    end
    
    if numel(offind) > 0
        y = [y bmap(offind(offidx))];
        f = [f feature(:, offind(offidx))];
    end
    
    toc;
end