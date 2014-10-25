function [ R, gradMat ] = HarrisCal_3D( dx, dy, dt,sigma_spatial, sigma_scale, k )
%HARRISCAL_3D Summary of this function goes here
%   Detailed explanation goes here
Ix2 = dx .* dx;
Iy2 = dy .* dy;
It2 = dt .* dt;
Ixy = dx .* dy;
Ixt = dx .* dt;
Iyt = dy .* dt;

gradMat = Ix2 + Iy2;

fprintf(2,'Generating 3D gaussian filter: ');
gaussian3 = generate_3D_gaussian(sigma_spatial, sigma_scale);

fprintf(2,'The size of 3D gaussian is %d * %d * %d \n', size(gaussian3,1), size(gaussian3,2), size(gaussian3,3));

fprintf(2,'Conving...');

Ix2 = conv3(Ix2, gaussian3);
Iy2 = conv3(Iy2, gaussian3);
It2 = conv3(It2, gaussian3);
Ixy = conv3(Ixy, gaussian3);
Ixt = conv3(Ixt, gaussian3);
Iyt = conv3(Iyt, gaussian3);

%% 3D-Harris Response
fprintf(2,'Begin calculating Harris Responce\n');
traceM = Ix2 + Iy2 + It2;
detM = Ix2 .* Iy2 .* It2 + 2 * Ixy .* Ixt .* Iyt - Ix2 .* (Iyt.^2) - Iy2 .* (Ixt.^2) - It2 .* (Ixy.^2);
R = -(detM - k * traceM.*3);

%% 2D-Harris Response
% traceM = Ix2 + Iy2;
% detM = Ix2 .* Iy2 - Ixy.^2;
% R = detM - k * traceM.^2;

% % Filterring: only use the negative pixels
% R = (R < 0) .* (-R);

% % For debug
% for i = 1:size(R,3)
%     filename = sprintf('Harris_%d.jpg',i);
%     imwrite(R(:,:,i) * 20, filename);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gaussian3 = generate_3D_gaussian(sigma_spatial, sigma_scale)
spatial_width = 4 * ceil(sigma_spatial) + 1;
scale_width = 4 * ceil(sigma_scale) + 1;

center_x = ceil(sigma_spatial) + 1;
center_y = ceil(sigma_spatial) + 1;
center_t = ceil(sigma_scale) + 1;

gaussian3 = zeros(spatial_width, spatial_width, scale_width);

factor = 1 / sqrt((2 * pi)^3 * sigma_spatial^4 * sigma_scale^2);

for t = 1:scale_width
    for x = 1:spatial_width
        for y = 1:spatial_width
            gaussian3(x,y,t) = factor * exp(-((x - center_x)^2 + (y-center_y)^2) / (2*sigma_spatial^2) - (t-center_t)^2/(2*sigma_scale^2));
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = conv3(source, filter)
% 3D conv function
[fc, fr, fh] = size(filter);

fct = (fh+1) /2;
half_fh = (fh-1) /2;

result = zeros(size(source));

for t = 1:size(source, 3)
    lower_t = max(1, t - half_fh);
    higher_t = min(size(source, 3), t + half_fh);
    for i = lower_t:higher_t
        result(:,:,t) = result(:,:,t) + conv2(source(:,:,i), filter(:,:,fct + i - t), 'same');
    end
end
