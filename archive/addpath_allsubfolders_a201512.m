function addpath_allsubfolders(packagepath)

% validate input path
p = fileparts(packagepath);
if isdir(p) == 0; error('path given is not a folder'); end


%% get path to all folders under p
a = genpath(p);
paths = regexp(a,':','split')';
i = cellfun(@isdir,paths); % check if all are dir
pf = paths(i); % get only the one that is dir

%% add path
for x = 1:numel(pf)
    addpath(pf{x});
end
