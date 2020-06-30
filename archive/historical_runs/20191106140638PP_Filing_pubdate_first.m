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
A = regexpcellout(fileNames,'20\d{6}','match'); % find any matches to 8 digit date string
% set output array
dateNumner = cell(size(A,1),1);
% evaluate each row for:
for i = 1:size(A,1)
    processIntervalReporter(size(A,1),1,'file',i);
    % get file's date detection
    a = A(i,:);
    iaEmpty = cellfun(@isempty,a);
    a(iaEmpty) = [];
    
    clear d; % clear d var
    
    % if there is one 8 digit date, enter it
    if numel(a) == 1  
       d = a;
    
    % if more than one 8 digit date, enter manually
    elseif numel(a) > 1 
       fprintf('\n%s\n','Issue: More than one 8 digit date code');
       fprintf('Filename: %s\n',fileNames{i}); % display name of the file
       b = input('Enter 8 digit date:\n','s');
       d = {b};
    
    % if there is no 8 digit date...
    elseif numel(a) ==0 
       b = fileNames{i}; % get file name
       c = regexp(b,'20\d{4}','match'); % look for 6 digit date (yyyymm)
       
       % if only 1 yyyymm, add empty dd
       if (~isempty(c)) && (numel(c)== 1) 
           d = strcat(c, '00'); % add 4 empty dd
       
       % if more than 1 yyyymm, enter manually
       elseif (~isempty(c)) && (numel(c)> 1) % if only 1 yyyymm
           fprintf('\n%s\n','Issue: More than one 8 digit date code');
           fprintf('Filename: %s\n',fileNames{i}); % display name of the file
           b = input('Enter 8 digit date:\n','s');
           d = {b};
           
       % if no yyyymm, look for 4 digit yyyy...
       elseif isempty(c)
           c = regexp(b,'20\d{2}','match'); % look for 4 digit yyyy
           
           % if only 1 yyyym add empty mmdd
           if (~isempty(c)) && (numel(c) ==1)
                d = strcat(c, '00'); % add 4 empty dd
               
           % if more than 1 yyyy, enter manually
           elseif (~isempty(c)) && (numel(c)> 1) % if only 1 yyyy
                fprintf('\n%s\n','Issue: More than one 8 digit date code');
                fprintf('Filename: %s\n',fileNames{i}); % display name of the file
                b = input('Enter 8 digit date:\n','s');
                d = {b};    
           
           % otherwise stop and code
           else
                error('code how to look into file names without 6 or 4 digit dates');
           end
            
       % otherwise stop and code
       else
           error('have not think of this permutation');
       end
       
    % otherwise stop and code     
    else
        error('have not think of this permutation');
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

