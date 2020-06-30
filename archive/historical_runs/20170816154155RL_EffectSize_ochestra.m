% -------------------------------------------------------------------------
%                       OBJECTIVE | 20170815
% -------------------------------------------------------------------------
% updated rtype stats output ready for results summary table thus needs
% rerun
% -------------------------------------------------------------------------
%                           INITIALIZING 
% -------------------------------------------------------------------------
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false); 
% -------------------------------------------------------------------------
% OVERALL VARIABLES | 20170808
% -------------------------------------------------------------------------
pDataBase = '/Volumes/COBOLT/MWT';
pData = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Tbl2 genetic screen result summary/Data_by_ortholog/Data';
% -------------------------------------------------------------------------
% GET STRAIN INFO FROM CURRENT DATA | 20170808
% -------------------------------------------------------------------------
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
% -------------------------------------------------------------------------
%                           EFFECT SIZE | 20170816
% -------------------------------------------------------------------------
% CURVE EFFECT SIZE | 20170816
% -------------------------------------------------------------------------
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
% -------------------------------------------------------------------------
% REV EFFECT SIZE | 20170816
% -------------------------------------------------------------------------
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
    
    % calculation 
    msrlist = fieldnames(MWTSet.Stats);
    for msri = 1:numel(msrlist)
        msr = msrlist{msri};
        D = MWTSet.Stats.(msr).Curve.rmanova; % get relevant data
        d = effectsize_rmanova(D,'strain:dose','tap');
        MWTSet.Stats.(msr).Curve.effectsize = d; % store in MWTSEt
    end

    % by strain
    for msri = 1:numel(msrlist)
        msr = msrlist{msri}; % get measure name
        % prepare data 
        M = MWTSet.MWTDB;
        Data = MWTSet.Raw;
        A = innerjoin(Data, M(:,{'mwtid','groupname','strain','rx'}));
        factors = {};
        if numel(unique(A.strain))>1
            factors = {'strain'};
        end
        if any(regexpcellout(A.rx,'mM'))
            A.rx(regexpcellout(A.rx,'NA')) = {'0mM'};
            A.dose = regexpcellout(A.rx,'\d{1,}(?=mM)','match');
            factors = [factors {'dose'}];
        end
        if isempty(factors)
            factors = {'groupname'};
        end
        D = A;

        strainu =unique(D.strain);    % get strain names
        for si = 1:numel(strainu)
            s = strainu{si};
            DStrain = D(ismember(D.strain,s),:);
            [textout,ANOVAS] = anovarm_std(DStrain,'tap',{'dose'},'mwtid',msr); % anova
            ANOVAS.effectsize = effectsize_rmanova(ANOVAS.rmanova,'dose','tap'); % effect size
            MWTSet.Stats.(msr).Curve_by_strain.(s) = ANOVAS; % store in MWTSet
        end
    end
    
    save(pD,'MWTSet','-append'); % save updated data
end
% -------------------------------------------------------------------------
% ACC EFFECT SIZE | 20170816
% -------------------------------------------------------------------------
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
    
    % by strain
    for msri = 1:numel(msrlist)
        msr = msrlist{msri}; % get measure name
        % prepare data 
        D = MWTSet.Raw;
        strainu =unique(D.strain); % get strain names
        for x = 1:numel(strainu)
            s = strainu{x};
            DStrain = D(ismember(D.strain,s),:);
            [textout,ANOVAS] = anovarm_std(DStrain,'tap',{'dose'},'mwtpath',msr); % anova
            MWTSet.Stats_bystrain.(msr).(s) = ANOVAS; % store in MWTSet
        end
    end
    
    save(pD,'MWTSet','-append'); % save updated data
end
% -------------------------------------------------------------------------
%                       FINISH | 20170808
% -------------------------------------------------------------------------
fprintf(' END \n');
return
% -------------------------------------------------------------------------



