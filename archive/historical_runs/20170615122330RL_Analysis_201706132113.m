%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% variables
strainlist = {'TM2179','TM2659','TM1630'};
datemin = 20170526;


%% paths
pDHome = '/Users/connylin/Dropbox/RL/RL Data by strain';
pSummary = '/Users/connylin/Dropbox/RL/RL Pub Alcohol Genes/3-Results/Analysis';
pNewData = '/Volumes/COBOLT/MWT_New';
pDataBase = '/Volumes/COBOLT/MWT';

%% run database integration
MWTDatabase_v2(pNewData,pDataBase);
return

%% run analysis
for si = 1:numel(strainlist)
    strain = strainlist{si};
    Ochestra_Alcohol3Factor(strain,pDataBase,pDHome,'expdatemin',datemin);
    % copy graphs
    fname = [strain,'.pdf'];
    ps = fullfile(pDHome,strain,fname);
    pd = fullfile(pSummary,'Graph');
    copyfile(ps,pd);
    % copy stats
    fname = sprintf('%s stats writeup.txt',strain);
    ps = fullfile(pDHome,strain,fname);
    pd = fullfile(pSummary,'Stats');
    copyfile(ps,pd);
end


return


%% re-run stats report
for si = 1:numel(strainlist)
    strain =strainlist{si};

    pSaveS = fullfile(pDHome,strain);
    pData_Sen = fullfile(pSaveS,'Dance_InitialEtohSensitivityPct');
    pData_TAR = fullfile(pSaveS,'Dance_rType2');
    pData_SS = fullfile(pSaveS,'Dance_ShaneSpark5');
    
    load(fullfile(pData_SS,'Dance_ShaneSpark5.mat'));
    MWTDB = MWTSet.MWTDB;

    report_All(pData_Sen,pData_TAR,pData_SS,pSaveS,MWTDB,strain)
end
