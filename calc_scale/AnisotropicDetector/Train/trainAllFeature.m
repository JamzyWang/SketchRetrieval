clear model_allFeature;
clear f;
clear y;

%Sample Training Data
sampleTrainingDataTGBGCGSRL;
save '.\TrainingSamples\allFeature\feature.mat' f;
save '.\TrainingSamples\allFeature\label.mat' y;

load '.\TrainingSamples\allFeature\feature.mat';
load '.\TrainingSamples\allFeature\label.mat';

f = f';
y = y';

disp('Normalizing features...');
fstd = std(f);
fstd = fstd + (fstd==0);
f = f ./ repmat(fstd,size(f,1),1);

% fit the model
fprintf(2,'Fitting model...\n');
beta = logist2(y,f);
% save the result
save(sprintf('.\\model\\beta_TGBGCGSR_color.txt'),'fstd','beta','-ascii');