function [RCpart] = parseRCname2(MWTfsn)
% use imported .dat or .trv file names to parse out runcondition names
% the first column is a list of MWT folder names, the second column is a
% list of imported file names
RCpart = {};
for x = 1:size(MWTfsn,1);
    RCpart{x,1} = MWTfsn{x,1}; % MWT folder name
    MWTrcname = MWTfsn{x,2}; % name of the MWT file
    %dot = strfind(n,'.'); % find position of dot
    under = strfind(n,'_'); % find underline
    
    RCpart{x,2} = MWTrcname(1:dot-1); % RC name 
    RCpart{x,3} = MWTrcname(1:under(1)-1); % strain
    RCpart{x,4} = MWTrcname(dot-2:dot-2); % group code
    RCpart{x,5} = MWTrcname(dot-2:dot-1);% plate code  
    RCpart{x,6} = MWTrcname(under(4)+1); % tracker
end

end