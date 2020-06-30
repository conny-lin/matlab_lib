%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pDHome = '/Users/connylin/Dropbox/RL Data by strain';


strainlist = dircontent(pDHome);

for si = 2:numel(strainlist)
    strain = strainlist{si};
    Ochestra_Alcohol3Factor(strain,pDHome,'expdatemin',20170210);
end