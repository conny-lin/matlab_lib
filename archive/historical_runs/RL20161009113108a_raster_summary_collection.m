%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% cd
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/Summary v3/ratser 10sISI by strains RasterNew green/Raster_green_RL20161004';

% set up output folder
pSave = pM;

% get strain
[~,~,strainlist] = dircontent(pData);

% copy graph
for si = 1:numel(strainlist)
    
    strain = strainlist{si};
    
    pstrain = fullfile(pData,strain);
    
    pgraph = fullfile(pstrain, 'EARS raster report v3.pdf');
    
    pd = fullfile(pSave, [strain,'.pdf']);
    copyfile(pgraph,pd);
    
    return
end