% CorrectMWTname_multiple
% Conny Lin. Start: 2013 July 5, 12:48am. 
% Testing: 3:40pm
% Published:___________
% 
% Objective:
    % correct for mistakes in MWT file name
    
clear;
%% define paths
pFun = '/Users/connylinlin/Documents/MATLAB/Program_UnderDevelopment/CorrectMWTname/Functions';
addpath(genpath(pFun)); % generate path for modules% add all paths
p = cd;
q1 = input('how many layers from home folder" ');
pathlist = getlayer(p,q1);

for x = 1:size(pathlist,1);
    %% get old name
    MWTf = filelist(pathlist{x,1}); % get files
    [fc,header] = filenameExt(MWTf, 1); % get file names and extension

    display(' ');
    display('Name to be fixed is...');
    disp(fc{1,1}) % display current file name

    %% Correct name
    % n = askRunCond; % ask for correct parameters and construct new name
    % Check name
    disp(fc{1,1})
    q1 = input(sprintf('New name: %s\nIs this Correct (1=yes, 0=no): ', fc{1,1})); % ask if correct
    if q1 ==0;
        n = correctSpecificMWTRunCode(fc);
    else
        n = fc;
    end
    fc(:,1) = n(1,1); % replace names with new names

    %% change name in files
    for y = 1:size(fc,1);
        if isempty(fc{y,3}) ==1;
            fc{y,1} = strcat(fc{y,1},'.',fc{y,2}); % make new file names
        else
            fc{y,1} = strcat(fc{y,1},'_',fc{y,3},'.',fc{y,2}); % make new file names
        end
        pMWTf = pathlist{x,1};
        fc{y,2} = strcat(pMWTf,'/',fc{y,1}); % create new path
        if isequal(MWTf{y,2},fc{y,2}) ==0; % check if file name not equal
            movefile(MWTf{y,2},fc{y,2}); % move file
        end
    end
end



