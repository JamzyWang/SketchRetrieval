function [P] = matrix_expand(matrix)
Q =[];
%   扩展列
for i=1:size(matrix,2)
    Q = [Q matrix(:,i) matrix(:,i)];
end
P = [];
%   扩展行  
for i=1:size(matrix,1)
    P = vertcat(P,Q(i,:));
    P = vertcat(P,Q(i,:));
end

end