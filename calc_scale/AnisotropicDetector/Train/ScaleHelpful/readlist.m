function iids = readlist( pres )
%READLIST 
% This function read image id list
% pres = good / bad

if strcmp(pres, 'good')
    % read goodlist.txt
    iids = load('goodlist.txt');
elseif strcmp(pres, 'bad')
    % read badlist.txt
    iids = load('badlist.txt');
else
    disp('Wrong input pres!');
end
