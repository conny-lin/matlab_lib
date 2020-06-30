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
load(fullfile(pDataBase,'MWTDB.mat'),'strain');
% get genotype matching strainlist
T = innerjoin(strains, strain,'RightVariables',{'genotype','mutation'});
% make table
T1 = split_genotype_info(T.genotype);
T = [T(:,{'genotype'}) T1(:,{'gene'}) T(:,{'strain','mutation'})];
% fill empty nformation 
T.gene(cellfun(@isempty,T.gene)) = {''};
% get orgtholog
load(fullfile(pDataBase,'MWTDB.mat'),'gene');
T = outerjoin(T,gene,'Key','gene','RightVariables',{'gene','ortholog'},'MergeKeys',1,'Type','left');
% reorganize sequence
T = T(:,{'ortholog','genotype','gene','strain','mutation'});
% change unkonwn backcross from NaN to ?
clear a T1 s1 s2

% add in missin info manually
T.ortholog(ismember(T.genotype,{'egl-2(rg4);him-5(e1490)V'})) = {'VGK channel'};
T.ortholog(ismember(T.genotype,{'pha-1(e2123);nlg-1(ok259)'})) = {'neuropeptide Y receptor'};
T.ortholog(ismember(T.genotype,{'Ex383[Pmyo-2::mcherry]'})) = {'BK channel'};
slo1rescue = {'JPS383','BZ416','JPS326','JPS328','JPS338','JPS344','JPS345','VG202','VG254','VG301','VG302'};
T.gene(ismember(T.strain,slo1rescue)) = {'slo-1 rescue'};
T.gene(ismember(T.genotype,{'egl-2(rg4);him-5(e1490)V'})) = {'egl-2'};
T.gene(ismember(T.genotype,{'pha-1(e2123);nlg-1(ok259)'})) = {'nlg-1 rescue'};
T.gene(ismember(T.genotype,{'wildtype(hawaiian)'})) = {'npr-1'};
T.genotype(ismember(T.genotype,{'wildtype(hawaiian)'})) = {'npr-1(g320)'};

% assign group
group = {'AMPA-like glutamate receptor','AMPA';
'BK channel','BK';
'D1 dopamine receptor','Dopamine';
'DGK','G-DGK';
'GEF','GEF';
'Gai','GCPR';
'Gaq','GCPR';
'Gas','GCPR';
'H3K4 HMT','HMT';
'N/A','Misc';
'PDE','G-PDE';
'PKA regulator','G-PKA';
'PKC','G-PKC';
'PLC','G-PLC';
'PTCHD3','Synaptic';
'Prox1','TF';
'RGS','G-RGS';
'UNC-13','Synaptic';
'VGK channel','VGK';
'adenylyl cyclase','G-AC';
'calcineurin B','G-Cnb';
'miR1','neuroligin';
'neurexin','neuroligin';
'neuroligin','neuroligin';
'neuropeptide Y','NPY';
'neuropeptide Y receptor','NPY';
'tomosyn','Tomosyn';
'tyrosine hydroxylase','Dopamine'};
A = cell2table(group,'VariableNames',{'ortholog','group'});
T = outerjoin(T,A,'MergeKey',1,'Type','left');

T = sortrows(T,{'gene'});

%% MOVE DATA
% get strain list from new data
[s1,sp1] = dircontent(pDataOld);
% get strain list from old data
[s2,sp2] = dircontent(pDataNew);
% get groups
groupsU = unique(T.group);
 
% create folder by gene name
genenameU = unique(T.gene);
for oi = 1:numel(genenameU)
    genename = genenameU{oi};
    T1 = T(ismember(T.gene,genename),:);
    % get list of strains
    strainsU = T1.strain(ismember(T1.gene,genename));
    groupname = unique(T1.group);
    if numel(unique(groupname))==1
        groupname = char(groupname);
        for si = 1:numel(strainsU)
            s = strainsU{si};
            % find in old data
            olddata = sp1(ismember(s1,s));
            if ~isempty(olddata)
                % create strain and genotype folder (i.e. slo-1(eg142) JPS326 LOF
                pd = create_savefolder(pM,fullfile(groupname,genename,s));
                psd = char(olddata);
                [~,psc] = dircontent(psd);
                if ~isempty(psc)
                    cellfun(@movefile,psc,cellfunexpr(psc,pd),cellfunexpr(psc,'f'));
                end
            end
            % find in new data
            newdata = sp2(ismember(s2,s));
            if ~isempty(newdata)
                % create strain and genotype folder (i.e. slo-1(eg142) JPS326 LOF
                pd = create_savefolder(pM,fullfile(groupname,genename,[s,' New']));
                psd = char(newdata);
                [~,psc] = dircontent(psd);
                if ~isempty(psc)
                    cellfun(@movefile,psc,cellfunexpr(psc,pd),cellfunexpr(psc,'f'));
                end
            end
            rmdir(psd,'s')

        end
        
    end
end





























%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170718%














