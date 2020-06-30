%% INITIALIZING
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false); 
pSave = fileparts(pM);

%%
addpath('/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Test codes');

%%

dircontent(pSave,'scores-export-*.csv')
% readtable(

