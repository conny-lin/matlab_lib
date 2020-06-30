
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
U = Userinfo(:,{'ls'});
EQ35 = outerjoin(U,EQ35,'Key','ls','MergeKey',1);
EQ35 = outerjoin(U,EQ37,'Key','ls','MergeKey',1);












