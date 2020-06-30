function [list, pHome] = folderlist(p)
% [list, pHome] = folderlist(p)
% create a list of all subfolders within a home folder
% p = path to home folder (output as pHome)
% list cell array
% list(:,1) = folder name
% list(:,2) = folder path
% 
% pHome = upper path

list = {}; % create output cell array
p = genpath(p); % generate subfolder paths
pathsep = strfind(p,':')'; % identify location of ":" that separates subfolder path
pHome = p(1:pathsep(1,1)-1); % record home path

for x = 1:size(pathsep,1)-1; % for every path separated by ":"
    list{end+1,2} = p(pathsep(x,1)+1:pathsep(x+1,1)-1); % record path 
end

for x = 1:size(list,1); % for every folder
[a,b] = fileparts(list{x,2}); % find folder parts
list{x,1} = b; % record folder name into list(:,1)
end

end

