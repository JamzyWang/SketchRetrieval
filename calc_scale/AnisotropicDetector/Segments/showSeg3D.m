function showSeg3D( contours, figure_index, t)
%SHOWSEG3D - show the scale distribution of contours in a 3D space
colorarray = ['c','g','r','b','k'];
% each segment, each color
fprintf(2, '3D Ploting...\n');
figure(figure_index);

m = contours.m;
n = contours.n;

axis([1 m 1 n 1 t]);

for i = 1:length(contours.segments)
    segment = contours.segments{i}.segment;
    coloroption = colorarray(rem(i,5) + 1);
    % plot segment
    for j = 1:contours.segments{i}.length
        k = segment(j,3);
        figure(figure_index);
        plot3(segment(j,1),segment(j,2), k, coloroption, 'MarkerSize',5, 'LineWidth', 5);
        hold on;
    end
end


end

