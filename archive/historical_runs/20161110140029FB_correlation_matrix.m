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


%% EQ descriptive +++++++++++++++
%% zscore
S = [Userinfo(:,{'age','gender','education'}) ScoreFinal];
plotmatrix(table2array(S))
savename ='correlation matrix';
savefig(gcf,fullfile(pM,savename));
printfig(savename,pM,'w',8,'h',8');