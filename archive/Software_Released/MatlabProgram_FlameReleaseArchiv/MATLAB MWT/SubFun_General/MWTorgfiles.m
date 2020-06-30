function MWTorgfiles(pFun,pExp)
%%  MWTorgfiles(pFun,pExp)
% published for Flame; Jul 19, 2013
% zip files is ok...
% Transfer raw files from MWT computer and prepare for Beethoven analysis
% Conny Lin. start 2013 July 3. Completed: 20130709 9:46am
%% warning message
display('This program only works with ungrouped MWT files...');
display('Please enter(1) to stop the program if your data is grouped,');
t1 = input('otherwise, enter any key to continue: ');
if t1 ==1;
    return
end
%% [BUG TO FIX] dealing with grouped data
%% [DEFINE BEFORE PUBLISH] Define permanent path 
% pBetC = analysis folder
% pRaw = raw data storage folder
pRaw = '/Volumes/FLAME/MWT_Data/Raw_Data';
pRawC = '/Volumes/FLAME/Student_Folders/Conny Lin/Raw_Data_new';

%% generate path to set functions
addpath(genpath(pFun)); % generate path for modules

%% find expter code
[p,~] = fileparts(pExp); % path to expter folder
[~,exptern] = fileparts(p); % get personal folder name
load('expter.mat'); % get expter.mat
a = char(expter(:,1)); % convert to char array for search
r = strmatch(exptern,a); % find expter row id
if isempty(r) ==1; % if r is empty
    error('You do nto have an expter code\nPlease talk to Conny'); 
else
    pplcode = expter{r,2}; % get expter code
end
% [SUSPEND] User input interface for expcode
%display(expter(:,1:2));
%display('If you do not see your name on the list, enter 0 to quit');
%e = input('Otherwise, enter the index to your name: '); 
%if e ==0; % if not on the list, quit
%    break
%end
%exptercode = expter{e,3};


%% get run condition 
%% [DEVELOP] for groupped folders check if folders, and if they are MWT folders
%[~,~,f,p] = dircontent(pExp);
%if isempty(f) ==0;
 %   Groupf = f;
  %  pGroupf = p;
    
   % for x = 1:size(pGroupf,1); % go in to each group folder 
    %    [zipf,pzipf,dirf,pdirf] = dircontent(pGroupf{x,1}); %get directory
     %   [ti1,t1] = validateMWTfnzip(zipf); % validate MWTf name
      %  [ti2,t2] = validateMWTfn2(dirf,pdirf); 
       % if t2 ==1 && isempty(zipf)==0; % if they are MWT folders and not zipMWTf, proceed 
        %    ...
        %elseif t1                 
        %MWTf = cat(1,MWTf,f);
        %pMWTf = cat(1,pMWTf,p);


%% check if zipped
[MWTf,pMWTf] = dircontentext(pExp,'*.zip');
if isempty(MWTf) ==0; % if there is zip files
    display('unzipping files, please wait...');
    for x = 1:size(MWTf,1);
        [pH,~] = fileparts(pMWTf{x,1}); % get home path
        unzip(MWTf{x,1},pH); % unzip them all
        delete(pMWTf{x,1}); % delete zip files
    end
end

%% import a filename for every MWT folder
[~,~,MWTf,pMWTf] = dircontent(pExp);
for x = 1:size(MWTf,1);
    [fn,~,~,~] = dircontent(pMWTf{x,1}); 
    MWTf(x,2) = fn(1,1);
end
[RC,~] = getMWTruncond_v20130703(MWTf,2); % get experiment condition

%% [FUTURE DEVELOPMENT] check over MWT namings
%% standardize exp folder name and make new paths
% standardize folder name: 20130528B_DH_100s30x10s10s
edate = input('Enter date of the experiment as "20130719": ','s');
expname = strcat(edate,RC{1,5},'_',pplcode,'_',RC{1,11});
pRawExp = strcat(pRaw,'/',expname); 
cd(pRaw);
mkdir(expname);
pBetCExp = strcat(pRawC,'/',expname); 
cd(pRawC);
mkdir(expname);
[pExpter,Expfn] = fileparts(pExp); % find home path of pExp
pExpterBet = strcat(pExpter,'/',expname); 
if isequal(expname,fn) ==0; % check if original pExp name is incorrect
    % Transfer files
    cd(pExpter);
    mkdir(expname); % make new folder
end

%% [CODE NOW] Assign group names and save Groups*.mat
%% [UPDATE REQUIRED: ASSIGN GROUP NAME AUTO]
[GA,GAA,MWTfgcode] = setgroup2(MWTf,pFun,pExp,1); %manully assign
display('preparing Group*.mat files...');
[savename] = creatematsavename(pRawExp,'Groups_','.mat');
cd(pRawExp);
save(savename,'GA','GAA','MWTfgcode');
cd(pBetCExp);
save(savename,'GA','GAA','MWTfgcode');
cd(pExpterBet);
save(savename,'GA','GAA','MWTfgcode');
display('Group*.mat saved in all locations...');
%% move files
display('file organizing begins...');
for x = 1:size(MWTf,1);
    pZipSave = strcat(pRaw,'/',expname,'/',MWTf{x,1},'.zip');
    zip(pZipSave,MWTf{x,1},pExp); % zip to Raw data
    copyfile(pZipSave,pBetCExp); % copy to pBetCExp
    copyfile(pZipSave,pExpterBet);
end
rmdir(pExp,'s');
display('File organization done, proceed to Beethoven analysis...');
end


%% Subfunctions
function [a,b,c,d] = dircontent(p)
% a = full dir, can be folder or files, b = path to all files, 
% c = only folders, d = paths to only folders
cd(p); % go to directory
a = {}; % create cell array for output
a = dir; % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = []; 
b = {};
c = {};
d = {};
for x = 1:size(a,1); % for all files 
    b(x,1) = {strcat(p,'/',a{x,1})}; % make path for files
    if isdir(b{x,1}) ==1; % if a path is a folder
        c(end+1,1) = a(x,1); % record name in cell array b
        d(end+1,1) = b(x,1); % create paths for folders
    else
    end
end
end
function [a,b] = dircontentext(p,ext)
% a = full dir, can be folder or files
% b = path to all files


cd(p); % go to directory
a = {}; % create cell array for output
a = dir(ext); % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = []; 
b = {};
for x = 1:size(a,1); % for all files 
    b(x,1) = {strcat(p,'/',a{x,1})}; % make path for files
end
end
function [c,header] = getMWTruncond_v20130703(expname, namecolumn)
% function [output,outputh] = getMWTruncond(namesource, namecolumn)
% 
% Input:
%  expname = cell array with names stored in column <namecolumn>
%
% Example:
%  expname{1,1} = 'N2_5x3_t96h20C_100s30x10s10s_C0109aa.set';
%  namecolumn = 1;
% 
% output:
%    [ 1]    'MWT file name'       
%    [ 2]    'group code'          
%    [ 3]    'group-plate code'    
%    [ 4]    'strain'              
%    [ 5]    'tracker'      
%    [ 6]    'N of starting colony'
%    [ 7]    'N of hours synched'  
%    [ 8]    'transfer method'     
%    [ 9]    'age'                 
%    [10]    'temp' 
%    
% 
% CL modified 20130703, finished: 20130703


c = {}; % declare output cell array
% create output headers
header = {'MWT file name'; 'group code'; 'group-plate code'; 'strain';...
    'tracker'; 'N of starting colony';'N of hours synched';...
    'transfer method';'age';'temp'; 'runcondition'; 'colony made date'};
headerind = num2cell((1:size(header,1))');
header = cat(2,headerind,header);

% get run condition parts
for x = 1:size(expname,1);
    name = expname{x,namecolumn}; % name of the MWT file
    dot = strfind(expname{x,namecolumn},'.'); % find position of dot
    under = strfind(expname{x,namecolumn},'_'); % find underline
    cross = strfind(expname{x,namecolumn},'x'); % find cross
    hour = strfind(expname{x,namecolumn},'h'); % find h
    c{x,1} = expname{x,namecolumn}(1:dot-1); % full name 
    c{x,2} = expname{x,namecolumn}(dot-2:dot-2); % group code
    c{x,3} = expname{x,namecolumn}(dot-2:dot-1);% plate code
    c{x,4} = expname{x,namecolumn}(1:under(1)-1); % strain
    c{x,5} = expname{x,namecolumn}(under(4)+1); % tracker  
    c{x,6} = expname{x,namecolumn}(under(1)+1:cross(1)-1); % N of starting colony
    c{x,7} = expname{x,namecolumn}(cross(1)+1:under(2)-1); % N of hours synched
    c{x,8} = expname{x,namecolumn}(under(2)+1); % transfer method
    c{x,9} = expname{x,namecolumn}(under(2)+2:hour(1)-1); % age
    c{x,10} = expname{x,namecolumn}(hour(1)+1:under(3)-2); % temp
    c{x,11} = expname{x,namecolumn}(under(3)+1:under(4)-1); % run condition
    c{x,12} = expname{x,namecolumn}(under(4)+2:under(4)+5); % colony made date
end

end
function [GA,GAA,MWTGind] = setgroup2(MWTfgcode,pFun,pExp,id)
%id = select group name method id
q = 0;
while q ==0;
[GA,MWTGind] = selectgroupnamemethod(MWTfgcode,pFun,pExp,id); % assign group name using group files 
disp(GA);
q = input('is this correct? (y=1,n=0) ');
end
[GAA] = groupseq(GA); % sort group name for graphing
end
    function [GA,MWTGind] = selectgroupnamemethod(MWTGname,pFun,pExp,id)
%% get group index
%MWTGname = MWTfdat;
if id==0;
    q1 = input('Manually assign (1), select variable (0), or use Groups*.mat(2)?\n ');
else
    q1 =id;
end

[~,Gname,~,MWTGind,RClist] = getMWTRC(MWTGname);
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
function [savename] = creatematsavename(pExp,prefix,suffix)
    % add experiment code after a prefix i.e. 'import_';
    [~,expn] = fileparts(pExp);
    i = strfind(expn,'_');
    if size(i,2)>2;
        expn = expn(1:i(3)-1);
    else
        ...
    end
    savename = strcat(prefix,expn,suffix);
    end



