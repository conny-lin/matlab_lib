% %% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'RL','genSave',true);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% 
% i = ismember(A.factors_1,'N2_400mM*acc') & ismember(A.factors_2,'N2_400mM*rev') & A.pValue >0.05;
% % i = A.pValue <0.05;
% 
% A(i,{'tap','factors_1','factors_2','pValue'})
