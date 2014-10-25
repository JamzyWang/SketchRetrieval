clear model_pb;
clear f;
clear y;

% %Sample Training Data
% sampleTrainingDataTGBGCG;
% save '.\TrainingSamples\BerkeleyPB\logist_feature.mat' f;
% save '.\TrainingSamples\BerkeleyPB\logist_label.mat' y;

load '.\TrainingSamples\berkeleyPB\logist_feature.mat';
load '.\TrainingSamples\berkeleyPB\logist_label.mat';

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
save(sprintf('beta_tgbgcg_color.txt'),'fstd','beta','-ascii');