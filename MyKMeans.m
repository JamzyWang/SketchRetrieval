% Kmeans: Matlab Code
%
% My implementation of K means algorithm is highly customized. Initial cluster centroid can be selected in various of ways. Those are:
% Randomly initialized cluster centroid as one of the data row.
% Select first 3 data row was the three cluster center.
% Provide the cluster centroid as a parameter, it is specially helpful when you want to perform the cluster with the same initial data centers so that we don鈥檛 have to worry about K means naming different to the same cluster in different run.
%
function [class,centroid,counter,feature]=MyKMeans(data,k,option, init_centroid )
fprintf('begin processing! \n');
%1- Random
%2- First three
%4- Centroid passes as parameter

%去掉data中的所有元素全为0的行，减少计算量
feature = [];
[n,m]=size(data); % A = [1,2,3;4,5,6],[n,m]= size(A),n=2,m=3; n:向量个数（HOG特征数量）,m:向量维数（每个HOG特征的维数）
for i=1:n
    result = data(i,:);
    if sum(result,2) ~= 0
        feature = [feature;result];
    end
end
data = feature;
fprintf('data processing! \n');

centroid=[];
class=[];
[n,m]=size(data); % A = [1,2,3;4,5,6],[n,m]= size(A),n=2,m=3; n:向量个数（HOG特征数量）,m:向量维数（每个HOG特征的维数）


selected=[];
%get the K initial centroids
fprintf('get the K initial centroids! \n');
if (option==1)
    for i=1:k
        index=uint16((rand()*n));
        while(Exists(selected,index)==1) %保证初始的K个聚类中心不重复
            index=uint16((rand()*n));
        end
        selected=[selected index]; %从N个向量中选择K个，这一步是确定索引号,B = [1,2,3],B = [B 4],B=[1,2,3,4]
        centroid(i,:)=data(index,:);%选择K个向量
        fprintf('index: %d\n',index);
    end
elseif (option==2)
    centroid(1:3,:)=data(1:3,:);
else
    centroid=init_centroid;
end

flag=0;
count=0;
counter=[];


%classify the data

while(flag==0)
    fprintf('calculate MyDistance\n');
    [dist,class]=MyDistance(centroid,data);
    
    if(count~=0)%如果不是第一次迭代
        temp=(class==prevclass);%判断前后两次的迭代结果是否一致，若迭代结果一致则聚类结束
        if( max(max(temp))==1 && min(min(temp))==1)
            flag=1;
            counter;
            break;
        end
    end
    
    prevclass=class;%第一次迭代
    [centroid,counter]=CalculateCentroid(centroid,class,data);%重新计算聚类中心
    count=count+1;
    fprintf('iterator: %d \n',count);
end




%Calculate new Centroid
function [newCentroid,counter]=CalculateCentroid(centroid,class,data)
fprintf('Calculate new Centroiditerator\n');
[n,m]=size(data);
[k,l]=size(centroid);

newCentroid=zeros(k,l);
counter=zeros(k,1);

for j=1:k
    for i=1:n
        if(class(i,1)==j)
            for p=1:m
                newCentroid(j,p)=newCentroid(j,p)+data(i,p);
            end
            counter(j,1)=counter(j,1)+1;
        end
    end
end

for j=1:k
    for p=1:m
        newCentroid(j,p)= newCentroid(j,p)/counter(j,1);
    end
end



%Function to check if the item is already selected as one
% of the initial centroid
function [flag] = Exists(Arr, item)

flag=0;
[n,m]=size(Arr);
for i=1:m
    if(Arr(1,i)==item)
        flag=1;
        break;
    end
end



%Calculate the distance and assign the class
function [dist,classify]=MyDistance(centroid,data)

[n,m]=size(data);
[k,l]=size(centroid);
dist=[];
classify=[];

for i=1:k
    % fprintf('iterator:i: %d \n',i);
    for j=1:n
        % fprintf('iterator:j: %d \n',j);
        % calculate the distance from each centroid to the data
        % 计算每个聚类中心到data中每一个向量之间的距离
        sum=0;
        
        
        %计算data(j,:)与centroid(i,:)之间的距离
        for p=1:m
            % fprintf('iterator:p: %d \n',p);
            sum=sum+(data(j,p)-centroid(i,p))^2; %计算两个向量之间的距离          
        end
        dist(i,j)=sum^0.5;%dist为K*N维矩阵，dist(i,j)为聚类中心i到data中的向量j之间的距离，dist为K*N维矩阵
    end
end

for j=1:n
    [minv,mindex]=min(dist(:,j));
    classify(j,1)=mindex; % classify为N*1维向量，classify(j,1)表示第j个向量所属的类
end