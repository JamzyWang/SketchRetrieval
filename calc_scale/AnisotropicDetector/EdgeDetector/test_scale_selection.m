imgPath = '..\data\opera.jpg';

% imgPath = '..\data\test\299086.jpg';
% imgPath = '..\data\test\182053.jpg';
% imgPath = '..\data\test\302008.jpg';
% imgPath = '..\data\test\295087.jpg';
% imgPath = '..\data\test\260058.jpg';
% imgPath = '..\data\test\101087.jpg';
% imgPath = '..\data\test\189080.jpg';
% imgPath = '..\data\test\145086.jpg';

%% Begin Operation
Tmax = 30;
sigma = 2.7;
% sigma = linspace(5, 0.5, Tmax);

methodName = 'SegSelection';
% methodName = 'SegPropagation';
% methodName = 'PixelWise';

lowScale = 2:3:17;
% lowScale = 2;

[ I ] = scale_selection_edgedetector(imgPath, Tmax, sigma, lowScale, Tmax - 3, 0, methodName);
figure;
montage(1 - I);
% Show black background montage image
% montage(I);

figure;
for i = 1:size(I,4)
    imshow(I(:,:,:,i));
    titleText = sprintf('Overall Boundary: Scale = %d - %d', lowScale(i), Tmax - 3);
    title(titleText);
%     fileName = sprintf('edge_%d.jpg', lowScale(i));
%     imwrite(1-I(:,:,:,i), fileName);
    pause();
end
boundaryImg = I(:,:,:,1);
