clear model;
clear f;
clear y;

%Sample Training Data
[f,y] = sampleTrainingDataSuperFine(10000,3, 'train');

save('.\TrainingSamples\SuperFine\feature.mat', 'f');
save('.\TrainingSamples\SuperFine\label.mat', 'y');

f = f';
y = y';

disp('Normalizing features...');
fstd = std(f);
fstd = fstd + (fstd==0);
f = f ./ repmat(fstd,size(f,1),1);

% fit the model
fprintf(2,'Fitting model...\n');
beta = logist2(y,f);

model.beta = beta;
model.fstd = fstd;

disp('Saving Models...');
% save the result
save(sprintf('.\\model\\SuperFine.mat'),'model');