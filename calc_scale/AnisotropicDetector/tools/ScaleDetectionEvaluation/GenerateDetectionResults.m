benchmarkDirPath = '..\..\data\benchmark\';
% methodName = 'SegSelection';
methodName = 'SegPropagation';
% methodName = 'PixelWise';

contourDirPath = sprintf('%s%s\\contours', benchmarkDirPath, methodName);

desDirPath = sprintf('%s%s\\pointList', benchmarkDirPath, methodName);
if exist(desDirPath, 'dir') == 0
    mkdir(desDirPath);
end

filenames = dir([contourDirPath '/*.mat']);

for i = 1:size(filenames,1)
    % for each file, read and then re-organize
    clear cdata;
    
    fprintf(2, 'Processing image %s\n', filenames(i).name);
    
    contourFilePath = fullfile(contourDirPath, filenames(i).name);
    cdata = importdata(contourFilePath);
    
    desFilePath = fullfile(desDirPath, strrep(filenames(i).name,'mat','txt'));
    fid = fopen(desFilePath,'wt');
    
    for j = 1:length(cdata.contours.segments)
        %for each segment
        segment = cdata.contours.segments{j};
        
        for k = 1:segment.length
            %for each point
            if strcmp(methodName, 'PixelWise')
                fprintf(fid, '%d [%d,%d]\n', int32(segment.segment(k,3)),int32(segment.segment(k,1))-1, int32(segment.segment(k,2))-1);
            else
                fprintf(fid, '%d [%d,%d]\n', int32(segment.scale),int32(segment.segment(k,1))-1, int32(segment.segment(k,2))-1);
            end
        end
    end
    fclose(fid);
end