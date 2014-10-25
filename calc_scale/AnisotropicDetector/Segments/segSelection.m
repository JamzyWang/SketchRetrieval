function [ contours ] = segSelection( contours, R )
%SEGSELECTION 
%This is the scale selection using 3D harris and segments detected by
%segExtract2.m
%Input:
%   contours - contours detected by segExtract2
%   R - 3D harris response
%Output:
%   contours - contours with detected scales

%for each segment
[m,n,t] = size(R);
for i = 1:length(contours.segments)
    % Calculate the response for each segment
    seg_x = contours.segments{i}.segment(:,1);
    seg_y = contours.segments{i}.segment(:,2);
    r_scale = zeros(1, t);
    
    for k = 1:t
        r_array = zeros(1, contours.segments{i}.length);
        for j = 1:contours.segments{i}.length
            r_array(j) = R(seg_x(j), seg_y(j), k);
%             r_scale(k) = r_scale(k) + R(seg_x(j), seg_y(j), k);
        end
        % Calculate the statistics of r_array
%         r_scale(k) = sum(r_array);
        % use median instead
        r_scale(k) = median(r_array);

    end
    
%     % Select local maximum or select global maximum?
%     maxScale = 0;
%     maxR = 0;
%     for k = 3:t-3
%         if (r_scale(k) >= r_scale(k-1)) && (r_scale(k-1) >= r_scale(k-2)) && (r_scale(k) >= r_scale(k+1)) && (r_scale(k+1) >= r_scale(k+2))
% %         if (r_scale(k) > r_scale(k-1)) && (r_scale(k) > r_scale(k+1))
%             if r_scale(k) > maxR
%                 maxScale = k;
%                 maxR = r_scale(k);
%             end
%         end
%     end
    seg_scale = contours.segments{i}.segment(:,3);
    scale_median = median(seg_scale);
    
    max_scale = min(ceil(scale_median + 2),t-2);
    min_scale = max(floor(scale_median - 2),3);
    maxR = max(r_scale(min_scale:max_scale));
    
    for j = min_scale:max_scale
        if r_scale(j) == maxR
            maxScale = j;
        end
    end
    
    contours.segments{i}.scale = maxScale;
    contours.segments{i}.r = maxR;
end


end

