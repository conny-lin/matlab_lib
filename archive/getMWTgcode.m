function [Group,Gname,Gind,MWTGind,RClist] = getMWTgcode(MWTfsn)
% MWTfsn 2nd colum must be run name only, no file extention
trackerndate(1:size(MWTfsn,1),1) = {'[a-z][a-z]'};
[~,~,~,match,~,~,~] = cellfun(@regexp,MWTfsn(:,2),trackerndate,...
    'UniformOutput',0);
%% prepare Group output
Group = cat(2,A(:,1),A(:,4),A(:,3));
Gname = unique(Group(:,2));  
Gind = cat(2,num2cell((1:size(Group,1))'),Group(:,2)); % assign index to group to columns

T = tabulate(Group(:,2)); % find incidences of each group @ T(:,2)
A = sortrows(Gind,2); % sort group index
i = 1;
for x = 1:size(T,1); % for each group
    j = T{x,2};
    k = i+j-1;
    T{x,3} = cell2mat(A(i:k,1)'); % compute the c index for each group
    i = i+j;
end
MWTGind = T;
end