%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false);

addpath('/Users/connylin/Dropbox/RL/PubInPrep/PhD Dissertation/4-STH genes/4-TWR/Data');

return
%%
[d1,d2,T,T1] = habGene10sISI_f_posthoceval(strain);