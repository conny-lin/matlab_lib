%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% variables
strainlist = {'TM2179','TM2659','TM1630'};
datemin = 20170526;


%% paths
pDataBase = '/Volumes/COBOLT/MWT';
pDataOld = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Data old/10sIS by strains';
pDataNew = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Data new/Data';



%% MAKE TABLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170718%
% get strain list from new data
dircontent(pDataOld)
return
% get strain list from old data
% combine strain list
% get strainlist info from MWTDB
load(fullfile(pDataBase,'MWTDB.mat'));


%% get genotype matching strainlist
% 
% make table
T1 = split_genotype_info(genotypes)

% - ortholog
% - strain
% - genotype
% - mutation
% - backcross number
% - references


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170718%

