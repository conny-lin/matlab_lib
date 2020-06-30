
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% Curve summary
pData = fullfile(fileparts(pM), '/ephys_accpeak_graph2_stats');
load(sprintf('%s/%s',pData,strain));

return

