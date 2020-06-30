function ungroupRC(pBet,pFun)
%% ungroup from RC
%pFun = '/Users/connylinlin/Documents/Lab/Methods & Database/Analysis/MatlabProgramming/Program_Coding/Analysis3all/UngroupfromRC/Func';
%pBet = '/Users/connylinlin/Desktop/MatlabTestFiles_MatchGroupNameMat/Analyzed_analysis3_includgroupnames';
addpath(pFun);

%% program starts
[~,~,~,pRCf] = dircontent(pBet); % get RC list
for x = 1:size(pRCf,1); % loop through RC
    pRC = pRCf{x,1}; % get pRC path
    [~,~,~,pExpf] = dircontent(pRC); % get exp folder list
    for y = 1:size(pExpf,1);
        pExp = pExpf{y,1};
        movefile(pExp,pBet); % move to pBet folder
    end
    rmdir(pRC,'s');
end
end

%% Subfunctions
function [a,b,c,d] = dircontent(p)
% a = full dir, can be folder or files
% b = path to all files
% c = only folders
% d = paths to only folders

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
