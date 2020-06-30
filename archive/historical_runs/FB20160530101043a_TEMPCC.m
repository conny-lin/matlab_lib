% 
% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false);


return



%%
D1 = Ephys.N2_400mM;
% summary(D1)

gn = fieldnames(Ephys);
A = cell(numel(gn),1);
L = A;
for gi = 1:numel(gn)
    d = Ephys.(gn{gi});
    A{gi} = table2array(d);
    L{gi} = repmat(gn(gi),size(d,1),1);
end

A = cell2mat(A);
L = celltakeout(L);
A = array2table(A,'VariableNames',d.Properties.VariableNames);

T = table;
T.groupname = L;
T = [T A];


%%
fn = fieldnames(T);
fn(ismember(fn,{'groupname','Properties'})) = [];
for fni = 3:numel(fn)
    fprintf('%s\n',fn{fni})
   grpstatsTable(T.(fn{fni}), T.groupname)
   
end