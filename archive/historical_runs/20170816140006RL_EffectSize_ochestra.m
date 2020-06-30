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


%% CURVE EFFECT SIZE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170816
for si = 1:numel(strainnames) % for each strain
    % loop information
    loopreporter(si,'strain',5,numel(strainnames)); % report loop
    strain = strainnames{si}; % strain name
    pDatafolder = pstrains{si}; % get pSave
    
    % get data
    pD = fullfile(pDatafolder,'Dance_InitialEtohSensitivityPct_v1707','data.mat'); % get data path
    load(pD,'MWTSet'); % load data
    
    % calculation 
    msrlist = fieldnames(MWTSet.Stats);
    for msri = 1:numel(msrlist)
        msr = msrlist{msri};
        D = MWTSet.Stats.(msr).pct_plate; % get relevant data
        x1 = D.mean(ismember(D.strain,'N2'));     % get x1 data
        x2 = D.mean(ismember(D.strain,strain));     % get x2 data
        d = effectsize_cohend(x1,x2);     % get effect size
        MWTSet.Stats.(msr).pct_effectsize = d; % store in MWTSEt
    end
    
    % save data
    save(pD,'MWTSet','-append'); % save updated data
        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170816


%% REV EFFECT SIZE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170816
% equation for calculation rmANOVA effect size:
%   eta2partial = SSconditions / (SSconditions + SSerror)
for si = 1:numel(strainnames) % for each strain
    % loop information
    loopreporter(si,'strain',1,numel(strainnames)); % report loop
    strain = strainnames{si}; % strain name
    pDatafolder = pstrains{si}; % get pSave
    
    % get data
    pD = fullfile(pDatafolder,'Dance_ShaneSpark_v1707','Dance_ShaneSpark_v1707.mat'); % get data path
    load(pD,'MWTSet'); % load data
    return
    % calculation 
    msrlist = fieldnames(MWTSet.Stats);
    for msri = 1:numel(msrlist)
        msr = msrlist{msri};
        D = MWTSet.Stats.(msr).Curve.rmanova; % get relevant data
        d = effectsize_rmanova(D,'strain:dose','tap');
        MWTSet.Stats.(msr).Curve.effectsize = d; % store in MWTSEt
    end

    save(pD,'MWTSet','-append'); % save updated data
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170816

%% ACC EFFECT SIZE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170816
%     Dance_rType2_v1707(pMWT,pSaveStrain);
for si = 1:numel(strainnames) % for each strain
    % loop information
    loopreporter(si,'strain',1,numel(strainnames)); % report loop
    strain = strainnames{si}; % strain name
    pDatafolder = pstrains{si}; % get pSave
    
    % get data
    pD = fullfile(pDatafolder,'Dance_rType2_v1707','data.mat'); % get data path
    load(pD,'MWTSet'); % load data
    % calculation 
    msrlist = fieldnames(MWTSet.Stats);
    for msri = 1:numel(msrlist)
        msr = msrlist{msri};
        if isfield(MWTSet.Stats.(msr),'rmanova')
            D = MWTSet.Stats.(msr).rmanova; % get relevant data
            d = effectsize_rmanova(D,'strain:dose','tap');
            MWTSet.Stats.(msr).effectsize = d; % store in MWTSEt
        end
    end
    save(pD,'MWTSet','-append'); % save updated data
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170816


%% FINISH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
fprintf(' END \n');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808



