% Learning Scales using TG, BG, CG features

% sample training data
iids = imgList('train');

nper = 1000;

clear f;
clear y;

y = zeros(1,0);
f = [];

octave = 4;

for i = 1:numel(iids)
    tic;
    iid = iids(i);
    fprintf(2,'Processing image %d/%d (iid=%d)...\n',i,numel(iids),iid);
    
    % Read feature
    fprintf(2,'  Reading Feature...\n');
    clear tg;
    clear bg;
    clear cg;
    
    RSFilePath = sprintf('../data/train/RS/%d.mat', iid);
    TGFilePath = sprintf('../data/train/raw/MultiTG/%d.mat', iid);
    BGFilePath = sprintf('../data/train/raw/MultiBG/%d.mat', iid);
    CGFilePath = sprintf('../data/train/raw/MultiCG/%d.mat', iid);
        
    if ~exist(RSFilePath, 'file')
        continue;
    end
    
    load(RSFilePath);
    load(TGFilePath);
    load(BGFilePath);
    load(CGFilePath);
    
    RMatrix = RSMatrix(:,:,1);
    SMatrix = RSMatrix(:,:,2);
    SMatrix = ceil(SMatrix * octave - eps);
    
    dmap = bwdist(SMatrix > 0);
    
    % Construct Features
    t = zeros(size(RMatrix,1) * size(RMatrix, 2), octave);
    bb = zeros(size(RMatrix,1) * size(RMatrix, 2), octave);
    l = zeros(size(RMatrix,1) * size(RMatrix, 2), octave);
    a = zeros(size(RMatrix,1) * size(RMatrix, 2), octave);
    b = zeros(size(RMatrix,1) * size(RMatrix, 2), octave);
    
    clear tempt;
    clear tempbb;
    clear templ;
    clear tempa;
    clear tempb;
    
    for j = 1:octave
        tempt(:,:) = max(squeeze(tg(:,:,:,j)),[],3);
        tempbb(:,:) = max(squeeze(bg(:,:,:,j)),[],3);
        templ(:,:) = max(squeeze(cg(:,:,1,:,j)),[],3);
        tempa(:,:) = max(squeeze(cg(:,:,2,:,j)),[],3);
        tempb(:,:) = max(squeeze(cg(:,:,3,:,j)),[],3);
        
        t(:,j) = tempt(:);
        bb(:,j) = tempbb(:);
        l(:,j) = templ(:);
        a(:,j) = tempa(:);
        b(:,j) = tempb(:);
        
%         % Feature Normalization: Using the smallest scale
%         t(:,j) = t(:,j) ./ (t(:,1) + eps);
%         bb(:,j) = bb(:,j) ./ (bb(:,1) + eps);
%         l(:,j) = l(:,j) ./ (l(:,1) + eps);
%         a(:,j) = a(:,j) ./ (a(:,1) + eps);
%         b(:,j) = b(:,j) ./ (b(:,1) + eps);
    end
    
    clear feature;
%     feature = [ones(size(b,1),1) t bb l a b rr]';
    feature = [t bb l a b]';
    
    ind = find(SMatrix > 0)';
    idx = randperm(min(nper, numel(ind)));
    
    offind = find((SMatrix == 0) .* (dmap > 4))';
    offidx = randperm(min(nper, numel(ind)));
    
    y = [y SMatrix(ind(idx))];
    f = [f feature(:, ind(idx))];
    
    y = [y SMatrix(offind(offidx))];
    f = [f feature(:, offind(offidx))];
    
    toc;
end

save '.\TrainingSamples\learningScale\feature.mat' f;
save '.\TrainingSamples\learningScale\label.mat' y;

clear f;
clear y;

load '.\TrainingSamples\learningScale\feature.mat';
load '.\TrainingSamples\learningScale\label.mat';

% fitting model
f = f';
y = y';

disp('Normalizing features...');
fstd = std(f);
fstd = fstd + (fstd==0);
f = f ./ repmat(fstd,size(f,1),1);

% fit the model
fprintf(2,'Fitting model...\n');
% beta = logist2(y,f);
clear scale_model;
scale_model = train(y, sparse(f),'-c 1');
% scale_model = train(y, sparse(f(:,2:22)),'-c 1');
% save the result
% save(sprintf('.\\model\\beta_learningScale.txt'),'fstd','beta','-ascii');
model.model = scale_model;
model.fstd = fstd;
save '.\model\learningScaleSVM.mat' model;
disp('Training Complete!');
