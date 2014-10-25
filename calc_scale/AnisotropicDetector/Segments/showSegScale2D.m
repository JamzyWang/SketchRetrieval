function showSegScale2D( contours, figure_index )
%SHOWSEGR2D 
% show the propagated segments response on a 2d image
m = contours.m;
n = contours.n;
simg = zeros(m,n);
for i = 1:length(contours.segments)
    segment = contours.segments{i}.segment;
    % plot segment
    for j = 1:contours.segments{i}.length
        simg(segment(j,1), segment(j,2)) = segment(j,3);
    end
end
figure(figure_index);
imagesc(simg);
end

