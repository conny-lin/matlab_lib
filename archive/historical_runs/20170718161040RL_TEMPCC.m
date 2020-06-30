% % %% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'RL','genSave',false);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%% add information
S = MWTDB.strain; 

T = outerjoin(S,G,'key','strain','MergeKeys',1);
T.genotype = T.genotype_S;
T.genotype_S = [];
T.genotype_G = [];
numel(unique(T.strain))
numel(unique(S.strain))

T1 = split_genotype_info(T.genotype);
T = innerjoin(T,T1);















% 
% [strainlist a1]
