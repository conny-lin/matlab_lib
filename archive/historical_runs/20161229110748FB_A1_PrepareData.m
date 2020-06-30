%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
addpath(fullfile(fileparts(fileparts(pM)),'Functions'));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% paths
pData = '/Users/connylin/Dropbox/FB/Database/LifeAssessment_20161212/LS_user.mat';
% load data
load(pData)

%% get last user scores
U = user_scores(:,{'id','user_id','played_at_utc'});



U = sortrows(U,{'user_id','played_at_utc'},{'ascend','descend'});
i = [1;diff(U.user_id)];
j = i~=0;

score_id_last = U.id(j);
