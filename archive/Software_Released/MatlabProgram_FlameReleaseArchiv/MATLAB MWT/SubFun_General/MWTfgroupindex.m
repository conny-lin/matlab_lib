function [MWTfg,gcode] = MWTfgroupindex(RCpart)
% prepare Group output, work with RCpart produced by function...
% [RCpart] = parseRCname1(MWTfdatname)
% MWTfg = 1- group, 2- groupincidences, 3-index to MWTf rows
% MWTfgroup = 1-MWT folder name, 2-group code, 3-strain name
% Gcode = unique group codes
% Gind = row index to MWTf with group code
MWTfgroup = cat(2,RCpart(:,1),RCpart(:,4),RCpart(:,3)); % extract summary
gcode = unique(RCpart(:,2)); % extract unique group code
T = tabulate(MWTfgroup(:,2)); % find incidences of each group @ T(:,2)
for x = 1:size(T,1); % for each group
MWTfg(x,1:2) = T(x,1:2); % put group code and incidences of each group in record
MWTfg{x,3} = (strmatch(T{x,1},RCpart(:,4)))'; % find MWTf index for current group code
end
end