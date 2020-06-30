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


%% factor analysis
S = [Userinfo(:,{'age','gender','education'}) ScoreFinal];
S = table2array(S);
% eliminate invalid data
S(any(isnan(S),2) | any(isinf(S),2),:) = [];
%%
[loadings,specV,T,stats] = factoran(S,1);










