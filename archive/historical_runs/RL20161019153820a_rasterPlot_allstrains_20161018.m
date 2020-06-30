%% raster plot data all strains

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
addpath('/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/x-SummaryAssemble/Functions');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/rasterPlot_colorSpeed');
% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
% get strain info
s = dircontent(pData);
strainNames = DanceM_load_strainInfo(s);
pathwayseq = {'VGK'
    'neuropeptide'
    'Synaptic'
    'Neuroligin'
    'Gluamate'
    'Dopamine'
    'G protein'
    'Gai'
    'Gaq'
    'Gas'
    'TF'};
strainNames.seq = zeros(size(strainNames,1),1);

    
y = 1;
for x = 1:numel(pathwayseq)
    i = ismember(strainNames.pathway,pathwayseq{x});
    
    k = sum(i);
    strainNames.seq(i) = y:y+k-1;
    y = y+k;
end
strainNames = sortrows(strainNames,{'seq'});
strainlist = strainNames.strain;
%----------------


%% exclude BZ
excl = {'JPS328' 'JPS338' 'JPS326' 'JPS344' 'NM1630' 'BZ142' 'JPS345','JPS383','VG301','VG302','BZ416','VG254','VG202','RM3389'};
i = ismember(strainNames.strain,excl);
% i = [find(~i) ;find(i)];
strainNames(i,:) = [];

return

%% cycle through strain
for si = 1:numel(strainlist)
    % strain info +++++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    % ------------------
    
    % report progress %------------
    fprintf(''); % separator
    processIntervalReporter(numel(strainlist),1,'strain',si);
    % ------------------------------
   
    % -----------------

    % create save path +++++++++++++++++++
    prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
    suffix = 'Raster';
    pSave = fullfile(prefix,strain,suffix);
    % -----------------------------------

    % load data +++++++++++++++++++
    prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
    suffix = 'MWTDB.mat';
    p = fullfile(prefix,strain,suffix);
    load(p);
    % ---------------------------------

    % dance raster ---------------
    Dance_Raster(MWTDB,'pSave',pSave,'graphopt',1);
    % ----------------------------
end
