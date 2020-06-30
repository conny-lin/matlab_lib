function [GA,MWTfgcode] = setgroupRaw(MWTfdat,pFun,pExp,id)
[MWTfgcode,gcode] = findMWTfuniquegroup(MWTfdat); % import group codes
correctMWTnamingswitchboard3(MWTfgcode,MWTfdat,pExp);
% check MWTf naming
[GA,MWTfgcode] = groupnameswitchboard5(MWTfdat,pFun,pExp,id);

  
end

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
function [GA,MWTfgcode] = groupnameswitchboard5(MWTfdat,pFun,pExp,id)

%% check MWTf naming
correctMWTnamingswitchboard3(MWTfdat,pExp,pFun);
% check group names
if input('MWT file naming correct? (y=1,n=0): ')==0; % ask if the MWTf naming was incorrect
    correctMWTnamingswitchboard3(MWTfdat,pExp,pFun);
end

% assign group names
% id: 0- select method, 1- select pre-defined variable, 
% 2-manually assign, 3-use premade Groups*.mat file
%MWTGname = MWTfdat; 
if id==0;
    disp(' ');
    method = char('[1] Select pre-defined variable',...
    '[2] Manually assign','[3] Use Groups*.mat file');
    disp(method);
    q1 = input('Enter method to name your group: ');
else
    q1 =id;
end
switch q1;
    case 1 % select assign (by continueing)
        %% [BUG SUSPENSION]
        warning('method [1] is currently suspended for bugs, proceed to manual naming...');
        [GA] = manualassigngroupname2(MWTfgcode);
        %[GA] = groupnameselectfromvarlist2(RCpart,pFun,pExp,gcode);
    case 2 % manually assign
        GA = {};
        [GA] = manualassigngroupname2(MWTfgcode);
    case 3 % use group files
        cd(pExp);
        fn = dir('Groups*.mat'); % get filename for Group identifier
        fn = {fn.name}'; % get group file name
        if isempty(fn) ==1;
            display('No Groups*.mat files found, proceed to manual name assignment...');
            [GA] = manualassigngroupname2(MWTfgcode);
        else
            load(fn); % load group files
            GA = Groups;
        end
    otherwise
        error('please enter 0 or 1');
end

%% [NESTED Funcitons]


function [GA] = manualassigngroupname2(MWTfgcode)
%% manually assign group code
    GA = MWTfgcode(:,1);
    disp('type in the name of each group as prompted...');
    q2 = 'name of group %s: ';
    i = {};
    for x = 1:size(MWTfgcode,1);
         GA(x,2) = {input(sprintf(q2,MWTfgcode{x,1}),'s')};
    end
end
end

function correctMWTnamingswitchboard3(MWTfgcode,MWTfdat,pExp)
disp(MWTfgcode);
if input('MWT file naming correct? (y=1,n=0): ')==0; % ask if the MWTf naming was incorrect
    disp(MWTfdat(:,2)); % display all experiment names
    if input('only group code incorect? (y=1,n=0): ')==1; 
        correctMWTfgcode(MWTfdat,pExp); % correct group code only
        display('Renaming completed, re-run analysis program...');
        return
    else
        %% [DEVELOPMENT] write renaming program
        error('Go to correct MWT naming program...');
    end
else
end

%% [NESTED FUN]
function correctMWTfgcode(MWTfdat,pExp)
    %% [FUTURE DEVELOPMENT] layer = how many layers of folder before reaching MWT folder
    % only works with grouped files
    disp(MWTfdat(:,2)); % display all experiment names
    [RCpart] = parseRCname1(MWTfdat); % ask if only group codes are inccorectto reassign
    [f,pf] = getallfilesinallgroupedMWTfolders(pExp);
    [fpart] = filenameparse2(f,1);
    A = {};
    for x = 1:size(fpart,1);
        A{x,1} = fpart{x,1}(1:end-2);
        A{x,2} = fpart{x,1}(end-1:end);
    end
    [GRA] = reassigngroupcode(RCpart); % display code only
    B = cell2mat(A(:,2)); % convert A to char array
    for x = 1:size(GRA,1);
        i = strmatch(GRA{x,1},B);
        for xi = 1:size(i,1); % for all i cells, add new code in there
            A{i(xi,1),3} = strcat(A{i(xi,1),1},GRA{x,2}); % replace with correct group/plate code
            % combine with other parts of the file name
        end
    end
    newname = {};
    for x = 1:size(fpart,1);
        if isempty(fpart{x,3})==1;
            newname{x,1} = strcat(A{x,3},'.',fpart{x,2});
        else
            newname{x,1} = strcat(A{x,3},'_',fpart{x,3},'.',fpart{x,2}); % make new file names
        end
    [pH,~] = fileparts(pf{x,1}); % get hoem path of file
    E{x,1} = strcat(pH,'/',newname{x,1}); % make new path
        if isequal(pf{x,1},E{x,1})==0; 
            movefile(pf{x,1},E{x,1});
        end
    %if isequal(MWTf{x,2},C{x,2}) ==0; % check if file name not equal
     %   movefile(MWTf{x,2},C{x,2}); % move file
    %end
    end

end
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
end

%% Shared fun
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



function [filenamelist,filepathlist] = getallfilesinallgroupedMWTfolders(pExp)
[~,~,~,pGroupf] = dircontent(pExp); % get all files under all folders
pMWTf = {};
for x = 1:size(pGroupf,1);
    [~,~,~,pf] = dircontent(pGroupf{x,1}); % get all files under all folders
    pMWTf = cat(1,pMWTf,pf);
end
filenamelist = {};
filepathlist = {};
for x = 1:size(pMWTf,1);
    [f,pf,~,~] = dircontent(pMWTf{x,1});
    filenamelist = cat(1,filenamelist,f);
    filepathlist = cat(1,filepathlist,pf); 
end
end
function [c] = filenameparse2(cell, col)
% function [c] = getMWTrunName_v20130705(cell, col))
% get run condition parts
c = cell(:,col); % declare output cell array
for x = 1:size(cell,1);
    name = cell{x,col}; % name of the MWT file
    dot = strfind(cell{x,col},'.'); % find position of dot 
    under = strfind(cell{x,1},'_'); % find position of _
    k = strfind(cell{x,1},'k'); % find position of k   

    c{x,2} = cell{x,col}(dot+1:end);% file extension

    if isempty(k) ==0;    
        c{x,3} = cell{x,1}(under(end)+1:dot-1); % file index before extension
        c{x,1} = cell{x,1}(1:under(end)-1); % code new name
    else
        c{x,1} = cell{x,col}(1:dot-1); % file name 
        c{x,3} = {};
    end
end

end
function [GRA] = reassigngroupcode(RCpart)
%% manually assign group code
GRA = RCpart(:,5);
disp(GRA);
disp('type in correct group-plate code (i.e. aa)...');
q1 = 'correct group code of %s[%s]: ';
i = {};
for x = 1:size(RCpart,1);
     GRA(x,2) = {input(sprintf(q1,RCpart{x,1},GRA{x,1}),'s')};
end
end
