%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Search MWTDB for experiments to analyze %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(fullfile('/Volumes/COBOLT/MWT','MWTDB.mat')); % load MWTDB
i = MWTDB.text.exp_date > 20170210; % search for a certain date
MWTDBLocal = MWTDB.text(i,:); % get local MWTDB
strainNames = MWTDB.strain(ismember(MWTDB.strain.strain,MWTDBLocal.strain),:); % get strain info 
strainNames(ismember(strainNames.strain,'N2'),:) = []; % delete N2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Run Dance , by strain ============================================
for si = 1:size(strainNames,1)
    
    % strain info +++++
    strain = strainNames.strain{si}; % strain name
    genotype = strainNames.genotype{si}; % genotype name
    % ------------------
    
    
    % report progress %------------
    fprintf('%s\n',strain); % separator
    processIntervalReporter(size(strainNames.strain,1),1,'*** strain ****',si); % report progress
    % ------------------------------
        
    % find sources files %------------
    i = ismember(MWTDBLocal.strain,strain); % find pMWT with strain name
    expname = unique(MWTDBLocal.expname(i)); % find experiment name
    i = ismember(MWTDBLocal.expname, expname); % find exp containing strain
    j = ismember(MWTDBLocal.strain,{'N2',strain}); % find strain name of wildtype or strain
    M = MWTDBLocal(i & j,:); % get MWTDB to mwt files
    % ------------------------------
    
    pMWT = M.mwtpath; % mwt paths
    pSave = create_savefolder(pM,'Data',strain,'TWR'); % create save folder
    
    return
    MWTSet = Dance_ShaneSpark4(pMWT,pSave);

    return

end