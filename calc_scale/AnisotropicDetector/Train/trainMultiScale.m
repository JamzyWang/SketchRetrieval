clear model;
octave = 4;
model.beta = [];
model.fstd = [];

%Sample Training Data
for scaleIndex = 1:octave
    fprintf(2, 'Dealing with Scale = %d/%d \n', scaleIndex, octave);
    disp('Sampling...');
    clear f;
    clear y;
    [f,y] = sampleTrainingDataMultiScale(10000, 3, scaleIndex, octave, 'train');
    save(sprintf('.\\TrainingSamples\\MultiScale\\feature_R_%d.mat',scaleIndex),'f');
    save(sprintf('.\\TrainingSamples\\MultiScale\\label_R_%d.mat',scaleIndex),'y');
%     save(sprintf('.\\TrainingSamples\\MultiScale\\feature_%d.mat',scaleIndex),'f');
%     save(sprintf('.\\TrainingSamples\\MultiScale\\label_%d.mat',scaleIndex),'y');
    
    f = f';
    y = y';
    
    disp('Normalizing features...');
    fstd = std(f);
    fstd = fstd + (fstd==0);
    f = f ./ repmat(fstd,size(f,1),1);
    
    % fit the model
    fprintf(2,'Fitting model...\n');
    beta = logist2(y,f);
    
    disp('Training Complete!');
    model.beta = [model.beta; beta'];
    model.fstd = [model.fstd; fstd];
end

disp('Saving Models...');
% save the result
save(sprintf('.\\model\\Model_MultiScale_R.mat'),'model');
% save(sprintf('.\\model\\Model_MultiScale.mat'),'model');