function e = thining( gradx, grady, lowThresh)
%This function is the thining process in edge detection
%It contains following parts:
%   1) Nonmax supression
%   2) Thining
%There are two parameters, lowThresh, & highThresh, and the highThresh is
%ste to the 2*lowThresh
%Output: binary edge image e
highThresh = 2 * lowThresh;

[m,n] = size(gradx);

e = false(m,n);
idxStrong = [];
mag = sqrt(gradx.^2 + grady.^2);
if lowThresh > 0
    lowThresh = lowThresh * max(max(mag));
    highThresh = highThresh * max(max(mag));
    for dir = 1:4
        idxLocalMax = findLocalMaxima(dir, gradx,grady, mag);
        idxWeak = idxLocalMax(mag(idxLocalMax) > lowThresh);
        e(idxWeak) = 1;
        idxStrong = [idxStrong; idxWeak(mag(idxWeak) > highThresh)];
    end
    
    if ~isempty(idxStrong)
        rstrong = rem(idxStrong -1, m)+1;
        cstrong = floor((idxStrong - 1)/m)+1;
        e = bwselect(e, cstrong, rstrong, 8);
        %e = bwmorph(e,'thin',1);
    end
    
elseif lowThresh == 0
    
    for dir = 1:4
        idxLocalMax = findLocalMaxima(dir, gradx, grady, mag);
        e(idxLocalMax) = 1;
    end
    
    e = bwmorph(e,'close',inf);
    e = bwmorph(e,'thin',inf);
end

end

