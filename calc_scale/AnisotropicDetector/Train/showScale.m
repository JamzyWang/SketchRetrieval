iids = imgList('test');

for i = 1:numel(iids)
    iid = iids(i);
    scaleMapPath = sprintf('../data/test/learnedScaleMap/%d.mat', iid);
    
    load(scaleMapPath);
    
    figure(1);
    colormap(gray);
    subplot(2,3,1);
    imagesc(scaleMap);
    title('Learned Scale Map');
    subplot(2,3,2);
    imagesc(scaleMap == 1);
    title('Scale = 1');
    subplot(2,3,3);
    imagesc(scaleMap == 2);
    title('Scale = 2');
    subplot(2,3,4);
    imagesc(scaleMap == 3);
    title('Scale = 3');
    subplot(2,3,5);
    imagesc(scaleMap == 4);
    title('Scale = 4');
    subplot(2,3,6);
    imagesc(scaleMap == 0);
    title('Scale = 0');
    pause();
end