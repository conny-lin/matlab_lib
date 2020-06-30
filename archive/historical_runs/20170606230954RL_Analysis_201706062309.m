%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pDataHome = '/Users/connylin/Dropbox/RL Data by strain';


strainlist = dircontent(pDataHome);
for si = 1:numel(strainlist)
    strain = strainlist{si};
    Show_Alcohol3Factor(strain,pDHome,'expdatemin',20170210);
end