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
Score = import_TLAscore(pf,pShare);
% import file
[Score_std, gTable] = import_TLA_commonvar(pShare);
TLA_practiceTime(Score,pSave)
% mod Score
Score = transform_pctScore(Score,Score_std);


%% summarize pct improvement per day per domain
% W = TLA_domainPerformance(Score,gTable,pSave,'pct all');
W = TLA_domainPerformanceByWeek(Score,gTable,pSave,'pct by week all');


%% performance per class
classu = unique(Score.class);
for classn = 1:numel(classu)
    S = Score(Score.class==classu(classn),:);
    savename = sprintf('pct by week class%d',classu(classn));
    W = TLA_domainPerformanceByWeek(Score,gTable,pSave,savename);
    
    
    % plot    
    a = regexpcellout(W.week,'/','split');
    
    xname= W.week;
    
    TLA_plot_domainByWeek(W,pSave,savename)
    
    
end


%% performance individual per class report






















