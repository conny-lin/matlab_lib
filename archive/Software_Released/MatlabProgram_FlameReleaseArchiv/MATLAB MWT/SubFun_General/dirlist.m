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




