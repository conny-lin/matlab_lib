%% run Dance_Glee_Preggers
pSaveHome = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp';
programName = 'Dance_Glee_Preggers';
% add fun path
addpath('/Users/connylin/Dropbox/Code/Matlab/General');

analysisNLimit = 0;
exp_exclusion = {};
plate_exclusion = {'20120928_214158', '20150423_141445' '20130702_193557','20121002_222345',...
    '20121125_162155','20130702_193557','20130528_215019','20130528_215750','20130709_123523'};

%% get plate validation file
cd(pSaveHome)
[~, ~, A] = xlsread(sprintf('%s/mwt_summary included.xlsx',pSaveHome),...
    'mwt_summary included.csv');
A = A(2:end,:);
A(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),A)) = {''};
A = cell2table(A,'VariableNames',{'mwtpath','expname','groupname','mwtname','issues','drunk_status','decision','curve_status','note'});
i = ~ismember(A.curve_status,'same as N2') ...
    & ~ismember(A.issues,{'fuzzy looks like 400mM worms','mostly small worms','looks like drunk worm','wet plate','wet plate suspect to be 400mM','worms clump and too small','worms clumping maybe is npr-1 check','uneven light wet plate','some clumping and is npr1 exp'});
mwtInclude = A.mwtpath(i);
mwtExclude = A.mwtpath(~i);

%% run Preggers for excluded files
pMWT = mwtExclude;
outputsuffix = 'Excluded';
% run
pSave = pSaveHome;
if isdir(pSave) == 0; mkdir(pSave); end
addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_Glee');
MWTSet = Dance_Glee_Preggers(pMWT,'pSave',pSave,'outputsuffix',outputsuffix,'saveimport',0);

%% run Preggers for included files
pMWT = mwtInclude;
outputsuffix = 'Include';
% run
pSave = pSaveHome;
if isdir(pSave) == 0; mkdir(pSave); end
addpath('/Users/connylin/Dropbox/RL/Code/Modules/Dance/Dance_Glee');
MWTSet = Dance_Glee_Preggers(pMWT,'pSave',pSave,'outputsuffix',outputsuffix,'saveimport',0);



