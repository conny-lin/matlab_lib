% % %% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'RL','genSave',true);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Search MWTDB
groupnames = {'DA609_E3d24h0mM_R1h_T4d0mM'
'DA609_E3d24h0mM_R1h_T4d200mM'
'DA609_E3d24h200mM_R1h_T4d0mM'
'DA609_E3d24h200mM_R1h_T4d200mM'
'N2_E3d24h0mM_R1h_E4d0mM_T5d0mM'
'N2_E3d24h0mM_R1h_T4d0mM'
'N2_E3d24h0mM_R1h_T4d200mM'
'N2_E3d24h0mM_R1h_T4d400mM'
'N2_E3d24h200mM_R1h_E4d0mM_T5d0mM'
'N2_E3d24h200mM_R1h_T4d0mM'
'N2_E3d24h200mM_R1h_T4d200mM'
'N2_E3d24h200mM_R1h_T4d400mM'};
[pMWT,MWTDB,Set]  = search_MWTDB('expter',{'JS'},'groupname',groupnames);

%% run Drunk Moves
MWTSet = Dance_RapidTolerance_v1707(pMWT,pSave);

