%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false);
% addpath(pM);
% ----------------------------


%% SETTING +++++++++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
% ---------------

%% load data +++++++++++++
load(fullfile(pData,'Data.mat'));
% ----------------------------

%% setting

%% transform data
Mtype = Score.Properties.VariableNames;
ScoreFinal = Score;
ScoreFinal(:,4:6) = ScorePercentile(:,4:6);
save(fullfile(fileparts(pM),'Data.mat'),'ScoreFinal','-append');



























