%% run Dance_Glee_Preggers
% pSaveHome = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/Recovery/Groups';
pSaveHome = fileparts(fileparts(mfilename('fullpath')));
programName = 'Dance_Glee_Preggers';

analysisNLimit = 0;
exp_exclusion = {};
plate_exclusion = {};

%% add fun path
addpath('/Users/connylin/Dropbox/Code/Matlab/General');


%% run Dance  
% get save path
pSave = pSaveHome;
rc = '100s30x10s10s';

%% get database
pData = '/Volumes/COBOLT/MWT';
addpath('/Users/connylin/Dropbox/RL/Code/Modules/MWTDatabase');
D = load([pData,'/MWTDatabase.mat']);
Db = D.MWTDatabase.mwt;

%% query database
i = ismember(Db.expname,Db.expname(ismember(Db.groupname,{'N2_400mM'}))) &... % experiment must have N2_400mM group
    ismember(Db.groupname,{'N2','N2_400mM'}) & ... % groups
    Db.exp_date > 20120120 &... % after liquid transfer exp
    ismember(Db.rc,rc);
DbT = Db(i,:);
pMWT = DbT.mwtpath;
% create summary table
t = expsummaryTable(pMWT,'savetable',1,'pSave',pSave,'suffix','all experiments');

%% remove known bad files
% get MWTDB_Note for bad experiments
% a = readtable_MWTDB_Note(pData);
i = ismember(DbT.expname,exp_exclusion) | ...
    ismember(DbT.mwt,plate_exclusion);
if sum(i) > 1
    pMWT = DbT.mwtpath(i);
    % create summary table
    t = expsummaryTable(pMWT,'savetable',1,'pSave',pSave,'suffix','remove bad exp');
    DbT(i,:) = [];
end

%% run
addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_Glee');
MWTSet = Dance_Glee_Preggers(pMWT,'pSave',pSave);


return


