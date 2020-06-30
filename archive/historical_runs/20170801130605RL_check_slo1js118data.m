%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'RL','genSave',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SETTINGS
displayopt = true;
overwrite = false;


[pMWT,MWTDB,Set] = search_MWTDB('groupname',{'NM1630','NM1630_400mM','N2','N2_400mM'},...
    'ctrlexp','within','ctrlgroup',{'N2','N2_400mM'},'ISI',10);


%% INPUTS
pData = fullfile(pSave,'Data');
% strainlist = {'NM1630'};

% for strainlisti = 1:numel(strainlist)
    
    strainname = 'NM1630'; % get strain name
    pSaveS = fullfile(pSave,'Data',strainname); % save path
    A = load(fullfile(pSaveS,'MWTDB.mat')); % get mwt paths
%     pMWT = MWTDB.mwtpath; % pMWT
    
    MWTSet = Dance_rType2_v1707(pMWT,pSaveS); % TAR    

%     MWTSet = Dance_ShaneSpark_v1707(pMWT,pSaveS); % TWR
%     MWTSet = Dance_rType_v1707(pMWT,pSave,'displayopt',displayopt,'overwrite',overwrite); % TAR    
    
%     Data_Sen = Dance_InitialEtohSensitivityPct_v1707(pMWT,pSaveS); % run initial sensitivity



% end

