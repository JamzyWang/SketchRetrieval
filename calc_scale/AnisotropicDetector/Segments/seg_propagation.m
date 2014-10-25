function [ contours ] = seg_propagation( contours, statistic)
%SEG_PROPAGATION
% This function is used to propagate within each segment
for i = 1:length(contours.segments)
    % for each segment, propagate
    segment = contours.segments{i}.segment;
    segment = propagate_segment(segment);
    
    contours.segments{i}.segment = segment;
    switch statistic
        case 'mean'
            contours.segments{i}.scale = mean(segment(:,3));
        case 'median'
            contours.segments{i}.scale = median(segment(:,3));
        otherwise
            disp('Unknown method.');
    end
    
    % Add a new property of variance
    contours.segments{i}.variance = var(segment(:,3));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function segment = propagate_segment(segment)
% The structure of segment: [x,y,scale,r]
seg_x = segment(:,1);
seg_y = segment(:,2);
seg_scale = segment(:,3);
seg_r = segment(:,4);

pixelNum = length(seg_x);
sigma = 2;
alpha = 0.99;
W = zeros(pixelNum);

for i = 2:pixelNum
    for j = 1:i-1
        dist = (seg_x(i) - seg_x(j))^2 + (seg_y(i) - seg_y(j))^2;
        weight = exp(-dist / (2*sigma^2));
        W(i,j) = weight;
        W(j,i) = weight;
    end
end

sumW = sum(W,2);
D = zeros(pixelNum,pixelNum);
for p = 1:pixelNum
    D(p,p) = 1 / (sqrt(sumW(p)) + eps);
end
S = D * W * D;
solutionMatrix = (1-alpha)*(inv(eye(pixelNum) - alpha * S));

scaleStar = (solutionMatrix * seg_scale)';
rStar = (solutionMatrix * seg_r)';

segment(:,3) = scale(scaleStar, [median(seg_scale)-1, median(seg_scale)+1]);
segment(:,4) = rStar;

