%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% ----------------------------


%% SETTING +++++++++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
% ---------------

%% load data +++++++++++++
load(fullfile(pData,'Data.mat'));
% ----------------------------


%% zscore
Mtype = Zscore.Properties.VariableNames;
for x = 1:numel(Mtype)
    mtype = Mtype{x};
    s = Zscore.(mtype);
    n = numel(unique(s));
    hist(s,n);
    titlename = regexprep(mtype,'_',' ');
    title(titlename)
    printfig(titlename,pM);
end

return

%% Lifestyle
leg =[{'total'};legend_LS_subsection.subsection(2:end)];

S = [LS_Score.total LS_Score_subsection(:,2:end)];

for x = 1:size(S,2)
    mtype = leg{x};
    s = S(:,x);
    n = numel(unique(s));
    hist(s,n);
    titlename = ['LS ',mtype];
    title(titlename)
    printfig(titlename,pM);
end
return























