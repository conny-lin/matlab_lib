
%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false);
% addpath(pM);
% ----------------------------

%% load data +++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
load(fullfile(pData,'Data.mat'));
% ----------------------------

%%

[i,j] = ismember(EQ35.ls,Userinfo.ls);
sum(~i)
j(1:10)

% EQ
