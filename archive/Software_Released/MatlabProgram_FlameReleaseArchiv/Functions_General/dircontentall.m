function [f,p] = dircontentall(home)
%% get path to all folders under p
paths = regexp(genpath(home),':','split')'; % 10:18am-
%%
display 'done'
%%
[a] = regexp(paths,':','split');
f = {};
% get all paths
for x = 1:numel(a); f{x,1} = char(a{x}); end

end