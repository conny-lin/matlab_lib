function [drivepath, drivenames] = findharddrive
%% findharddrive(path)
% find hard drive attached to the same Mac computer this function file is
% located


invalidnames = {'Macintosh HD','MobileBackups','.DS_Store','.','..'};

% pfun = which(mfilename);
p = '/Volumes';
cd(p); % go to directory
a = {};
a = dir(p); % list content
a = {a.name}'; % extract folder names only
a(ismember(a,invalidnames)) = []; 
b = {};
for x = 1:size(a,1); % for all files 
    b{x,1} = [p,'/',a{x,1}]; % make path for files
end

drivenames = a;
drivepath = b;


