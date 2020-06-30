function [Group,Gname,Gind,MWTGind,RClist] = getMWTRC(MWTRCname)
    % MWTRCname - first c = MWT folder name, 2nd c = RCname
    % create output legend
    % grouph = {'MWT file name'; 'group code'; 'plate code'; 'strain';...
        %'tracker'};
    A = {};
    for x = 1:size(MWTRCname,1);
        n = MWTRCname{x,2}; % name of the MWT file
        dot = strfind(n,'.'); % find position of dot
        under = strfind(n,'_'); % find underline
        A{x,1} = MWTRCname{x,1}; % MWT folder name
        A{x,2} = n(1:dot-1); % RC name 
        A{x,3} = n(1:under(1)-1); % strain
        A{x,4} = n(dot-2:dot-2); % group code
        A{x,5} = n(dot-2:dot-1);% plate code  
        A{x,6} = n(under(4)+1); % tracker
    end
    RClist = A;
    % prepare Group output
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