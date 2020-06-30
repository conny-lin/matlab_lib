function [a] = filelist(p)
% function [a] = filelist(p)
% create a list of files under path p and create paths for each file, 
% excluding {'.', '..','.DS_Store'}
% 
% a = cell array
% a(:,1) = name of the folders
% a(:,2) = paths of the folders
%
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
end




