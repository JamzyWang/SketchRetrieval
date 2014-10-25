function [f,y] = sampleTrainingDataMultiScale(nPer, buffer, scale, octave, pres)
% Sample training data for give scale
iids = imgList(pres);

% number of samples for each training image
% nPer = 10000;
% buffer = 3;
% octave = 4;

y = zeros(1,0);
f = [];

se = strel ('disk' ,2);

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
    clear scaleMap;
    
    RSFilePath = sprintf('../data/%s/RS/%d.mat', pres, iid);
    TGFilePath = sprintf('../data/%s/raw/MultiTG/%d.mat', pres, iid);
    BGFilePath = sprintf('../data/%s/raw/MultiBG/%d.mat', pres, iid);
    CGFilePath = sprintf('../data/%s/raw/MultiCG/%d.mat', pres, iid);
        
    if ~exist(RSFilePath, 'file')
        continue;
    end
    
    load(RSFilePath);
    load(TGFilePath);
    load(BGFilePath);
    load(CGFilePath);
%     load(ScaleMapPath);
    
    RMatrix = RSMatrix(:,:,1);
    SMatrix = RSMatrix(:,:,2);
    SMatrix = ceil(SMatrix * octave);
    
    for m = 1:octave
        SMatrix = max(SMatrix, m * imdilate((SMatrix == m),se));
    end
   
    l = zeros(size(cg,1), size(cg,2));
    a = zeros(size(cg,1), size(cg,2));
    b = zeros(size(cg,1), size(cg,2));
    t = zeros(size(cg,1), size(cg,2));
    bb = zeros(size(cg,1), size(cg,2));
    
    % Actually, under this senario, normalization has no effects
%     l = l + max(squeeze(cg(:,:,1,:,max(1,scale))),[],3) .* (SMatrix == scale);
%     a = a + max(squeeze(cg(:,:,2,:,max(1,scale))),[],3) .* (SMatrix == scale);
%     b = b + max(squeeze(cg(:,:,3,:,max(1,scale))),[],3) .* (SMatrix == scale);
%     t = t + max(tg(:,:,:,max(1,scale)),[],3) .* (SMatrix == scale);
%     bb = bb + max(bg(:,:,:,max(1,scale)), [], 3) .* (SMatrix == scale);
    
    l = l + max(squeeze(cg(:,:,1,:,max(1,scale))),[],3);
    a = a + max(squeeze(cg(:,:,2,:,max(1,scale))),[],3);
    b = b + max(squeeze(cg(:,:,3,:,max(1,scale))),[],3);
    t = t + max(tg(:,:,:,max(1,scale)),[],3);
    bb = bb + max(bg(:,:,:,max(1,scale)), [], 3);
    
    l = l(:);
    a = a(:);
    b = b(:);
    t = t(:);
    bb = bb(:);
    rr = RMatrix(:);
    
    feature = [ ones(size(b)) t bb l a b rr]';
%     feature = [ ones(size(b)) t bb l a b]';

%     onind = find(bmap .* (SMatrix == scale))';
    onind = find(bmap)';
%     offind = find((dmap>buffer).* (SMatrix == scale))';
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
    
    fprintf(2,'Sampled %d / %d points\n', numel(onidx), numel(offidx));
    toc;
end