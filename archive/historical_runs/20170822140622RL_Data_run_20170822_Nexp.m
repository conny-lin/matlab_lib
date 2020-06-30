%% OBJECTIVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815
% updated rtype stats output ready for results summary table thus needs
% rerun
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815

%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% OVERALL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
pDataBase = '/Volumes/COBOLT/MWT';
pData = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Tbl2 genetic screen result summary/Data_by_ortholog/Data';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% GET STRAIN INFO FROM CURRENT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
% get group names
[fn,pM] = dircontent(pData);
% minus archive code folder
pM(regexpcellout(fn,'[_]')) = [];
% get gene names
[fn,pM] = cellfun(@dircontent,pM,'UniformOutput',0);
pM = celltakeout(pM);
% get strain names
[fn,pM] = cellfun(@dircontent,pM,'UniformOutput',0);
pstrains = celltakeout(pM);
strainnames = celltakeout(fn);
% get gene name
pM = cellfun(@fileparts,pstrains,'UniformOutput',0);
[pM,genenames] = cellfun(@fileparts,pM,'UniformOutput',0);
% get groupname
[pM,groupnames] = cellfun(@fileparts,pM,'UniformOutput',0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808



%% ANALYZE NEW DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
for si = 1:numel(strainnames) % for each strain
    % report loop
    loopreporter(si,'strain',1,numel(strainnames));
    strain = strainnames{si}; % strain name
    % get pSave
    pSaveStrain = pstrains{si};
    % get pMWT ----------
    pshanespark = fullfile(pSaveStrain,'Dance_ShaneSpark_v1707','Dance_ShaneSpark_v1707.mat');
    load(pshanespark);
    pMWT = MWTSet.pMWT;
    Dance_AlcoholSTH_v1707(pMWT,pSaveStrain,'bypass','chor','pshanespark',pshanespark);
    % analysis 
%     Dance_InitialEtohSensitivityPct_v1707(pMWT,pSaveStrain);
%     MWTSet = Dance_ShaneSpark_v1707_NExp(pMWT,pSaveStrain);
    
%     Dance_rType2_v1707(pMWT,pSaveStrain);
return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808

%% NOTE FOR FAILED 
% VG254, KJ300, VC990, MT2426, RM1702, CG197, VC576

%% FINISH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
fprintf(' END \n');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808



