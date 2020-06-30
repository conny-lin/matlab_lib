function addpath_allsubfolders(pFun)
%% addpath for all first level sub folders provided by cell array of directories

%% validate input path
if ischar(pFun); pFun = {pFun};end
val = cellfun(@isdir,pFun);
if sum(val) ~= numel(pFun)
    disp(char(pFun(~val)))
    error('path given is not a folder'); 
end


%% get path to first level folders under p
[~,~,~,pf] = cellfun(@dircontent,pFun,'UniformOutput',0);
pf(cellfun(@isempty,pf)) = [];
pf = [celltakeout(pf); pFun];

%% add path
for x = 1:numel(pf)
    addpath(pf{x});
end
