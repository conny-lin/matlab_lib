function [a,b] = dircontentext(p,ext)
% a = full dir, can be folder or files
% b = path to all files
% if want all files under a certain foler called ext, then do not add * mark

cd(p); % go to directory
a = {}; % create cell array for output
a = dir(ext); % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = []; 
b = {};
for x = 1:size(a,1); % for all files 
    b(x,1) = {strcat(p,'/',a{x,1})}; % make path for files
end
end