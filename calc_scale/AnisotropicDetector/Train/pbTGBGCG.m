% Classify all test images using TG+BG+CG features
% The model is trained using the Liblinear

iids = imgList('test');
testDir = '..\data\test\';
saveDir = 'D:\user\v-xialiu\BoundaryDetectionEvaluation\BENCH11\color\pbTGBGCG\';

if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

lambda = 0.9;
norient = 8;

% % Load the model from file
% load('.\model\model_pb.mat');
% model_pb = model.model;
% fstd = model.fstd;

% This is using logist regression method instead of svm
beta = [-4.4656374e+000  5.7444594e-001  6.9282658e-001 -1.1238742e-001  1.5697753e-001  2.1489896e-001];    
fstd = [1.0000000e+000  1.9084450e-001  3.7396070e-001  3.6934007e-001  1.4143325e-001  1.9417589e-001];
beta = beta ./ fstd;

gtheta = (0:norient-1)/norient*pi;

for i = 1:length(iids)
    fprintf(2, 'processing image %d...\n', iids(i));
    
    TGFilePath = sprintf('%sraw\\MultiTG\\%d.mat', testDir, iids(i));
    BGFilePath = sprintf('%sraw\\MultiBG\\%d.mat', testDir, iids(i));
    CGFilePath = sprintf('%sraw\\MultiCG\\%d.mat', testDir, iids(i));
    
    load(TGFilePath);
    load(BGFilePath);
    load(CGFilePath);
    
    tg = squeeze(tg(:,:,:,1));
    bg = squeeze(bg(:,:,:,1));
    cg = squeeze(cg(:,:,:,:,1));
    
    [h,w,unused] = size(tg);
    pball = zeros(h,w,norient);
    
    for j = 1:norient,
        t = tg(:,:,j); t = t(:);
        bb = bg(:,:,j); bb = bb(:);
        l = cg(:,:,1,j); l = l(:);
        a = cg(:,:,2,j); a = a(:);
        b = cg(:,:,3,j); b = b(:);
        x = [ones(size(b)) t bb l a b];
%         x = [t bb l a b];
        
%         x = x ./repmat(fstd,size(x,1),1);
%         [predict_label, accuracy, pbi] = predict(ones(size(x,1), 1), sparse(x), model_pb, '-b 1');
        
        pbi = 1 ./ (1 + (exp(-x*beta')));
        
        pball(:,:,j) = reshape(pbi,[h w]);
    end
    
    
    [unused,maxo] = max(pball,[],3);
    pb = zeros(h,w);
    theta = zeros(h,w);
    
    r = 2.5;
    for j = 1:norient,
        mask = (maxo == j);
        a = fitparab(pball(:,:,j),r,r,gtheta(j));
        pbi = nonmax(max(0,a),gtheta(j));
        pb = max(pb,pbi.*mask);
        theta = theta.*~mask + gtheta(j).*mask;
    end
    pb = max(0,min(1,pb));
    
%     pb = scale(pb, [0,1]);
    
    % mask out 1-pixel border where nonmax suppression fails
    pb(1,:) = 0;
    pb(end,:) = 0;
    pb(:,1) = 0;
    pb(:,end) = 0;

    pbiFilePath = sprintf('%s%d.bmp',saveDir, iids(i));
    imwrite(pb, pbiFilePath);
end