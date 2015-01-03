function [ new_image_edge_map ] = interest_points_screening(sketch_edge_map,origin_image_edge_map )
%INTEREST_POINTS_SCREENING 此处显示有关此函数的摘要
%   此处显示详细说明
sketch_number =  length(find(sketch_edge_map>0));
image_number =  length(find(origin_image_edge_map>0));
extra_proportion = ((image_number - sketch_number)/sketch_number);

if(extra_proportion >= 0.2)
    number_to_remove = uint32(sketch_number*(extra_proportion-0.2));
    vector = reshape(origin_image_edge_map,[],256*256);
    [~, I] = sort(vector,'descend');
    start_index = image_number - number_to_remove;
    end_index =  image_number;
    for i = start_index:end_index
        vector(I(i)) = 0;
    end
    new_image_edge_map = reshape(vector,[256 256]);
else
    new_image_edge_map = origin_image_edge_map;
end

end

