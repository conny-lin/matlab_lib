    function [RCpart] = parseRCname1(MWTfdatname)
    % use imported .dat or .trv file names to parse out runcondition names
    % the first column is a list of MWT folder names, the second column is a
    % list of imported file names
    A = {};
    for x = 1:size(MWTfdatname,1);
        n = MWTfdatname{x,2}; % name of the MWT file
        dot = strfind(n,'.'); % find position of dot
        under = strfind(n,'_'); % find underline
        A{x,1} = MWTfdatname{x,1}; % MWT folder name
        A{x,2} = n(1:dot-1); % RC name 
        A{x,3} = n(1:under(1)-1); % strain
        A{x,4} = n(dot-2:dot-2); % group code
        A{x,5} = n(dot-2:dot-1);% plate code  
        A{x,6} = n(under(4)+1); % tracker
    end
    RCpart = A;
    end