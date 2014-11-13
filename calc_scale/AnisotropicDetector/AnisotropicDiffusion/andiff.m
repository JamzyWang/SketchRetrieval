function [result]  = andiff( u, lambda, sigma, m, stepsize, nosteps, varargin )

        % [result] = andiff( img, linspace(1.2,16,t), 2.7, 3, 1000, 30);
        
% Anisotropic diffusion for color images
% If the image is gray, the image will be turned into color image first
% Anisotropic Diffusion of image u
% Input:
%   u: image, 
%    -  The constant Cm is calculated to make the flux (g*d(g)) ascending for g < lambda 
%       and descending for g >= lambda.
%    -  Lambda is the contrast parameter (if the gradient is inferior to lambda the 
%       flux is increasing with the gradient and if the gradient is larger then lambda
%       the flux decreases as the gradient grows.
%       For time-variable lambda use lambda as a row vector and length(lambda)=number of steps.
%    -  Sigma is the space regularization parameter (the stardard deviation of the 
%       gaussian which will be convolved with the image before the gradient is calculated.
%       For time-variable sigma use sigma as a row vector and length(sigma)=number of steps.
%    -  'm' defines the speed the difusivity (and the flux) changes for a variation in the
%       gradient. Big values of 'm' make the flux the change quickly. 'm' must be bigger than 1.
%       A good choice for m is 8 < m < 16.
%    -  The stepsize parameter can be a scalar (for constant stepsize) or a row vector for
%       variable stepsize. If stepsize is a row vector, length(stepsize) = number of steps.
%       For stability use stepsize < 0.25. If using 'aos' option stepsize can be any positive number.
%    -  The steps parameter indicates the number of iterations to be performed.
%    -  The verbose parameter is a positive integer indicating the figure number 
%       where the output will be plotted.
%    -  The drawstep parameter indicates the number of steps between updating the 
%       displayed image.
varargout = {};


% 判断输入图像是否是RGB类型的
if ndims(u) ~= 3
  fprintf('Wrong image type!\n');
  u(:,:,2) = u(:,:,1);  
  u(:,:,3) = u(:,:,1);  
end

Nch = size(u,3);

%把输入图像转换为double类型的
if strcmp(class(u),'double')
    y0 = u;
else
    y0 = double(u);
end

y = y0;
contours = {};

m = size(y,1);
n = size(y,2);

g = zeros( size(y(:,:,1)) );
pnorm = 2;

%Parse Input arguments
[TGFlag, methodName] = parse_inputs(varargin);

% Verifying inputs
[lambda, sigma, stepsize] = verify_inputs(lambda, sigma, stepsize, nosteps);
% Calculate Cm constant
Cm = Cmcalc(m);

grayImgCube = zeros(m,n,nosteps);
diffusionMat = zeros(m,n,nosteps);
energyFlowMat = zeros(m,n,nosteps);
energyDiff = zeros(m,n,nosteps);

%%Begin Iteration
for i=1:nosteps
    % calculate gradient
    [grad, dx, dy] = gradCal(y,sigma(i), pnorm);
%     figure(5);
%     imagesc(grad);
%     pause(0.5);
    
    dxMat(:,:,i) = dx;
    dyMat(:,:,i) = dy;

    imageMat(:,:,:,i) = y;
    
    %% Adaptive threshold selection
    if i == 1
        dx0 = dx;
        dy0 = dy;
        
        maxgrad = max(grad(:));
        PercentOfPixelsFiltered = .05;    % Used for selecting thresholds
        PercentOfPixelsMiddle = 0.10;
        PercentOfPixelsNotProcessed = .99;
        
        if maxgrad > 0
            normalizedGrad = grad / maxgrad;
        end
        
        activeGrad = normalizedGrad(find(normalizedGrad > 0.02));
        counts=imhist(activeGrad, 1000);
%         counts=imhist(normalizedGrad, 1000);
        minLambda = find(cumsum(counts) > PercentOfPixelsFiltered*length(activeGrad),...
            1,'first') / 1000;
        maxLambda = find(cumsum(counts) > PercentOfPixelsNotProcessed*length(activeGrad),...
            1,'first') / 1000;
        midLambda = find(cumsum(counts) > PercentOfPixelsMiddle*length(activeGrad),...
            1,'first') / 1000;
        % the coefficient is used to make all the edges are diffused
        maxLambda = maxLambda * maxgrad * 1.2;
        minLambda = minLambda * maxgrad;
        midLambda = midLambda * maxgrad;
        
        fprintf(2,'Lambda = [%f,%f]', minLambda, maxLambda);
        %% The logspace will future accelerate
        lambda = zeros(1, nosteps);
        lambda(1:6) = linspace(minLambda, midLambda,6);
        lambda(7:nosteps - 3) = linspace(midLambda, maxLambda, nosteps - 9);
%         lambda(1:nosteps - 3) = linspace(minLambda, maxLambda, nosteps - 3);
%         lambda(1:nosteps - 3) = logspace(log10(minLambda),log10(maxLambda), nosteps-3);
        lambda(nosteps - 2:nosteps) = lambda(nosteps - 3);
        %lambda = linspace(minLambda, maxLambda,nosteps);
    end
    
    fwrite(2,'.');
    for j = 1 : Nch
        % Calculate diffusion function
        g = 1 - exp(-Cm./( (grad+eps)./lambda(i)).^m);
        diffusionMat(:,:,i) = g;
        
        % Updating
        yy(:,:,j) = aosiso(y(:,:,j),g,stepsize(i));
    end
    y = yy;
    
    grayImgCube(:,:,i) = mean(y,3);
%     if i > 1
%         energyDiff(:,:,i) = grayImgCube(:,:,i) - grayImgCube(:,:,i-1);
%         [energyDiffX,energyDiffY] = gradient(energyDiff(:,:,i));
%         energyDiff(:,:,i) = energyDiffX.^2 + energyDiffY.^2;
%         figure(1); colormap(gray);
%         imagesc(energyDiff(:,:,i));
%         pause;
%     end
    
%     %for debug: save image to file
%     filename = sprintf('%d.jpg',i);
%     imwrite(y/256, filename);
%     
%     if i >= 2
%         gradfileName = sprintf('graddiff_%d.jpg',i);
%         imwrite((grad - pre_grad) > 0,gradfileName);
%     end
%     pre_grad = grad;
end
fprintf(2,']\n');
%%Scale Selection
[R, scaleMat, contours] = scaleSelection(m, n, nosteps, dxMat, dyMat, imageMat, y0, methodName);


% Build return args
% including y, scaleMat, R, dx0, dy0, contours, imageMat
result.y = y;
result.scaleMat = scaleMat;
result.R = R;
result.contours = contours;
result.imageMat = imageMat;
result.diffusionMat = diffusionMat;
% result.energyDiff = energyDiff;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [TGFlag, methodName] = parse_inputs(varargin)
TGFlag = false;
methodName = '';
% The situation for no input argument
if isempty(varargin{1})
    return;
end

for i = 1 : length(varargin)
    flag = 0;
    if strcmp(varargin{i},'tg')
        TGFlag = 1;
        flag = 1;
    end
    if strcmp(varargin{i},'SegPropagation')
        methodName = 'SegPropagation';
        flag = 1;
    end
    if strcmp(varargin{i},'SegSelection')
        methodName = 'SegSelection';
        flag = 1;
    end
    if strcmp(varargin{i},'PixelWise')
        methodName = 'PixelWise';
        flag = 1;
    end
    if flag == 0
        error('Too many parameters !')
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nlambda, nsigma, nstepsize] = verify_inputs(lambda, sigma, stepsize, nosteps)
% Verifying lambda
if sum(size(lambda)>1) == 0 % lambda is constant
   nlambda = linspace(lambda,lambda,nosteps);
else
   if sum(size(lambda)>1) > 1
      error('lambda must be a row vector')
      return
   end
   if length(lambda)~=nosteps
      error('length(lambda) must be equal to number of steps')
      return
   end
   nlambda = lambda;
end

% Verifying simga
if sum(size(sigma)>1) == 0 % sigma is constant
   nsigma = linspace(sigma,sigma,nosteps);
else
   if sum(size(sigma)>1) > 1
      error('sigma must be a row vector')
      return
   end
   if length(sigma)~=nosteps
      error('length(sigma) must be equal to number of steps')
      return
   end
   nsigma = sigma;
end

% Verifying stepsize
if sum(size(stepsize)>1) == 0 % constant stepsize
   nstepsize = linspace(stepsize,stepsize,nosteps);
else
   if sum(size(stepsize)>1) > 1
      error('stepsize must be a row vector')
      return
   end
   if length(stepsize)~=nosteps
      error('length(stepsize) must be equal to number of steps')
      return
   end
   nstepsize = stepsize;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Cm = Cmcalc(m)
if m <= 1
   error('Use m > 1')
   return
else
   Cm = fzero(strcat('1-exp(-x)-x*exp(-x)*',num2str(m)),[1e-10 1e100]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = samedif(lambda,m,i)
y = 1;
for j = 1 : length(m)-1
   if m{j} ~= m{j+1} | lambda{j}(i) ~= lambda{j+1}(i)
      y = 0;
      return
   end
end
