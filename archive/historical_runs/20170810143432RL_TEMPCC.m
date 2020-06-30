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
    % create group name
    g = [strain,'_400mM'];    
    % search database
    [~,DB]  = search_MWTDB('groupname',g,'rc','100s30x10s10s');
    e = unique(DB.expname); % get target exp
    % create group list
    g = {'N2','N2_400mM',strain,g};
    % search database
    pMWT  = search_MWTDB('expname',e,'groupname',g,'rc','100s30x10s10s');
    % get rid of zips
    pMWT(regexpcellout(pMWT,'zip')) = [];
    % analysis 
    Dance_ShaneSpark_v1707(pMWT,pSaveStrain)
    Dance_rType2_v1707(pMWT,pSaveStrain);
    Dance_InitialEtohSensitivityPct_v1707(pMWT,pSaveStrain);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808



%% FINISH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
fprintf(' END \n');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808



