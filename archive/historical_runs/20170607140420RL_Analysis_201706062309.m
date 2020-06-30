%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% paths
pDHome = '/Users/connylin/Dropbox/RL Data by strain';
pSummary = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Post Defense Data/Analysis 20170518';

strainlist = dircontent(pDHome);
for si = 1:numel(strainlist)
    
    strain = strainlist{si};
    
    Ochestra_Alcohol3Factor(strain,pDHome,'expdatemin',20170210);
    
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
