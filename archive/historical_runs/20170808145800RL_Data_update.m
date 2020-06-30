%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% OVERALL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
pDataBase = '/Volumes/COBOLT/MWT';
pData = fullfile(fileparts(pM),'Data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808

%% ADD NEW DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
MWTDatabase_v2
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
% get last analysis time from folders
% get new data from last analysis time

return
[pMWT,MWTDB,Set]  = search_MWTDB('expter',{'CR'});


%%
tabulate(MWTDB.groupname)


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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808



%% FINISH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
fprintf(' END \n');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808

























