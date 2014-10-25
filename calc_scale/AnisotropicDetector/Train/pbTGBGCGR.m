% Classify all test images using TG+BG+CG+SR features
% The model is trained using the Liblinear

iids = imgList('test');
testDir = '..\data\test\';
saveDir = 'D:\user\v-xialiu\BoundaryDetectionEvaluation\BENCH11\color\pbTGBGCGR2\';

if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

norient = 8;

% % Load the model from file
% load('.\model\model_pb.mat');
% model_pb = model.model;
% fstd = model.fstd;

% This is using logist regression method instead of svm
beta = [-3.4405279e+000  5.8026148e-001  5.2128483e-001 -1.0689005e-001  1.8496820e-001  2.3844478e-001  3.8502336e-001];
fstd = [ 1.0000000e+000  1.9797222e-001  4.2076361e-001  4.0405722e-001  1.6169127e-001  2.2074381e-001  2.1298250e-002];
beta = beta ./ fstd;

gtheta = (0:norient-1)/norient*pi;

for i = 1:length(iids)
    fprintf(2, 'processing image %d...\n', iids(i));
    
    SRFilePath = sprintf('%sRS\\%d.mat',testDir, iids(i));
    TGFilePath = sprintf('%sraw\\TG\\%d.mat', testDir, iids(i));
    BGFilePath = sprintf('%sraw\\BG\\%d.mat', testDir, iids(i));
    CGFilePath = sprintf('%sraw\\CG\\%d.mat', testDir, iids(i));
    
    load(SRFilePath)
    load(TGFilePath);
    load(BGFilePath);
    load(CGFilePath);
    
    RMatrix = RSMatrix(:,:,1);
    
    rr = RMatrix(:);
    
    [h,w,unused] = size(tg);
    pball = zeros(h,w,norient);
    
    for j = 1:norient,
        t = tg(:,:,j); t = t(:);
        bb = bg(:,:,j); bb = bb(:);
        l = cg(:,:,1,j); l = l(:);
        a = cg(:,:,2,j); a = a(:);
        b = cg(:,:,3,j); b = b(:);
        
        x = [ones(size(b)) t bb l a b rr];
         
%         x = x ./repmat(fstd,size(x,1),1);
%         [predict_label, accuracy, pbi] = predict(ones(size(x,1), 1), sparse(x), model_pb, '-b 1');
        
        pbi = 1 ./ (1 + (exp(-x*beta')));
        
        pball(:,:,j) = reshape(pbi,[h w]);
    end
    
    [unused,maxo] = max(pball,[],3);
    pb = zeros(h,w);
    theta = zeros(h,w);
    
%     r = 2.5;
    r = 3.5;
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