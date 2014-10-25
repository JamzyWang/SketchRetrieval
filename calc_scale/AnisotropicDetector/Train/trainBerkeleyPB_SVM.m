% Thic program trains the classifier using SVM

clear model_pb;
clear f;
clear y;

%Sample Training Data
sampleTrainingDataTGBGCG;
save '.\TrainingSamples\BerkeleyPB\feature.mat' f;
save '.\TrainingSamples\BerkeleyPB\label.mat' y;

load '.\TrainingSamples\berkeleyPB\feature.mat';
load '.\TrainingSamples\berkeleyPB\label.mat';

f = f';
y = y';

disp('Normalizing features...');
fstd = std(f);
fstd = fstd + (fstd==0);
f = f ./ repmat(fstd,size(f,1),1);

% Training using SVM
disp('Training Classifer...');
model_pb = train(y, sparse(f),'-c 1');

model.model = model_pb;
model.fstd = fstd;

save '.\model\model_pb.mat' model;