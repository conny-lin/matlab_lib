%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pDataBase = '/Volumes/COBOLT/MWT';
load(fullfile(pDataBase,'MWTDB.mat'));

%% split genotype information
S = MWTDB.strain;
a = S.genotype;
a = regexpcellout(a,'[(]|[)]|[;]|[[]|[]]','split');