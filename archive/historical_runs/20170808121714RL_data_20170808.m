
%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSaveM = setup_std(mfilename('fullpath'),'RL','genSave',false);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%


%% BUILD DATABASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
MWTDatabase_v2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% Search MWTDB
% groupnames = {'DA609_E3d24h0mM_R1h_T4d0mM'
% 'DA609_E3d24h0mM_R1h_T4d200mM'
% 'DA609_E3d24h200mM_R1h_T4d0mM'
% 'DA609_E3d24h200mM_R1h_T4d200mM'
% 'N2_E3d24h0mM_R1h_T4d0mM'
% 'N2_E3d24h0mM_R1h_T4d200mM'
% 'N2_E3d24h200mM_R1h_T4d0mM'
% 'N2_E3d24h200mM_R1h_T4d200mM'};

[pMWT,MWTDB,Set]  = search_MWTDB('expter',{'AK'});
tabulate(MWTDB.groupname)

%% group by strains
strains = unique(MWTDB.strain);
strains(ismember(strains,'N2'))= [];

% for each strain take n2 control
for si = 1:numel(strains)
   strainname = strains{si};
   i = ismember(MWTDB.strain,strainname);
   e = unique(MWTDB.expname(i));
   MWTDBe = MWTDB(ismember(MWTDB.expname,e),:);
   MWTDBe(~ismember(MWTDBe.strain,{'N2',strainname}),:) = [];
   pMWT = MWTDBe.mwtpath;
   
   pSaveS = create_savefolder(pSave,strainname);
   MWTSet = Dance_RapidTolerance(pMWT,'pSave',pSaveS);

end

%% CLOSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
fprintf(' END \n');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


