function [ contours ] = seg_propagation_r( contours)
%SEG_PROPAGATION
% This function is used to propagate within each segment, ther version is
% only to propagate response r
for i = 1:length(contours.segments)
    % for each segment, propagate
    segment = contours.segments{i}.segment;
    segment = propagate_segment(segment);
    
    contours.segments{i}.segment = segment;
    contours.segments{i}.r = sum(segment(:,4));
    
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

rStar = (solutionMatrix * seg_r)';
segment(:,4) = rStar;

