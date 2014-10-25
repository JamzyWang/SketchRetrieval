function [ contours ] = segRank( contours, type )
%SEGRANK
% Rank the segments in contours, according to type
% type - could be 'scale', 'r' and 'length'

segmentNum = length(contours.segments);
for i = 1:segmentNum - 1
    for j = i:segmentNum
        switch lower(type)
            case 'scale'
                if contours.segments{i}.scale < contours.segments{j}.scale
                    tempSegment = contours.segments{i};
                    contours.segments{i} = contours.segments{j};
                    contours.segments{j} = tempSegment;
                end
            case 'r'
                if contours.segments{i}.scale < contours.segments{j}.r
                    tempSegment = contours.segments{i};
                    contours.segments{i} = contours.segments{j};
                    contours.segments{j} = tempSegment;
                end
            case 'length'
                if contours.segments{i}.scale < contours.segments{j}.length
                    tempSegment = contours.segments{i};
                    contours.segments{i} = contours.segments{j};
                    contours.segments{j} = tempSegment;
                end
            otherwise
                disp('Wrong type.');
        end
    end
end

end

