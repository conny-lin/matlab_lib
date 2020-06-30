function [glist,uniqueglist,GA] = assigngroupname(sc,gcc,snc,pFun)
%% creating Exp condition variable
cd(pFun)
load('variables.mat');

%% identify groups to be assigned names
glist = {}; 
for x = 1:size(sc,1);
    glist{x,1} = strcat(sc{x,snc},'_',sc{x,gcc}); % create group name (strain_condition)
end
groupcode = unique(sc(:,gcc)); % get unique groups
strain = unique(sc(:,snc)); % get unique strains
groups = unique(glist(:,1)); % get unique strain_groups


%% Prepare variables
% see if strain is the only variable
vn = [];
disp(groups);
if size(groupcode,1) - size(strain,1) ==0;
    display('strain is the only variable detected...');
else
    display('strain is not the only variable... proceed to assignment');
    % ask how many variables applies
    disp(variable);
    vn = input('\nHow many variables shown above applies?\nExample: if you have Dose and Food as variables, enter "2"\nIf you do not see your variable on your list, enter 0:\n');
end
% get level 1 variable indexes
if vn ==0;
    error('Please talk to Conny to set up your variable before proceeding');
end
    
if isempty(vn) ==0; % if vn is not empty
    disp(variable);
    vi = []; % declare variable index
    for x = 1:vn; 
        vi(x,1) = input(sprintf('Enter the index of variable #%d: ', x)); % choose variables
    end
end


%% assign group codes
for x = 1:size(vi,1);% cycle through variable level 1
    display('IV index:');
    disp(Cond{vi(x,1),5}{1}) % display remaining groups
    display(' ');
    q1 = 'Enter IV index for group "%s": ';
    q2 = 'Please Re-enter correct IV index for group "%s". If your group is not shown above, enter 0: ';
    for x1 = 1:size(groups,1); % cycle through all groups for variable level 2
        i = [];
        i = input(sprintf(q1,groups{x1,1}));
        while isempty(i) ==1;
            i = input(sprintf(q2,groups{x1,1})); 
        end
        
        while i > size(Cond{vi(x),3},1);
            i = input(sprintf(q2,groups{x1,1})); 
        end
        
        while i ==0; % if no group name pre assigned
            groups(x1,x+1) = {'unkonwn'}; 
        end
        
        if isequal(i,Cond{vi(x),4}) ==0; % if the selected group is not a ctrl group
            groups(x1,x+1) = {Cond{vi(x),3}{i,2}}; % code group name
        end
    end
end



%% construct new name
e = size(groups,2)+1; % find last cell
% construct new name
for x = 1:size(groups,1); % cycle through rows in strain_group
    i = strfind(groups{x,1},'_'); % find index to _a
    sname = groups{x,1}(1:i-1); % get strain name
    for y = 2:e-1; % cycle through columns in groups
        if isempty(groups{x,2}) ==0; % if there is a group assigned?
            sname = strcat(sname,'_',groups{x,2}); % construct name
        else 
            sname = sname;
        end
    end
    groups{x,e} = sname;
end

%% construct index
original = {};
for x = 1:size(sc,1);
    original{x,1} = strcat(sc{x,snc},'_',sc{x,gcc});
end

%% match up group names with original list
for x = 1:size(original,1);
    for y = 1:size(groups,1);
        if strmatch(groups{y,1},original{x,1}) ==1;
            glist(x,1) = groups(y,e); % code it in c
        end
    end
end

%% create check display
r = size(groups,1);
uniqueglist = cell(r,1);
for x = 1:r;
    uniqueglist(x,1) = {strcat(groups{x,1}(end),'=', groups{x,3})};
end

% create GA
% extract code from groups
for x = 1:size(groups,1);
    GA{x,1} = groups{x,1}(end);
    GA(x,2) = groups(x,3);
end

  
end