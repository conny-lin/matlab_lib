function correctMWTnameSingle(pFun,pMWTf)
%% CorrectMWTname

%% list all files within an MWT folder
% user input: drag MWT folder in Command Window
% [TEST PATH] pMWTf = '/Users/connylinlin/Desktop/Matlab Test files/Correct for incorrect MWT file name/20130622_162804';
% define paths
addpath(genpath(pFun)); % generate path for modules% add all paths
pMWTf = cd;

%% get old name
MWTf = filelist(pMWTf); % get files
[fc,header] = filenameExt(MWTf, 1); % get file names and extension
%%

display(' ');
display('Name to be fixed is...');
disp(fc{1,1}) % display current file name

%% Correct name
% n = askRunCond; % ask for correct parameters and construct new name
% Check name
disp(fc{1,1})
q1 = input(sprintf('new name: %s\nIs this Correct (1=yes, 0=no): ', fc{1,1})); % ask if correct

if q1 ==0;
    n = correctSpecificMWTRunCode(fc);
else
    n = fc;
end
fc(:,1) = n(1,1); % replace names with new names

%% change name in files
for x = 1:size(fc,1);
    if isempty(fc{x,3})==1;
        fc{x,1} = strcat(fc{x,1},'.',fc{x,2});
    else
        fc{x,1} = strcat(fc{x,1},'_',fc{x,3},'.',fc{x,2}); % make new file names
    end
    fc{x,2} = strcat(pMWTf,'/',fc{x,1}); % create new path
    if isequal(MWTf{x,2},fc{x,2}) ==0; % check if file name not equal
        movefile(MWTf{x,2},fc{x,2}); % move file
    end
end



