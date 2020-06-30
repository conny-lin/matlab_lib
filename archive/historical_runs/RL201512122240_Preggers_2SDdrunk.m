%% run Dance_Glee_Preggers
pSaveHome = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp';
programName = 'Dance_Glee_Preggers';

analysisNLimit = 0;
exp_exclusion = {};
plate_exclusion = {'20120928_214158', '20150423_141445' '20130702_193557'};

%% add fun path
addpath('/Users/connylin/Dropbox/Code/Matlab/General');

%% run Preggers on not drunk sample 
% load included exp
str = sprintf('%s/Dance_Glee_Preggers 201512121701/mwt_summary included.csv',pSaveHome);
T = readtable(str);
% get mwt that's no drunk
str = sprintf('%s/Dance_DrunkMoves/curve comparison with N2.csv',pSaveHome);
T2 = readtable(str);
T2(~ismember(T2.cmp2N2,'same as N2'),:) = [];
i = ismember(T.mwtname,T2.mwtname) ...
    | (ismember(T.groupname,{'N2'}) & ~ismember(T.mwtname, plate_exclusion));

% confirm
m = T(i,:);
if sum(ismember(m.mwtname,plate_exclusion)) > 0; error('included bad plate'); end
pMWT = m.mwtpath;
% run
pSave = [pSaveHome,'/400mM curve not drunk'];
if isdir(pSave) == 0; mkdir(pSave); end
addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_Glee');
MWTSet = Dance_Glee_Preggers(pMWT,'pSave',pSave);


%% run Preggers on drunk sample 
% load included exp
str = sprintf('%s/Dance_Glee_Preggers 201512121701/mwt_summary included.csv',pSaveHome);
T = readtable(str);
% get mwt that's no drunk
str = sprintf('%s/Dance_DrunkMoves/curve comparison with N2.csv',pSaveHome);
T2 = readtable(str);
T2(ismember(T2.cmp2N2,'same as N2'),:) = [];
i = ismember(T.mwtname,T2.mwtname) ...
    | (ismember(T.groupname,{'N2'}) & ~ismember(T.mwtname, plate_exclusion));

% confirm
m = T(i,:);
if sum(ismember(m.mwtname,plate_exclusion)) > 0; error('included bad plate'); end
pMWT = m.mwtpath;
% run
pSave = [pSaveHome,'/400mM curve drunk'];
if isdir(pSave) == 0; mkdir(pSave); end
addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_Glee');
MWTSet = Dance_Glee_Preggers(pMWT,'pSave',pSave);
return


