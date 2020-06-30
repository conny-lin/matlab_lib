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
    a = A(i,:);
    iaEmpty = cellfun(@isempty,a);
    a(iaEmpty) = [];
    if numel(a) == 1 % if there is 1 8 digit date, 
       d = a;
    elseif numel(a) == 0 % no date
       %%
       b = fileNames{i}; % get file name
       c = regexp(b,'20\d{4}','match'); % look for 6 digit date
       if ~isempty(c) % if found
            error('code how to look into the dates');
            % look into the dates
       else % look for 4 or 6 digit date
            c = regexp(b,'20\d{2}','match'); % look for 6 digit date
            if ~isempty(c) % if found
                if numel(c) == 1 % if there is only one year
                    c = strcat(c,'0000'); % add 0000 (mmdd)
                    d = c;
                else
                    error('code how to look into 4 digit dates');
                end
            else
                error('code how to look into file names without 6 or 4 digit dates');
            end
            
       end
         
    elseif numel(a) > 1 % if more than one date
        fprintf('\n%s\n','Issue: More than one 8 digit date code');
        fileNames{i}
        fprintf('Filename: %s\n',fileNames{i}); % display name of the file
        b = input('Enter 8 digit date:\n','s');
        d = {b};
    else
        disp('have not think of this permutation');
    end
    dateNumber(i,1) = d; % enter 8 digit date in array
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

