function [ contours ] = segExtract2( scaleMatrix, RMatrix, lengthThreshold, rthreshold, statistic, visible)
% segExtracts aims at extract segments from the scale space in a 2D
% representation.
% Input:
%   scaleMatrix - the 2 dimensional matrix which is the projection of the
%                 scale space
%   RMatrix - the response matrix projected from the 3D R matrix
%   rthreshold - the threshold of R to determine whether a point should be
%                considered as candidate
%   lengthThreshold - the threshold controls the segments shorter than that
%                     will be omitted
%   statistic - the statistic used for representing the scale of segments
% Output:
%   segments - the extracted segments

% The figure number to show segments
segment_fig_index = 5;
% The figure number to show overall edges
overall_fig_index = 4;

[m,n] = size(RMatrix);
contours.segments = {};
if rthreshold < 0
    rthreshold  = 0.01
end
binaryMatrix = RMatrix > rthreshold;
binaryMatrix = binaryMatrix .* (scaleMatrix >= 3);
RMatrix = RMatrix .* binaryMatrix;


%% Compute the degree of each pixel

extendedBinaryMatrix = zeros(m+2, n+2);
extendedBinaryMatrix(2:m+1, 2:n+1) = binaryMatrix;

% 8 neighborhoods
% down
neighbor1 = extendedBinaryMatrix(2:m+1, 3:n+2);
% up
neighbor2 = extendedBinaryMatrix(2:m+1, 1:n);
% left
neighbor3 = extendedBinaryMatrix(1:m, 2:n+1);
% right
neighbor4 = extendedBinaryMatrix(3:m+2, 2:n+1);
% left-up
neighbor5 = extendedBinaryMatrix(1:m, 1:n);
% left_down
neighbor6 = extendedBinaryMatrix(1:m, 3:n+2);
% right-up
neighbor7 = extendedBinaryMatrix(3:m+2, 1:n);
% right-down
neighbor8 = extendedBinaryMatrix(3:m+2, 3:n+2);

% calculating degree using 8 neighbors
degMatrix = binaryMatrix .* (neighbor1 + neighbor2 + neighbor3 + neighbor4 + neighbor5 + neighbor6 + neighbor7 + neighbor8);
RMatrix = RMatrix .* (degMatrix > 0);

if visible
    figure(overall_fig_index);
    imagesc(RMatrix);
    
    figure(segment_fig_index);
    imshow(RMatrix);
    axis ij;
    hold on;
end

%% Extract lines and curves
%Firstly, find 1-degree points as startpoints
one_degree_list = find(degMatrix == 1);

[contours, degMatrix] = find_contours(contours, one_degree_list, degMatrix, RMatrix, scaleMatrix, lengthThreshold, m, n, segment_fig_index, statistic, visible);

% Solve the condition of circles
% startPointList = find(degMatrix >= 1);
startPointList = find(degMatrix >= 2);

while length(startPointList) > 0
    if visible
        pause(0.5);
    end
    [contours, degMatrix] = find_contours(contours, startPointList, degMatrix, RMatrix, scaleMatrix, lengthThreshold, m, n, segment_fig_index, statistic, visible);
    
%     startPointList = find(degMatrix >= 1);
    startPointList = find(degMatrix >= 2);
end

%Add additional information to contours
contours.RMatrix = RMatrix;
contours.m = m;
contours.n = n;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [contours, degMatrix] = find_contours(contours, startPointList, degMatrix, RMatrix, scaleMatrix, lengthThreshold, m, n, segment_fig_index, statistic, visible)
% Threshold length when spliting segment
windowSize = 10;
angelThresh = pi / 16;
orientationThresh = angelThresh / windowSize;
for i = 1:length(startPointList)
    index = startPointList(i);
    [start_x, start_y] = ind2sub(size(degMatrix), index);
    if degMatrix(start_x, start_y) == 0
        continue;
    end
    segment = [];
    % each point in the segment is organized as (x,y, scale, r)
    segment = [segment; start_x, start_y, scaleMatrix(start_x, start_y), RMatrix(start_x, start_y)];
    degMatrix(index) = degMatrix(index) - 1;
    
    % Find the first successor
    [x,y] = find_first_successor(start_x, start_y, degMatrix, RMatrix, m, n);
    if [x,y] == [0,0]
        continue;
    end
    segment = [segment; x,y, scaleMatrix(x, y), RMatrix(x, y)];
    degMatrix(x,y) = degMatrix(x,y) - 1;
    start_x = x;
    start_y = y;
    
    % Find other successors
    [x,y] = find_successor(start_x, start_y, segment, degMatrix, RMatrix, scaleMatrix, m, n);
    while [x,y]~=[0,0]
        segment = [segment; x,y, scaleMatrix(x, y), RMatrix(x, y)];
        start_x = x;
        start_y = y;
        
        degMatrix(x,y) = degMatrix(x,y) - 1;
        degMatrix(start_x, start_y) = degMatrix(start_x, start_y) - 1;
        
        [x,y] = find_successor(start_x, start_y, segment, degMatrix, RMatrix,scaleMatrix, m, n);
    end
    
    if size(segment, 1) >= lengthThreshold  %only consider the segment with lengh over lengthThreshold
        %% Post-Processing: splite the long contours
        orientation = zeros(size(segment,1),1);
        
        for j = 2:length(orientation)-1
            orientation(j) = atan((segment(j+1,1) - segment(j-1,1)) / (segment(j+1,2) - segment(j-1,2)));
        end
        
        orientation(1) = atan((segment(2,1) - segment(1,1))/(segment(2,2) - segment(1,2)));
        orientation(length(orientation)) = atan((segment(length(orientation),1) - segment(length(orientation)-1,1))/(segment(length(orientation),2) - segment(length(orientation)-1,2)));
        
        averFilter = fspecial('average', [windowSize, 1]);
        orientation = conv(orientation, averFilter, 'same');
        
        orientationChange = conv(orientation, [1,0,-1], 'same');
        
        %% Find splitorPosition: local extream and exceeds the threshold
        splitor = [1];
        for j = 3:length(orientation) - 2
            if (orientationChange(j) - orientationChange(j-1)) * (orientationChange(j) - orientationChange(j+1)) > 0 
                if abs(orientationChange(j)) > orientationThresh
                    if j - splitor(length(splitor)) + 1 >= lengthThreshold
                        splitor = [splitor, j];
                    end
                end
            end
        end
        
        splitor = [splitor, length(orientation)];
        
        for j = 2:length(splitor)
            splitedSeg = segment(splitor(j-1):splitor(j),:);
            
            seg_structure = {};
            % Add segment to countours
            segment_length = size(splitedSeg, 1);
            seg_structure.segment = splitedSeg;
            seg_structure.length = segment_length;
            
            switch lower(statistic)
                case 'mean'
                    seg_scale = mean(splitedSeg(:,3));
                case 'median'
                    seg_scale = median(splitedSeg(:,3));
                otherwise
                    disp('Unknown method.');
            end
            
            seg_structure.scale = seg_scale;
            seg_structure.r = sum(segment(:,4));
            
            contours.segments = [contours.segments; seg_structure];
            
            if visible
                draw_segment(splitedSeg, segment_fig_index);
                pause();
%                 pause(0.1);
            end
        end
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,y] = find_first_successor(start_x, start_y, degMatrix, RMatrix, m, n)
% The principle is to find the neighbor with largest reponse R
x = 0;
y = 0;
max_R = 0;

for i = max(1, start_x - 1):min(m, start_x+1)
    for j = max(1, start_y - 1):min(n, start_y+1)
        if degMatrix(i,j) > 1
            if i == start_x && j == start_y
                continue;
            end
            if RMatrix(i,j) > max_R;
                max_R = RMatrix(i,j);
                x = i;
                y = j;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,y] = find_successor(start_x, start_y, segment, degMatrix, RMatrix, scaleMatrix, m, n)
x = 0;
y = 0;
max_aR = -1;
mu = 0.5*max(RMatrix(:));

vec_p = [segment(end, 1) - segment(end-1,1), segment(end, 2) - segment(end-1,2)];
current_point = [segment(end, 1), segment(end, 2)];

for i = max(1, start_x - 1):min(m, start_x+1)
    for j = max(1, start_y - 1):min(n, start_y+1)
        if degMatrix(i,j) > 1
            if i == start_x && j == start_y
                continue;
            end
            
%             if abs(scaleMatrix(start_x, start_y) - scaleMatrix(i,j)) > 8
%                 continue;
%             end

            vec_s = [i - current_point(1), j - current_point(2)];
            aR = RMatrix(i,j) +  mu * vec_s * vec_p' / norm(vec_s);
            if aR > max_aR;
                max_aR = aR;
                x = i;
                y = j;
            end
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_segment(segment, segment_fig_index)
figure(segment_fig_index)
plot(segment(:,2), segment(:,1),'r');
hold on;
