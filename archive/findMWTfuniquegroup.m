function [MWTfgcode,gcode] = findMWTfuniquegroup(MWTfdat)
A = {};
for x = 1:size(MWTfdat,1);
    n = MWTfdat{x,2}; % name of the MWT file
    dot = strfind(n,'.'); % find position of dot
    under = strfind(n,'_'); % find underline
    A{x,1} = MWTfdat{x,1}; % MWT folder name
    A{x,2} = n(1:dot-1); % RC name 
    A{x,3} = n(1:under(1)-1); % strain
    A{x,4} = n(dot-2:dot-2); % group code
    A{x,5} = n(dot-2:dot-1);% plate code  
    A{x,6} = n(under(4)+1); % tracker
end
RCpart = A;
MWTfgroup = cat(2,RCpart(:,1),RCpart(:,4),RCpart(:,3)); % extract summary
gcode = unique(RCpart(:,4)); % extract unique group code
T = tabulate(RCpart(:,4)); % find incidences of each group @ T(:,2)
for x = 1:size(T,1); % for each group
    MWTfgcode(x,1:2) = T(x,1:2); % put group code and incidences of each group in record
    MWTfgcode{x,3} = (strmatch(T{x,1},RCpart(:,4)))'; % find MWTf index for current group code
end
end
