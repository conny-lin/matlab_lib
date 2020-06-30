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
Z = nan(size(Score));
for ci = 1:size(Score,2)
    s = table2array(Score(:,ci));
    z = zscore(s);
    Z(:,ci) = z;
end
%     n = numel(unique(s));
%     hist(s,n);
%     titlename = ['EQ Stroop ',mtype];
%     title(titlename)
%     printfig(titlename,pM);

names = Score.Properties.VariableNames;
Zscore = array2table(Z,'VariableNames',names);
save(fullfile(fileparts(pM),'Data.mat'),'Zscore','-append');





















