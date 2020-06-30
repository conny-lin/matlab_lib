function [RCnameparts] = findgroupcodes(MWTfsn)
% unerline must be correct

gc(1:size(MWTfsn(:,2)),1) = {'[a-z][a-z]'};
[~,~,~,match,~,~,parts] = cellfun(@regexp,MWTfsn(:,2),gc,'UniformOutput',0)
% take match data out of cell
for x = 1:size(match,1);
    A(x,1) = match{x,1};   
end

%%
RCnameparts = {};
for x = 1:size(parts);
    RCnameparts(x,:) = parts{x,1};
end