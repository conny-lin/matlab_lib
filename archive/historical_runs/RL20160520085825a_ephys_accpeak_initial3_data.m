%% run tap 1, 2, 3 data and plot on the same graph

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);


%% SETTING
ISI = 10; preplate = 100;
assaytimePretap = 1;
assaytimePosttap = 8;
assayTapNumber = 1;
assaytimes = [(assayTapNumber-1)*ISI+preplate-assaytimePretap;...
    (assayTapNumber-1)*ISI+preplate+assaytimePosttap];

legend_gangnam = load('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Chor_output_handling/legend_gangnam.mat');
legend_gangnam = legend_gangnam.legend_gangnam;
msrInterest = {'time','id','bias','speed','tap','midline'};

%% get strain names
pDataHome = '/Users/connylin/Dropbox/RL/PubInPrep/PhD Dissertation/4-STH genes/Data/10sIS by strains';
a = dircontent(pDataHome);
a(ismember(a,'0-Code')) = [];
strainlist  = a;
strainlist(~ismember(strainlist,{'VG202','VG302'})) = [];


%% MWTDB - get all paths
MWTDB = load('/Volumes/COBOLT/MWT/MWTDB.mat');
MWTDBMaster = MWTDB.MWTDB.text; clear MWTDB;

    
%% run data for all strains

for si = 1:numel(strainlist)
    %% create save folder
    strain = strainlist{si};
    pSaveA = sprintf('%s/%s',pDataHome,strain);
    fprintf('%d/%d: %s **********\n',si,numel(strainlist),strain);
    
    i = MWTDBMaster.ISI == 10 ...
        & MWTDBMaster.preplate == preplate ...
        & MWTDBMaster.tapN == 30 ...
        & ismember(MWTDBMaster.groupname,sprintf('%s_400mM',strain));
    exp = unique(MWTDBMaster.expname(i));

    MWTDB = MWTDBMaster(ismember(MWTDBMaster.expname,exp),:);
    MWTDB(~ismember(MWTDB.groupname,{'N2','N2_400mM',strain,[strain,'_400mM']}),:) = [];
    pMWT = MWTDB.mwtpath;
    
    %% patch for VG202 withtout N2
    if sum(ismember(strainame,{'VG202','VG302'}))==1
        i = ismember(MWTDBMaster.expter,'DH') ...
            & ismember(MWTDBMaster.groupname,{'N2','N2_400mM'});
        pMWTpatch = MWTDBMaster.mwtpath(i);
        pMWT = [pMWT;pMWTpatch];
        MWTDB = parseMWTinfo(pMWT);
    end
    
    gu = unique(MWTDB.groupname);

    %% run data   
    pSaveA = sprintf('%s/ephys graph',pSaveA); if ~isdir(pSaveA); mkdir(pSaveA); end

    [Data,MWTDB] = ephys_extractData(pMWT,assaytimes,ISI,preplate,assayTapNumber);
    DataG = ephys_tranformData2struct(Data,gu);
    % save
    cd(pSaveA); 
    save(sprintf('data_ephys_t%d.mat',assayTapNumber),'Data','gu','MWTDB','DataG');

    %% export as excel file
    for gi = 1:size(DataG,2)
       x = DataG(gi).time(1,:);
       n = sum(~isnan(DataG(gi).speedb));
       n = n-1;
       n(n<1) = 0;
       y = nanmean(DataG(gi).speedb);
       e = (nanstd(DataG(gi).speedb)./sqrt(n)).*2;
       y1 = nanmean(DataG(gi).speedbm);
       e1 = (nanstd(DataG(gi).speedbm)./sqrt(n)).*2;
       A = [n' x' y' e' y1' e1'];
       A = array2table(A,'VariableNames',{'N','time','speedb','speedb_2SE','speedbm','speedbm_2SE'});
       savename = sprintf('ephys %s t%d.csv',char(DataG(gi).name),assayTapNumber);
       cd(pSaveA); writetable(A,savename);
    end
    
    %% load data
    [Stats, DataG] = ephys_stats(DataG,pSaveA);
    StatT = ephys_randomSample(DataG,pSaveA);
    
    %% graph
    ephys_graphline(DataG,pSaveA,assayTapNumber,assayTapNumber,strain)
    
end




fprintf('DONE\n');

beep
beep
beep

    
    
    
    
    
    
    
    
    
    
    
    