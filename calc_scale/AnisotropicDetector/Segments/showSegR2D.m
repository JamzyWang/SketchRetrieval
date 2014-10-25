function showSegR2D( contours, figure_index, )
%SHOWSEGR2D 
% show the propagated segments response on a 2d image
m = contours.m;
n = contours.n;
rimg = zeros(m,n);
for i = 1:length(contours.segments)
    segment = contours.segments{i}.segment;
    % plot segment
    for j = 1:contours.segments{i}.length
        rimg(segment(j,1), segment(j,2)) = segment(j,4);
    end
end
rimg = scale(rimg, [0,1]);
figure(figure_index);
imshow(rimg);
end

