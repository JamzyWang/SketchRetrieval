function saveBoundaryImg( boundaryImg, savePath )
% save boundaryImg (double, [0,1]) into savePath as bmp image

% outputImg = boundaryImg .* (boundaryImg > 0.15);
outputImg = boundaryImg .* (boundaryImg > 0.0);

outputImg = scale(outputImg, [0, 255]);
ioutputImg = uint8(floor(outputImg));

imwrite(ioutputImg, savePath);

end

