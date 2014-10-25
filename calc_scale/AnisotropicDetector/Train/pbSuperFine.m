% Classify all test images using TG+BG+CG+SR features

iids = imgList('test');
testDir = '..\data\test\';
saveDir = 'D:\user\v-xialiu\BoundaryDetectionEvaluation\BENCH11\color\ScaleSpecificPBR\';

if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

norient = 8;
octave = 4;

se = strel ('disk' ,2);

clear model;
% modelPath = '.\model\Model_MultiScale.mat';
modelPath = '.\model\Model_MultiScale_R.mat';
load(modelPath);

superfineModelPath = '.\model\SuperFine.mat';
sfModel = load(superfineModelPath);

gtheta = (0:norient-1)/norient*pi;

for i = 1:length(iids)
    fprintf(2, 'processing image %d [%d / %d]...\n', iids(i), i, length(iids));
    
    SRFilePath = sprintf('%sRS\\%d.mat',testDir, iids(i));
    TGFilePath = sprintf('%sraw\\MultiTG\\%d.mat', testDir, iids(i));
    BGFilePath = sprintf('%sraw\\MultiBG\\%d.mat', testDir, iids(i));
    CGFilePath = sprintf('%sraw\\MultiCG\\%d.mat', testDir, iids(i));
    
    SFTGFilePath = sprintf('%sraw\\TG\\%d.mat', testDir, iids(i));
    SFBGFilePath = sprintf('%sraw\\BG\\%d.mat', testDir, iids(i));
    SFCGFilePath = sprintf('%sraw\\CG\\%d.mat', testDir, iids(i));
    
    fprintf(2,'  Reading Feature...\n');
    clear tg;
    clear bg;
    clear cg;
    clear scaleMap;
    
    load(SRFilePath)
    load(TGFilePath);
    load(BGFilePath);
    load(CGFilePath);
    
    sftg = load(SFTGFilePath);
    sfbg = load(SFBGFilePath);
    sfcg = load(SFCGFilePath);
    
    RMatrix = RSMatrix(:,:,1);
	SMatrix = RSMatrix(:,:,2);
    SMatrix = ceil(SMatrix * octave);
    
    for m = 1:octave
        SMatrix = max(SMatrix, m * imdilate((SMatrix == m),se));
    end
    
    %% First classify the super fine scale
    [h,w,unused] = size(tg);
    pball = zeros(h,w,norient);
    beta = sfModel.model.beta ./ sfModel.model.fstd';
    for j = 1:norient,
        t = sftg.tg(:,:,j); t = t(:);
        bb = sfbg.bg(:,:,j); bb = bb(:);
        l = sfcg.cg(:,:,1,j); l = l(:);
        a = sfcg.cg(:,:,2,j); a = a(:);
        b = sfcg.cg(:,:,3,j); b = b(:);
        
        x = [ones(size(b)) t bb l a b];     
        pbi = 1 ./ (1 + (exp(-x*beta)));
        
        pball(:,:,j) = reshape(pbi,[h w]);
    end
    
    [unused,maxo] = max(pball,[],3);
    pb = zeros(h,w);
    theta = zeros(h,w);
    
    disp('Fitparab...');
    r = 2.5;
    for j = 1:norient,
        mask = (maxo == j);
        a = fitparab(pball(:,:,j),r,r,gtheta(j));
        pbi = nonmax(max(0,a),gtheta(j));
        pb = max(pb,pbi.*mask);
    end
    pb = max(0,min(1,pb));
    
    %% Calculate the response on specific scale
    for m = 0:octave
        beta = model.beta(max(m,1),:) ./ model.fstd(max(m,1),:);
        tg2 = squeeze(tg(:,:,:,max(1,m)));
        bg2 = squeeze(bg(:,:,:,max(1,m)));
        cg2 = squeeze(cg(:,:,:,:,max(1,m)));
        
        pbmask = (pb > 0.1) .* (SMatrix == m);
        pball = zeros(h,w,norient);
        
        for j = 1:norient,
            t = tg2(:,:,j); t = t(:);
            bb = bg2(:,:,j); bb = bb(:);
            l = cg2(:,:,1,j); l = l(:);
            a = cg2(:,:,2,j); a = a(:);
            b = cg2(:,:,3,j); b = b(:);
            rr = RMatrix(:);
            
%             x = [ones(size(b)) t bb l a b];
            x = [ones(size(b)) t bb l a b rr];
            pbi = 1 ./ (1 + (exp(-x*beta')));
            pbi = reshape(pbi,[h,w]);
            pbi = fitparab(pbi,2*r,r/2,gtheta(j)) .* pbmask;
            pball(:,:,j) = pbi * 1.2;
        end
        % update pb
        pbm = max(pball,[],3);
        pb(pbmask>0) = pbm(pbmask>0);
    end
    
    %% Post processing
    % mask out 1-pixel border where nonmax suppression fails
    pb(1,:) = 0;
    pb(end,:) = 0;
    pb(:,1) = 0;
    pb(:,end) = 0;

    pbiFilePath = sprintf('%s%d.bmp',saveDir, iids(i));
    imwrite(pb, pbiFilePath);
end