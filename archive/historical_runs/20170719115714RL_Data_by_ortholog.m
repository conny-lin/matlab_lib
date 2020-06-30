%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% variables


%% paths
pDataBase = '/Volumes/COBOLT/MWT';
pDataOld = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Data old/10sIS by strains';
pDataNew = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Data new/Data';


%% MAKE TABLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170718%
% get strain list from new data
s1 = dircontent(pDataOld);
% get strain list from old data
s2 = dircontent(pDataNew);
% combine strain list
a = unique([s1;s2]);
strains = cell2table(a,'VariableNames',{'strain'});
% get strainlist info from MWTDB
M = load(fullfile(pDataBase,'MWTDB.mat'),'strain');
% get genotype matching strainlist
T = innerjoin(strains, M.strain,'RightVariables',{'genotype','mutation','backcross','references'});
% make table
T1 = split_genotype_info(T.genotype);
T = [T(:,{'genotype'}) T1(:,{'gene'}) T(:,{'strain','mutation','backcross','references'})];
% fill empty nformation 
T.gene(cellfun(@isempty,T.gene)) = {''};
% get orgtholog
load(fullfile(pDataBase,'MWTDB.mat'),'gene');
T = outerjoin(T,gene,'Key','gene','RightVariables',{'gene','ortholog'},'MergeKeys',1,'Type','left');
% reorganize sequence
T = T(:,{'ortholog','genotype','strain','mutation','backcross','references'});
% change unkonwn backcross from NaN to ?
a = num2cellstr(T.backcross);
T.backcross = regexprep(a,'NaN','?');


%% write table



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170718%

