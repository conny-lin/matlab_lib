function [RCnameparts] = checkRCparts(MWTfsn)
under(1:size(MWTfsn(:,2)),1) = {'_'};
[~,~,~,~,~,~,parts] = cellfun(@regexp,MWTfsn(:,2),under,'UniformOutput',0);
RCnameparts = {};
for x = 1:size(parts);
    RCnameparts(x,:) = parts{x,1};
end