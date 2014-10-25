function [grad, gradx, grady] = gradCal(y, t_sigma, pnorm)
% Calculate the gradient for color image y, with gaussian sigma = t_sigma,
% and the gradient is combined using pnorm

if ndims(y) == 2
    %gray image
    [gradx, grady] = gsderiv(y, t_sigma, 1);
    grad = sqrt(gradx.^2 + grady.^2);
elseif ndims(y) == 3
    %color image
    Nch = size(y,3);
    grad = zeros( size(y(:,:,1)) );
    gradx = zeros( size(y(:,:,1)) );
    grady = zeros( size(y(:,:,1)) );
    % Calculate gradient of smoothed image
    for j = 1 : Nch
        [tgradx, tgrady] = gsderiv(y(:,:,j), t_sigma, 1);
        if strcmp(pnorm,'inf')
            grad = max(grad, sqrt(tgradx.^2 + tgrady.^2) );
            gradx = max(gradx, tgradx);
            grady = max(grady, tgarty);
        elseif pnorm == 2
            grad = grad + tgradx.^2 + tgrady.^2;
            gradx = gradx + tgradx.^2;
            grady = grady + tgrady.^2;
        elseif pnorm == 1
            grad = grad + sqrt(tgradx.^2 + tgrady.^2);
        else
            grad = grad + (sqrt(tgradx.^2 + tgrady.^2)).^pnorm;
        end
    end
    if ~strcmp(pnorm,'inf') && pnorm~=1
        grad = (grad / Nch).^(1/pnorm); % Not necessary to do anything if pnorm == 'inf' or 1.
        gradx = (gradx / Nch).^(1/pnorm);
        grady = (grady / Nch).^(1/pnorm);
    end
    
    if pnorm == 2
        % cope with the sign problem of gradient
        gy = mean(double(y),3);
        [tgradx, tgrady] = gsderiv(gy, t_sigma, 1);
        gradx = gradx .* sign(tgradx);
        grady = grady .* sign(tgrady);
    end
end