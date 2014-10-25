function showSegScale2D2( contours, figure_index)
%SHOWSEGR2D 
% show the propagated segments response on a 2d image
% This use a single scale instead the scale for each pixel
m = contours.m;
n = contours.n;
simg = zeros(m,n);
for i = 1:length(contours.segments)
    segment = contours.segments{i}.segment;
    if contours.segments{i}.length < 10
        continue;
    end
    % plot segment
    for j = 1:contours.segments{i}.length
        if simg(segment(j,1), segment(j,2)) < contours.segments{i}.scale
            simg(segment(j,1), segment(j,2)) = contours.segments{i}.scale;
        end
    end
end
figure(figure_index);
imagesc(simg);
end

