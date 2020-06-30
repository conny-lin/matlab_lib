%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% SETTINGS
pDataFolder = '/Users/connylin/Dropbox/FB/Database';





%% load
LA03 = load(fullfile(pDataFolder, 'LifeAssessment_20160315'));
LA12 = load(fullfile(pDataFolder, 'LifeAssessment_20161212'));









