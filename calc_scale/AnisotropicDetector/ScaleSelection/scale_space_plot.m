function scale_space_plot( scaleMat )

colorarray = ['c','g','r','b','k'];

[m,n,t] = size(scaleMat);
colorInterval = ceil(t / 5);
fprintf(2, '3D Ploting...\n');
figure(4);
for i = 1:m
    for j = 1:n
        for k = 2:t
            if scaleMat(i,j,k) >= 2
                coloroption = colorarray(floor( (k-1) / colorInterval) + 1);
                plot3(i,j, scaleMat(i,j,k), coloroption, 'MarkerSize',5, 'LineWidth', 5);
%                 plot3(i,j, scaleMat(i,j,k), 'r.', 'MarkerSize',3);
                hold on;
            end
        end
    end
end

