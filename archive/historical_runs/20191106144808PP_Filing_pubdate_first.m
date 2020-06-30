%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'PP','genSave',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MANUALLY DEFINED VARIABLES
pD = '/Users/connylin/Dropbox/CA Publications'; % define file path

%% PREPARE FILE NAMES AND OUTPUT
% output array
FileNameTable = table;

% get file paths and names
[FN,pF] = dircontent(pD); 

% get extention
A = regexpcellout(FN,'[.]','split'); % split file name and extension
fileNames = A(:,1); % file names
extensionNames = A(:,2); % extension names
clear A; % clear temp var

%% EXTRACT FILE COMPONENTS - DATE
% date (in format of 20191106)
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
    
    d = {};
    
    % if there is one 8 digit date, enter it
    if numel(a) == 1  
       d = a;
    
    % if there is no 8 digit date...
    elseif numel(a) ==0 
       b = fileNames{i}; % get file name
       c = regexp(b,'20\d{4}','match'); % look for 6 digit date (yyyymm)
       
       % if only 1 yyyymm, add empty dd
       if (~isempty(c)) && (numel(c)== 1) 
           d = strcat(c, '00'); % add 4 empty dd
           
       % if no yyyymm, look for 4 digit yyyy...
       elseif isempty(c)
           c = regexp(b,'20\d{2}','match'); % look for 4 digit yyyy
           
           % if only 1 yyyy add empty mmdd
           if (~isempty(c)) && (numel(c) ==1)
                d = strcat(c, '0000'); % add 4 empty dd
           
           % if there is no date at all, add 00000000
           elseif isempty(c)
               d = {'00000000'};
           end
           
       end
       
    end
    
    % if still no determined date, enter manually
    if isempty(d)
       fprintf('\n%s\n','Issue: More than one 8 digit date code');
       fprintf('Filename: %s\n',fileNames{i}); % display name of the file
       b = input('Enter 8 digit date:\n','s');
       d = {b};  
    end
    
    dateNumber(i,1) = d; % enter 8 digit date in array
end

% final check dates are all 8 digits
a = cellfun(@numel,dateNumber);
if max(a) ~= min(a)
    error('some date strings are not in 8 digits');
end

% get info into table
FileNameTable.date = dateNumber;

%% EXTRACT FILE COMPONENTS - SECTOR
fprintf('\n\nGetting sector code...');
% set output array
sectorNames = cell(size(A,1),1);

% evaluate each row for:
for i = 1:size(A,1)
    %% report progress
    processIntervalReporter(size(A,1),1,'file',i);
    
    % set up data output var
    d = {}; 
    
    % get file name
    fn = fileNames{i};
    
    % get 2 digit upper case
    a = strsplit(fn);
    letternumbers = cellfun(@numel,a);
    a = a(letternumbers == 2)';
    b = regexpcellout(a,'[A-Z]{2}','match');
    b(cellfun(@isempty,b)) = [];
    a = b;
    
    % if only 1 2 digit upper case
    if numel(a) == 1
        d = a;
    end
    
    % if more than 1 2 digit upper case (manual)
    % if no 2 digit upper case (manual)
    if isempty(d)
       fprintf('Filename: %s\n',fileNames{i}); % display name of the file
       b = input('Enter 2 upper letter sector code:\n','s');
       d = {b};  
    end
    
    sectorNames(i,1) = d; % enter 8 digit date in array
end

% final check sector code are all 2 digits
a = cellfun(@numel,sectorNames);
if max(a) ~= min(a)
    error('some sector code strings are not 2 letters');
end

% view unique code
unique(sectorNames)

% get info into table
FileNameTable.sector = sectorNames;


% type 

%% EXTRACT FILE COMPONENTS - TYPE
fprintf('\n\nGetting type code...');
% set output array
typeNames = cell(size(A,1),1);

% evaluate each row for:
for i = 1:size(A,1)
    %% report progress
    processIntervalReporter(size(A,1),1,'file',i);
    
    % set up data output var
    d = {}; 
    
    % get file name
    fn = fileNames{i};
    
    % get 1st letter descriptions
    a = strsplit(fn);
    a = a{1};
    
%     % if only 1 2 digit upper case
%     if numel(a) == 1
%         d = a;
%     end
%     
%     % if more than 1 2 digit upper case (manual)
%     % if no 2 digit upper case (manual)
%     if isempty(d)
%        fprintf('Filename: %s\n',fileNames{i}); % display name of the file
%        b = input('Enter type name:\n','s');
%        d = {b};  
%     end
%     
    sectorNames(i,1) = d; % enter 8 digit date in array
end


% view unique code
unique(sectorNames)

% get info into table
FileNameTable.type = typeNames;


return
%% NOT FINISHED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

