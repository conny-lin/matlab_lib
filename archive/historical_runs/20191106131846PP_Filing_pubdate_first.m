%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'PP','genSave',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MANUALLY DEFINED VARIABLES
pD = '/Users/connylin/Dropbox/CA Publications'; % define file path

%% PREPARE FILE NAMES
% get file paths and names
[FN,pF] = dircontent(pD); 

% get extention
A = regexpcellout(FN,'[.]','split'); % split file name and extension
fileNames = A(:,1); % file names
extensionNames = A(:,2); % extension names
clear A; % clear temp var

%% EXTRACT FILE COMPONENTS
% date (in format of 20191106) --------------------------------------------
A = regexpcellout(fileNames,'\d{8}','match'); % find any matches to 8 digit date string
% set output array
dateNumner = cell(size(A,1),1);
% evaluate each row for:
for i = 1:size(A,1)
    processIntervalReporter(size(A,1),1,'file',i)
    a = A(1,:);
    iaEmpty = cellfun(@isempty,a);
    a(iaEmpty) = [];
    if numel(a) == 1 % if there is only one date
        dateNumber{i} = a;
    elseif numel(a) == 0 % if there is no date or more than one 8 digit date
        warning('no single 8 digit date found in file name\n')
        disp(fileNames{i}) % display name of the file
        
        return
    end
    
    return
end

% evaluate if any more than one
    % choose one
% string of date for each file

% type --------------------------------------------------------------------
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

