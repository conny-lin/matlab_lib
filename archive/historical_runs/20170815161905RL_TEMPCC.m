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
pMWTStrains = cell(size(pstrains));
for si = 1:numel(strainnames) % for each strain
    % report loop
    loopreporter(si,'strain',1,numel(strainnames));
    strain = strainnames{si}; % strain name
    % get pSave
    pSaveStrain = pstrains{si};
    % get pMWT ----------
    % search database
    [~,DB]  = search_MWTDB('groupname',[strain,'_400mM'],'rc','100s30x10s10s');
    e = unique(DB.expname); % get target exp
    % search database
    [pMWT,MWTDB]  = search_MWTDB('expname',e,'groupname',{'N2','N2_400mM',strain,[strain,'_400mM']},'rc','100s30x10s10s');
    
    %% Patch for exp does not have N2 as control
    if ~any(ismember(MWTDB.groupname,{'N2'})) % check if have N2
        % select nearby N2
        [pMWTe,DBe]  = search_MWTDB('groupname',{'N2','N2_400mM'},'rc','100s30x10s10s');
        ed1 = max(MWTDB.exp_date)+ 3;
        DBe.date_diff = abs(DBe.exp_date - ed1);
        DBe = DBe(:,{'date_diff','expname'});
        eu = unique(DBe,'rows');
        DBe = sortrows(DBe,{'date_diff'});
        n2num = 0;
        mutnum = sum(ismember(MWTDB.groupname,strain));
        en = numel(e);
        while n2num < mutnum
            eothers = DBe.expname(1:en);
            e2 = [eothers; e];
            [pMWT,MWTDB]  = search_MWTDB('expname',e2,'groupname',{'N2','N2_400mM',strain,[strain,'_400mM']},'rc','100s30x10s10s');
            n2num = sum(ismember(MWTDB.groupname,'N2'));
            en = en + 1;
        end
    end
    % get rid of zips
    pMWT(regexpcellout(pMWT,'zip')) = [];
    % save
    pMWTStrains{si} = pMWT;
 

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808


%% 

for si = 1:numel(pMWTStrains) % for each strain
    pSave = pstrains{si};
    strain = strainnames{si};
    OcA = Ochestra_Alcohol3Factor_v1708(pMWTStrains{si},pSave,'strain',strain,'overwrite',false);
    return
end



