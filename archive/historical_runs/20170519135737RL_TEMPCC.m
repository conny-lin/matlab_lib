%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return

%%
pData = '/Volumes/COBOLT/MWT';
pMWTDB = '/Volumes/COBOLT/MWT';
MWTDB = makeMWTDatabase3(pData,pMWTDB);



%%
R1(cellfun(@isempty,R1)) = {''};












