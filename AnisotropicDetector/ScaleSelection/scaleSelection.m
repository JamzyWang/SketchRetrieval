function [ R, scaleMat, contours ] = scaleSelection(m, n, nosteps, dx, dy, imageMat, y0, methodName)
% Scale Section for Anisotropic Scale Space
% Input arguments:
%   - m , n     : size of image
%   - nosteps   : number of scales
%   - dx, dy    : spatial gradient
%   - imageMat  : images on different scale
% Output:
%   - R         : Harris response
%   - scaleMat  : the selected scale matrix (m * n * nosteps)
%   - methodName = 'SegPropagation' / 'SegSelection' / 'PixelWise';

gradMat = (dx.^2 + dy.^2).^(1/2);
%% Compute gradient on t
tfilter = fspecial('gaussian', [1,5], 2) .* (1/6*[-2,-1,0,1,2]);
for tx = 1:m
    for ty = 1:n
        for tt = 1:nosteps
%             imgVector(tt) = imageMat(tx,ty,tt);
            %% Modified version
            imgVector(tt) = gradMat(tx,ty,tt);
        end
        dtvector = conv(imgVector, tfilter, 'same');
        for tt = 1:nosteps
            dt(tx,ty,tt) = dtvector(tt);
        end
    end
end

%% Parameters of Harris
% Harris detection
% a group of good parameter is k = 0.032, sigma_spatial = 2
% another is k = 0.035, sigma_spatial = 3,
% current use is k = 0.037, that is 1/27, and sigma_spatial = 4
k = 0.060;
sigma_spatial = 1;
sigma_scale = 1;

%% Normalization of dx, dy, dt
dxmax = max(abs(dx(:)));
dymax = max(abs(dy(:)));
dtmax = max(abs(dt(:)));

dxMat = dx / dxmax;
dyMat = dy / dymax;
dt = dt / dtmax;

[R_harris, gradMat ]= HarrisCal_3D( dxMat, dyMat, dt,sigma_spatial, sigma_scale, k );

posR_harris = (R_harris > 0) .* R_harris;
% dt = sign(dt) .* (1 - abs(dt));
[R, scaleMat] = HarrisSelection_3D(posR_harris, gradMat, m, n, nosteps, dxMat, dyMat, dt, sigma_spatial, sigma_scale, k);

% Limit the scale to be the one with max R response
maxRMat = max((scaleMat(:,:,3:nosteps - 2) >0 ) .* R(:,:,3:nosteps - 2), [], 3);
maxScaleMat = max(scaleMat(:,:,3:nosteps - 2), [], 3);
scaleMat = zeros(size(scaleMat));
R = zeros(size(R));
for i = 1:m
    for j = 1:n
        if maxScaleMat(i,j) > 1
            t = maxScaleMat(i,j);
            scaleMat(i,j, t) = t;
            R(i,j, t) = maxRMat(i,j);
        end
    end
end

%% Segments selection
% Construct segments first
scaleMatrix = max(scaleMat(:,:,3:nosteps - 3), [], 3);
RMatrix = max(R,[],3);

contours = segExtract2(scaleMatrix, RMatrix, 10, 0.01, 'mean', false);
contours = segExtract2(scaleMatrix, RMatrix, 5, 0.01, 'mean', false);

%% SegSelection / SegPropagation
if strcmp(methodName, 'SegPropagation')
    contours = seg_propagation(contours, 'mean');
end
if strcmp(methodName, 'SegSelection') || strcmp(methodName, 'PixelWise')
    contours = segSelection(contours, R_harris);
    contours = seg_propagation_r(contours);
end

ranktype = 'scale';
contours = segRank(contours, ranktype);

contours.allR = max(R_harris(:,:,3:27),[],3);

end

