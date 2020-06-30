function [Group,Gname,Gind,MWTgcode,RClist] = getMWTRC2(MWTfsn)
    % MWTRCname - first c = MWT folder name, 2nd c = RCname
    % create output legend
    % grouph = {'MWT file name'; 'group code'; 'plate code'; 'strain';...
        %'tracker'};
    RClist = {};
    for x = 1:size(MWTfsn,1);
        n = MWTfsn{x,2}; % name of the MWT file
        under = strfind(n,'_'); % find underline
        dot = strfind(n,'.'); % find position of dot
        if isempty(dot) ==1;
            RClist{x,2} = n;
            RClist{x,4} = n(end-1:end-1); % group code
            RClist{x,5} = n(end-1:end);% plate code 
        else
            RClist{x,2} = n(1:dot-1); % RC name 
            RClist{x,4} = n(dot-2:dot-2); % group code
            RClist{x,5} = n(dot-2:dot-1);% plate code 
        end
        RClist{x,1} = MWTfsn{x,1}; % MWT folder name      
        RClist{x,3} = n(1:under(1)-1); % strain
        RClist{x,6} = n(under(4)+1); % tracker
    end
    % prepare Group output
    Group = cat(2,RClist(:,1),RClist(:,4),RClist(:,3)); % MWTfoldername, groupcode, plate code
    Gname = unique(Group(:,2));  
    Gind = cat(2,num2cell((1:size(Group,1))'),Group(:,2)); % assign index to group to columns
%%
    T = tabulate(Group(:,2)); % find incidences of each group @ T(:,2)
    %%
    RClist = sortrows(Gind,2); % sort group index
    i = 1;
    for x = 1:size(T,1); % for each group
        j = T{x,2};
        k = i+j-1;
        T{x,3} = cell2mat(RClist(i:k,1)'); % compute the c index for each group
        i = i+j;
    end
    MWTgcode = T;
    end