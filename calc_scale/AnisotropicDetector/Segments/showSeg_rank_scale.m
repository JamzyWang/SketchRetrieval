function showSeg_rank_scale( contours, figure_index )
%SHOWSEG_RANK_SCALE 
% This function is used to show contours at different scales, respectively

% rank all the segments
contours = segRank(contours, 'scale');
figure(figure_index);
blankImg = ones(size(contours.RMatrix));
imshow(blankImg);
% imshow(contours.RMatrix);
hold on;

for i = 1:length(contours.segments)
    if contours.segments{i}.length < contours.segments{i}.scale * 2
        continue;
    end    
    % save image
    edgeImgName = sprintf('%d.jpg',i);
    for m = 1:contours.segments{i}.length
        y = contours.segments{i}.segment(m,2);
        x = contours.segments{i}.segment(m,1);
        blankImg(x,y) = 0;
    end
    imwrite(blankImg, edgeImgName);
    draw_segment(contours.segments{i}.segment, figure_index);
%     if(contours.segments{i}.scale ~= currentScale)
%         currentScale = contours.segments{i}.scale;
        pause(0.05);
%     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_segment(segment, segment_fig_index)
figure(segment_fig_index)
plot(segment(:,2), segment(:,1),'k');
hold on;

