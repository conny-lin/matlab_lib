%% OBJECTIVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% see if different recovery time affects tolerance of speed differently
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'RL','genSave',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load MWTDB
pDataBase = '/Volumes/COBOLT/MWT';
load(fullfile(pDataBase,'MWTDB.mat'),'MWTDB');
MWTDB = MWTDB.text;

%% search for ankie or james data
i = regexpcellout(MWTDB.rx,'Rvaries');
MWTDBT = MWTDB(i,:);
% tabulate(MWTDBT.rc)
pMWT = MWTDBT.mwtpath;
MWTSet = Dance_RapidTolerance(pMWT,'pSave',pSave);
% size(MWTDBT)




