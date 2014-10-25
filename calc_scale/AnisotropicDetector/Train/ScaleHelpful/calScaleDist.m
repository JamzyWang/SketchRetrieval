function [ shist, varlist ] = calScaleDist( iids )
% Calculate the scale distribution histogram for input iid list
mins = 3; maxs = 28;
shist = zeros(maxs - mins+1, 1);
varlist = zeros(length(iids), 1);
for i = 1:length(iids)
    iid = iids(i);
    [imgShist, imgsvar] = loadImgScale(iid);
    
    shist = shist + imgShist;
    varlist(i) = imgsvar;
end

