function [ newSMat ] = expand_contours( contours, m, n, t )
%EXPAND_CONTOURS Summary of this function goes here
%   Detailed explanation goes here
newSMat = zeros(m,n,t);

for i = 1:length(contours.segments)
    segment = contours.segments{i};
    for j = 1:segment.length
        x = segment.segment(j,1);
        y = segment.segment(j,2);
%         t = segment.scale;
        t = segment.segment(j,3);
        newSMat(x,y,ceil(t)) = t;
    end
end

end

