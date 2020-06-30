%% OBJECTIVE:
% establish N2 pheontype
%% INITIALIZING
clc; clear; close all;
%% PATHS
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'RL','genSave',false);

%% load dance data
pData = [fileparts(pSave),'/Dance_RapidTolerance'];
cd(pData);
Db = readtable('info_exclude.csv');
pMWT = Db.mwtpath;
pSaveA = fileparts(pSave);
MWTSet = Dance_RapidTolerance(pMWT,'pSave',pSaveA);

return
