function [f] = getalldir(p)
%% get path to all folders under p
a = genpath(p);
paths = regexp(a,':','split')';
i = cellfun(@isdir,paths); % check if all are dir
f = paths(i); % get only the one that is dir
end