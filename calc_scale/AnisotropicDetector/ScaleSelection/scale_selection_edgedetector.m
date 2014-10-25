function [ boundaryImg, scale_matrix ] = scale_selection_edgedetector( imgPath, t, sigma, lowscale, highscale, lThreshold, methodName)
% Anisotropic Edge/Boundary Detector
% Input:
%   imgPath is the path of the input image
%   t is the specific scale on which to detect edge and boundary
%   sigma is a value or a array for diffusion filter
%   lowscale and highscale bound the scale selection interval
%   lThreshold - the threshold for the length of contours, 0 means no
%                threshold for contour length
%   methodName - the method when considering the edge structural
%                informaiont, including 'SegSelection', 'SegPropagation',
%                'PixelWise'

img = imread(imgPath);
[dirPath, imgName] = fileparts(imgPath);
Nch = size(img,3);

if ndims(img) == 2
    %Gray image
end

contourDirPath = sprintf('%s\\%s\\contours', dirPath, methodName);

if exist(contourDirPath, 'dir') == 0
    mkdir(contourDirPath);
end

contourFileName = sprintf('%s\\%s.mat', contourDirPath, strrep(imgName, 'jpg', 'mat'));

if exist(contourFileName, 'file')
    % Load file
    load(contourFileName);
    scaleMat = cdata.scaleMat;
    R = cdata.R;
    contours = cdata.contours;
else
    [result] = andiff( img, linspace(1.2,16,t),sigma,3, 1000,t);
        
    %save file
    cdata.scaleMat = result.scaleMat;
    cdata.R = result.R;
    cdata.contours = result.contours;
    
    % save(contourFileName, 'cdata');
end

%% Construct boundary / edge image
I = [];
result = cdata
highscale = min(highscale, size(result.scaleMat, 3));
if length(lowscale) > 1
    if length(highscale) == 1
        highscale = linspace(highscale, highscale, length(lowscale));
    end
end

% First constuct 2-d scale matrix
scale_matrix = zeros(size(result.scaleMat(:,:,1)));
for i = 1:t
    scale_matrix = max(i * (result.scaleMat(:,:,i) > 0), scale_matrix);
end

for k = 1:length(lowscale)
    fprintf(2,'\nScale Used: %d - %d \n', lowscale(k), highscale(k));
    
    if length(result.contours.segments) > 0
        % output according to contours
        boundaryImg = zeros(size(img,1), size(img,2));
        for i = 1:length(result.contours.segments)
            segment = result.contours.segments{i};
            % all kinds of constraints here, including scale, r, length  
            if segment.length < lThreshold && lThreshold > 0
                continue;
            end
            if segment.scale >= lowscale(k) && segment.scale <= highscale(k)
                for j = 1:segment.length
                    boundaryImg(segment.segment(j,1),segment.segment(j,2)) = segment.segment(j,4);
                end
            end
        end
    else
        boundaryImg = max(R .* (result.scaleMat >= lowscale(k)) .* (result.scaleMat <= highscale(k)), [], 3);
    end
    
    boundaryImg = double(scale(boundaryImg, [0,1]));
    
    I(:,:,:,k) = boundaryImg;
end
if size(I,4) == 1
    boundaryImg = I(:,:,:,1);
else
    boundaryImg = I;
end
