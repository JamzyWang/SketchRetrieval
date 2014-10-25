function [shist, svar] = loadImgScale( iid )
% Load scale histogram for image with ID = iid
mins = 3; maxs = 28;
slength = maxs - mins + 1;
% scaler = linspace(mins, maxs, slength);

imScalePath = sprintf('..\\..\\data\\test\\contours\\%d.mat', iid);

load(imScalePath);

segmentNum = length(cdata.contours.segments);
shist = zeros(slength, 1);
for j = 1:segmentNum
    segment = cdata.contours.segments{j};
    shist(segment.scale - mins + 1) = shist(segment.scale - mins + 1) + segment.length;
end

svar = var(shist);

end

