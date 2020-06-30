function [GA] = groupnameselectfromvarlist2(RCpart,pFun,pExp,gcode)
%% creating Exp condition variable
cd(pFun)
load('variables.mat');
    
% identify groups to be assigned names
s_gcode = {}; 
for x = 1:size(RCpart,1);
    s_gcode{x,1} = strcat(RCpart{x,3},'_',RCpart{x,4}); % create group name (strain_condition)
end
s_gcode_unique = unique(s_gcode(:,1)); % get unique strain_groups

% prepare exp run condition name
[expname] = creatematsavename(pExp,'Groups detected from experiment:','');
disp(' ');
disp(expname);
disp(s_gcode_unique);

% Prep IV categories: see if strain is the only variable
vn = [];
if size(gcode,1) - size(unique(RCpart(:,3)),1) ==0; % if gcode is the same number as unique strain
    ...
else
   disp(variable); % display IV category list
   vi= str2num(input('\nEnter relevant IV category(s)...\nif more than one IV, separate answers by space\n,if not on the list, enter(0):','s')); % choose variables
end

% assign group codes
for x = 1:size(vi,1);% cycle through IV category
    display('IV index:');
    disp(Cond{vi(x,1),5}{1}) % display remaining groups
    display(' ');
    q1 = 'Enter IV index for group "%s": ';
    q2 = 'Please Re-enter correct IV index for group "%s". If your group is not shown above, enter 0: ';
    for x1 = 1:size(s_gcode_unique,1); % cycle through all groups for variable level 2
        i = [];
        i = input(sprintf(q1,s_gcode_unique{x1,1}));
        while isempty(i) ==1;
            i = input(sprintf(q2,s_gcode_unique{x1,1})); 
        end

        while i > size(Cond{vi(x),3},1);
            i = input(sprintf(q2,s_gcode_unique{x1,1})); 
        end

        while i ==0; % if no group name pre assigned
            s_gcode_unique(x1,x+1) = {'unkonwn'}; 
        end

        if isequal(i,Cond{vi(x),4}) ==0; % if the selected group is not a ctrl group
            s_gcode_unique(x1,x+1) = {Cond{vi(x),3}{i,2}}; % code group name
        end
    end
end

% construct new name
e = size(s_gcode_unique,2)+1; % find last cell

% construct new name
for x = 1:size(s_gcode_unique,1); % cycle through rows in strain_group
    i = strfind(s_gcode_unique{x,1},'_'); % find index to _a
    sname = s_gcode_unique{x,1}(1:i-1); % get strain name
    for y = 2:e-1; % cycle through columns in groups
        if isempty(s_gcode_unique{x,2}) ==0; % if there is a group assigned?
            sname = strcat(sname,'_',s_gcode_unique{x,2}); % construct name
        else 
            sname = sname;
        end
    end
    s_gcode_unique{x,e} = sname;
end

% create GA
for x = 1:size(s_gcode_unique,1);
    GA{x,1} = s_gcode_unique{x,1}(end);
    GA(x,2) = s_gcode_unique(x,3);
end
end