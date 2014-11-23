function [ R, scaleMat ] = HarrisSelection_3D(Harris_Resp,gradMat, m, n, nosteps, dx, dy, dt, sigma_spatial, sigma_scale, k)
%3DHARRIS_SELECTION 
%   To select best scales for edges, based on 3D Harris
scaleMat = zeros(m,n,nosteps);

if isempty(Harris_Resp)
    %3D-Harris Calculation
    [ R, gradMat ] = HarrisCal_3D( dx, dy, dt,sigma_spatial, sigma_scale, k );
else
    R = Harris_Resp;
end

% Find Local Extremum
for i  = 3:nosteps - 2
%     zerocrossing = (gradMat(:,:,i) > gradMat(:,:,i-1)) .* (gradMat(:,:,i) > gradMat(:,:,i+1));
%     scaleMat(:,:,i) = (gradMat(:,:,i) > 0.1) .* zerocrossing;
%     R = gradMat;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    zerocrossing = (R(:,:,i) > R(:,:,i-1)) .* (R(:,:,i) > R(:,:,i+1));
    % The RMask is used to avoid the noise caused by the diffusion
    RMask = (R(:,:,i - 1) > 0.001) .* (R(:,:,i+1) > 0.001) .* (R(:,:,3) > 0.002);
    if i > 2
        RMask = RMask .* (R(:,:,i-2) > 0.001);
    end
    if i < nosteps - 2
        RMask = RMask .* (R(:,:,i+2) > 0.001);
    end
    scaleMat(:,:,i) = (R(:,:,i) > 0.00) .* zerocrossing .* RMask * i;
%     scaleMat(:,:,i) = (R(:,:,i) > 0.00) .* zerocrossing * i;
    
    %Thining of R map
    %% Findig local maximum for R at each scale & Thining
    e = false(m,n);
    normalizedR = R(:,:,i) / (max(max(R(:,:,i)))+eps);
    
    PercentOfPixelsNotEdges = .60;
    ThresholdRatio = .25;
    
    counts=imhist(normalizedR, 1000);
    
    highThresh = find(cumsum(counts) > PercentOfPixelsNotEdges * m * n,1,'first') / 1000;
    lowThresh = ThresholdRatio*highThresh;
    idxStrong = []; 
    
    for dir = 1:4
        idxLocalMax = findLocalMaxima(dir, dx(:,:,i), dy(:,:,i), normalizedR);
        idxWeak = idxLocalMax(normalizedR(idxLocalMax) > lowThresh);
        e(idxLocalMax) = 1;
        idxStrong = [idxStrong; idxWeak(normalizedR(idxWeak) > highThresh)];
    end
    if ~isempty(idxStrong) % result is all zeros if idxStrong is empty
        rstrong = rem(idxStrong-1, m)+1;
        cstrong = floor((idxStrong-1)/m)+1;
        e = bwselect(e, cstrong, rstrong, 8);
        e = bwmorph(e, 'thin', 1);  % Thin double (or triple) pixel wide contours
    end
    scaleMat(:,:,i) = scaleMat(:,:,i) .* e;
end
R = log(R ./ (gradMat + eps).^(1/2) + 1);
% R = R ./ (gradMat + eps).^(1/2);