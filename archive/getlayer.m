function [p1] = getlayer(pHome,y)
%function [p1] = getlayer(pHome,y)
    % y = number of folder levels to the folder of interest
    % pHome = path to home folder
    % p1 = list of paths to bottom layer

    % define function paths
    pFun = '/Users/connylinlin/Documents/MATLAB/Program_UnderDevelopment/CorrectMWTname/Functions';
    addpath(genpath(pFun)); % generate path for modules% add all paths

    p1 = dirlist(pHome);
    p1 = p1(:,2);
    x = 1; % get layer 2 to y
    p2 = {};
    while x < y;
        p2 = flistperlayer(p1); % get next layer folders
        p1 = p2; % reset p1 to the next layer
        x = x+1;
    end
    
end


function [pX] = flistperlayer(p1)
    % function [pX] = flistperlayer(p1)
    %
    % p1 = path cell array. each row contains a path

    pname = 'p%d'; % set up structure array names
    pX = {};
    for x1 = 1:size(p1,1);
        structname = sprintf(pname,x1);
        pT = dirlist(p1{x1,1});% get paths for within layer 1 folder
        pSize = size(pT,1); % get number of paths
        pX(end+1:end+pSize,1) = pT(:,2);
    end

end


function [list] = dirlist(p)
% function [a] = dirlist(p)
% create a list of folders under path p and create paths for each folders, 
% excluding {'.', '..','.DS_Store'}
% 
% a = cell array
% a(:,1) = name of the folders
% a(:,2) = paths of the folders
% exclude(1,:) = cell array of files names want to exclude
% Example:
% p = '/Users/connylinlin/Desktop/Beethoven_v2_20130701';

cd(p); % go to directory
a = {}; % create cell array for output
a = dir; % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = [];  
list = {};
for x = 1:size(a,1); % for all folders 
    a(x,2) = {strcat(p,'/',a{x,1})}; % make path for folders
    % get only paths that goes to a folder to list cell array
    if isdir(a{x,2}) ==1; 
        list(end+1,1:2) = a(x,1:2); % record in cell array b
    else
    end
end
end


