%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% paths
pDataBase = '/Volumes/COBOLT/MWT';
pData = fullfile(fileparts(pM),'Data');

%% GET STRAIN INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170718%
% get group names
[fn,p] = dircontent(pData);
% minus archive code folder
p(regexpcellout(fn,'[_]')) = [];
% get gene names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
p = celltakeout(p);
% get strain names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
pstrains = celltakeout(p);
strainnames = celltakeout(fn);
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%


%% MAKE TABLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170718%
% get strain list from new data
s1 = dircontent(pDataOld);
% get strain list from old data
s2 = dircontent(pDataNew);
% combine strain list
a = unique([s1;s2]);
if isempty(a)
    movedataGo = false;
else
    movedataGo = true;

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
    T.ortholog(ismember(T.genotype,{'wildtype(hawaiian)'})) = {'neuropeptide Y receptor'};
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
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%




%% GET GRAPHS AND STATS REPORT FROM SUMMARY %%%%%%%%%%%%%%%%%%%%%%20170719%

% for each strain
for si = 1:numel(strainnames)
    % get strainfolder name
    sf = strainnames{si};
    % check if new is in the name
    newstatus = regexp(sf,'New');
    % get strain name
    s = regexprep(sf,' New','');
    if ~isempty(newstatus) % if new folder
        % get paths from new folder
        pGS = pGraphNew;
        % get paths to graphs
        pSS = pStatsNew;
    else % get paths from old folder
        % get paths from new folder
        pGS = pGraphOld;
        % get paths to graphs
        pSS = pStatsOld;
    end
    % make designation path
    pd = pstrains{si};
    % make paths to graphs
    ps = fullfile(pGS,sprintf('%s.pdf',s));
    if exist(ps,'file')
        % copy graph to strain folder
        movefile(ps,pd);
    end
    % make stats paths
    ps = fullfile(pSS,sprintf('%s stats writeup.txt',s));
    if exist(ps,'file')
        % copy stats to strain folder
        movefile(ps,pd);
    end
    % move data file if 
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%









