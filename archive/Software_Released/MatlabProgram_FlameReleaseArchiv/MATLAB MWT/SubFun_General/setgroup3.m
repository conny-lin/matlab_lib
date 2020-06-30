function [GA,MWTGind] = setgroup3(MWTfgcode,pFun,pExp,id)
%id = select group name method id
% no graphing sequence selection
q = 0;
while q ==0;
[GA,MWTGind] = selectgroupnamemethod2(MWTfgcode,pFun,pExp,id); % assign group name using group files 
disp(GA);
q = input('is this correct? (y=1,n=0) ');
end
end


%% [SFun] ----------------------------------------------------


function [GA,MWTGind] = selectgroupnamemethod2(MWTfgcode,pFun,pExp,id)
%% get group index
%MWTGname = MWTfdat;
if id==0;
    q1 = input('Manually assign (1), select variable (0), or use Groups*.mat(2)?\n ');
else
    q1 =id;
end

[~,Gname,~,MWTGind,RClist] = getMWTRC(MWTfgcode);
switch q1;
    case 1 % manually assign
        GA = Gname;
        disp(Gname);
        disp('type in the name of each group as prompted...');
        q1 = 'name of group %s: ';
        i = {};
        for x = 1:size(GA,1);
             GA(x,2) = {input(sprintf(q1,GA{x,1}),'s')};
        end
    case 0 % select assign (by continueing)
        [~,~,GA] = assigngroupname(RClist,4,3,pFun)
    case 2 % use group files
        cd(pExp);
        fn = dir('Groups*.mat'); % get filename for Group identifier
        fn = fn.name; % get group file name
        load(fn); % load group files
        GA = Groups;
    otherwise
        error('please enter 0 or 1');
end

end

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


function [GAA] = groupseq(GA)
%% assign sequence of groups for graphing
GAs = GA;
GAA = {};
i = num2cell((1:size(GA,1))');
GAs = cat(2,i,GA);
GAA = GAs;
disp(GAs);
q2 = input('is this the sequence to be appeared on graphs (y=1 n=0): ');
while q2 ==0;
    s = str2num(input('Enter the index sequence to appear on graphs separated by space...\n','s'));
    for x = 1:size(GAs,1);
        GAA(x,:) = GAs(s(x),:);
    end
    disp('')
    disp(GAA)
    q2 = input('is this correct(y=1 n=0): ');
end

end


