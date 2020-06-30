%% INITIALIZING
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false); 
pSave = fileparts(pM);


%% settings
addpath('/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Share Code');
pShare = '/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Shared data';

%% load data
[~,pf] = dircontent(pSave,'scores-export-*.csv');
Score = import_TLAscore(pf);
% import file
[Score_std, gTable] = import_TLA_commonvar(pShare);
TLA_practiceTime(Score,pSave)

% mod Score
Score = transform_pctScore(Score,Score_std);

%% summarize pct improvement per day per domain
TLA_domainPerformance(Score,gTable,pSave)






















