%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'PP','genSave',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MANUALLY DEFINED VARIABLES
pD = '/Users/connylin/Dropbox/CA Publications'; % define file path

%% PREPARE FILE NAMES
[FN,pF] = dircontent(pD); % get file paths and names
% extract file components
i = regexpcellout(FN,'\W');

return

    % date
    % type
    % org
    % topic
    
% RECONSTRUCT FILE NAMES
    % date
    % type
    % org
    % topic

% CREATE CSV DATABASE
% CREATE CV TEXT OUTPUT
return
%% OLD CODES
% get file names starting with a number
i = regexpcellout(FN,'^\d{6,}');
pFT = pF(i);
FNT = FN(i)

return


%% switch the number to the end of the filename
dates = regexpcellout(FNT,'^\d{6,}','match');
text = regexpcellout(FNT,' ','split');

% combine new names
a = text(:,2:end);
a(cellfun(@isempty,a)) = {''};
b = strjoinrows([a dates],' ');
% delete more spaces
newnames = regexprep(b,'\s{2,}',' ');

%% move file
% construct new paths
for x = 1:numel(newnames)
    newname = newnames{x};
    oldname = FNT{x};
    
    pd = fullfile(pD,newname);
    ps = fullfile(pD,oldname);
    
    movefile(ps,pd,'f')

    
end
% 

