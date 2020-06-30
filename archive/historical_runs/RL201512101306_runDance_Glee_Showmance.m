%% setting
pData = '/Volumes/COBOLT/MWT';
pSaveHome = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp';
analysisNLimit = 30;
% query database
D = load([pData,'/MWTDatabase.mat']);
MWTDB = D.MWTDatabase;
% get targets
Db = MWTDB.mwt;

% get only 
i = ismember(Db.groupname,{'N2','N2_400mM'}) & ... % groups
    Db.exp_date > 20120120 &... % after liquid transfer exp
    ismember(Db.rc,'100s30x10s10s') ... %10sISI
    ;
DbT = Db(i,:);
pMWT = DbT.mwtpath;


% run Dance_Glee_Showmance
addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_Glee');
MWTSet = Dance_Glee_Showmance(pMWT,'pSave',pSaveHome,'analysisNLimit',analysisNLimit);


% report N found
T = parseMWTinfo(DbT.mwtpath);
numel(ismember(T.groupname,'N2'))
fprintf('\nFound: Exp = %d, N2(plate) = %d, N2_400mM(plate) = %d\n', ...
numel(unique(T.expname)),...
sum(ismember(T.groupname,'N2')),...
sum(ismember(T.groupname,'N2_400mM')));

% report N analyzed
addpath('/Users/connylin/Dropbox/RL/Code/Modules/MWTDatabase');
p = MWTSet.Data.Raw.pMWT;
T = parseMWTinfo(p);
fprintf('\nAnalyzed: Exp = %d, N2(plate) = %d, N2_400mM(plate) = %d\n', ...
    numel(unique(T.expname)),...
    sum(ismember(T.groupname,'N2')),...
    sum(ismember(T.groupname,'N2_400mM')));
