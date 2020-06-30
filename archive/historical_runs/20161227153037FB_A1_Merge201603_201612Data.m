%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% SETTINGS
pDataFolder = '/Users/connylin/Dropbox/FB/Database';





%% load
LA03 = load(fullfile(pDataFolder, 'LifeAssessment_20160315','LS_user.mat'));
LA12 = load(fullfile(pDataFolder, 'LifeAssessment_20161212','LS_user.mat'));

%% find common 
fn03 = fieldnames(LA03);
fn12 = fieldnames(LA12);
fnBoth = fn03(ismember(fn03, fn12));






