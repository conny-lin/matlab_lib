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
for si = 2:numel(strainlist)
    
    strain = strainlist{si};
    
    pstrain = fullfile(pData,strain);
    
    f = dircontent(pstrain);
    rescuestrain = sum(regexpcellout(f,'rescue')) > 0;
    
    clear pgraph;
    if ~rescuestrain
        pgraph = fullfile(pstrain, 'EARS raster report v3.pdf');
    else
        rescue_v2 = sum(regexpcellout(f,'rescue v2'));
        if rescue_v2
            pgraph = fullfile(pstrain, 'EARS raster report rescue v2.pdf');
        else
            pgraph = fullfile(pstrain, 'EARS raster report rescue.pdf');
        end
    end
        
    
    pd = fullfile(pSave, [strain,'EARS raster report.pdf']);
    
    
    copyfile(pgraph,pd);
    
end