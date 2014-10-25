% Show the image and Harris in a frame
sourceDir = 'opera\';

t = 30

figure(1);

for i = 1:t
    imgPath = sprintf('%s%d.jpg',sourceDir, i);
    harrisPath = sprintf('%sHarris_%d.jpg',sourceDir, i);
    
    img = imread(imgPath);
    harrisImg = imread(harrisPath);
    
    for j = 1:3
        frame(:,:,j) = cat(2, img(:,:,j), harrisImg);
    end
    
    imshow(frame);
    pause(0.5);
end