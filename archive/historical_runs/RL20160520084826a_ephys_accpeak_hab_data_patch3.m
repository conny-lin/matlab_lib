%% patching VC223 run mistakes (included N2_test group)

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);


%% SETTING
ISI = 10; preplate = 100;
assaytimePretap = 1;
assaytimePosttap = 8;
assayTapNumber = 28:30;
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


%% run chor
% %% make sure each strain has a 400mM companion 
% gu = unique(MWTDB.groupname);
% a = regexpcellout(gu,'_','split');
% dose = a(:,2);
% strain = a(:,1);
% dose(cellfun(@isempty,dose)) = {''};
% strain4 = strain(ismember(dose,'400mM'));
% strain0 = strain(~ismember(dose,'400mM'));
% i = ismember(strain0,strain4);
% if sum(~i)~=0; error('some strains do not have 400mM group'); end


% %% CHOR
% check if gangnam exist
% pMWT = MWTDB.mwtpath; 
% [pSPS,pMWTsuc,pMWTfail] = getpath2chorfile(pMWT,'Gangnam.mat','reporting',1);
% run chor on those do not have gangnam
% [Legend,pMWTpass,pMWTfailed] = chormaster5('Gangnam',pMWTfail);
% [pFiles,pMWTval] = convertchorNall2mat(pMWTpass,'gangnam','Gangnam');
% recheck 
% pMWT = MWTDB.mwtpath; 
% [pSPS,pMWTsuc,pMWTfail] = getpath2chorfile(pMWT,'Gangnam.mat','reporting',1);
% MWTDBMaster = parseMWTinfo(pMWTsuc);

%% MWTDB - get all paths
MWTDB = load('/Volumes/COBOLT/MWT/MWTDB.mat');
MWTDBMaster = MWTDB.MWTDB.text; clear MWTDB;

    
%% run data for all strains


for si = 1:numel(strainlist)
    %% create save folder
    strainame = strainlist{si};
    pSaveA = sprintf('%s/%s',pDataHome,strainame);
    fprintf('%d/%d: %s **********\n',si,numel(strainlist),strainame);
    
    i = MWTDBMaster.ISI == 10 ...
        & MWTDBMaster.preplate == preplate ...
        & MWTDBMaster.tapN == 30 ...
        & ismember(MWTDBMaster.groupname,sprintf('%s_400mM',strainame));
    exp = unique(MWTDBMaster.expname(i));

    MWTDB = MWTDBMaster(ismember(MWTDBMaster.expname,exp),:);
    MWTDB(~ismember(MWTDB.groupname,{'N2','N2_400mM',strainame,[strainame,'_400mM']}),:) = [];
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
    [Data,MWTDB] = ephys_extractData(pMWT,assaytimes,ISI,preplate,assayTapNumber);
    DataG = ephys_tranformData2struct(Data,gu);
    % save
    cd(pSaveA); 
    save(sprintf('data_ephys_t28_30.mat'),'Data','gu','MWTDB','DataG');

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
       cd(pSaveA)
       writetable(A,sprintf('%s.csv',char(DataG(gi).name)))
    end
    
    %% load data
    pSaveA = sprintf('%s/ephys graph',pSaveA); if ~isdir(pSaveA); mkdir(pSaveA); end
    [Stats, DataG] = ephys_stats(DataG,pSaveA);
    StatT = ephys_randomSample(DataG,pSaveA);
    
    %% graph    %% graph
    ephys_graphline(DataG,pSaveA,assayTapNumber(1),assayTapNumber(end),strainame)
    
end




fprintf('DONE\n');

beep
beep
beep

    
    
    
    
    
    
    
    
    
    
    
    