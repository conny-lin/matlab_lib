function removegroupfolders(pExp,pGroupf)
% move group files
cd(pExp);
mkdir('UngroupRecord');
p = strcat(pExp,'/','UngroupRecord');
for x = 1:size(pGroupf,1);
    movefile(pGroupf{x,1},p);
end
% save ungroup record
cd(p);
UngroupRecord = I;
[savename] = creatematsavename(pExp,'UngroupRecord','.mat'); % create save name
save(savename,'UngroupRecord');

end

function [savename] = creatematsavename(pExp,prefix,suffix)
% add experiment code after a prefix i.e. 'import_';
[~,expn] = fileparts(pExp);
i = strfind(expn,'_');
if size(i,2)>2;
    expn = expn(1:i(3)-1);
else
    ...
end
savename = strcat(prefix,expn,suffix);
end
function [a,b,c,d] = dircontent(p)
% a = full dir, can be folder or files, b = path to all files, 
% c = only folders, d = paths to only folders
cd(p); % go to directory
a = {}; % create cell array for output
a = dir; % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = []; 
b = {};
c = {};
d = {};
for x = 1:size(a,1); % for all files 
    b(x,1) = {strcat(p,'/',a{x,1})}; % make path for files
    if isdir(b{x,1}) ==1; % if a path is a folder
        c(end+1,1) = a(x,1); % record name in cell array b
        d(end+1,1) = b(x,1); % create paths for folders
    else
    end
end
end
