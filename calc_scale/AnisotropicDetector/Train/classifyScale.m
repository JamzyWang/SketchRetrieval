% classify scales
iids = imgList('train');
testDir = '..\data\train\';
saveDir = '..\data\train\learnedScaleMap\';

load '.\model\learningScaleSVM.mat';
fstd = model.fstd;

% beta = [-3.4405279e+000  5.8026148e-001  5.2128483e-001 -1.0689005e-001  1.8496820e-001  2.3844478e-001  3.8502336e-001];
% fstd = [ 1.0000000e+000  1.9797222e-001  4.2076361e-001  4.0405722e-001  1.6169127e-001  2.2074381e-001  2.1298250e-002];
% beta = beta ./ fstd;

if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

for i = 1:length(iids)
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
    
    [h,w] = size(RMatrix);
    
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
    clear scaleMap;
%     feature = [ones(size(b,1),1) t bb l a b rr];
    feature = [t bb l a b];
    
    feature = feature ./repmat(fstd,size(feature,1),1);
    
    % Classify
    [predict_label, accuracy, scaleMap] = predict(ones(size(feature,1), 1), sparse(feature), model.model, '-b 1');
    
%     [scoreMap, scaleMap] = max(scaleMap, [], 2);
%     scaleMap = scaleMap - 1;
%     scaleMap = scaleMap .* (scoreMap > 0);
%     scaleMap = 1 ./ (1 + (exp(-feature'*beta')));
    
    scaleMap = reshape(predict_label,[h w]);
    
    scaleMapFilePath = sprintf('%s%d.mat',saveDir, iids(i));
    save(scaleMapFilePath, 'scaleMap');
end