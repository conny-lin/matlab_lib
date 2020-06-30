%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODE UPDATE:
% - incoporate new practice duration code
% - clean up shared modules
% - add auto moving files from download folder to cohort folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++++++++++++++++++++++++
pCohortFolder = fileparts(pM);
pProj = fileparts(pCohortFolder);
pDownload = '/Users/connylin/Dropbox/TEMP';
pShare = fullfile(pProj,'Shared data');
% add shared code
addpath(fullfile(pProj,'Share Code'));
% -------------------------------------------

% Get downloaded data name from download folder ++++++++++++++++++++++++++
% Get data name
fn = dircontent(pDownload,'scores-export-*-emails.csv');
a = regexprep(fn,'scores-export-','');
a = regexprep(a,'-emails.csv','');
a = celltakeout(regexp(a,'-','split'));
a(end) = [];
a(1:3) = [];
a = strjoin(a,'');
% set up export folder
pSave = create_savefolder(fullfile(pCohortFolder,a));
% move raw data to export folder
p1 = char(fullfile(pDownload,fn));
p2 = char(fullfile(pSave,fn));
copyfile(p1,p2,'f')
% -------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% import shared variables +++++++++++++++++++++++++++++
[Score_std, gTable] = import_TLA_commonvar(pShare); % import common variables
% ------------------------------------------------------

% load score data ++++++++++++++++++++++++++++++++++++++++
[~,pf] = dircontent(pSave,'scores-export-*.csv');
Score = import_TLAscore2(pf,[20116 10 3]); % import
% --------------------------------

% join class ++++++++++++++++++++++++++
p = fullfile(pShare,'Participant info.mat');
load(p,'Class');
ClassInfo = Class; clearvars Class
% exclude none current data
e1 = unique(Score.email);
e2 = ClassInfo.email;
ClassInfo(~ismember(e2,e1),:) = [];
Score = outerjoin(Score,ClassInfo(:,{'email','class'}),'Key',{'email'},'MergeKeys',1);
% ------------------------

% get practice time ++++++++++++++
TLA_practiceTime(Score,pSave); % get practice time summary
Score = transform_pctScore(Score,Score_std); % mod Score
% -------------------------------


% summarize play time per week +++++++++
% W = TLA_domainPerformance(Score,gTable,pSave,'pct all');
% W = TLA_domainPerformanceByWeek(Score,gTable,pSave,'pct by week all');
% --------------------------------------



%% summarize pct improvement per day per domain ++++++++++++++++++++++++
% performance per class
classu = unique(Score.class);
for classn = 1:numel(classu)
    
    S = Score(Score.class==classu(classn),:);
    savename = sprintf('pct by week class%d',classu(classn));
    W = TLA_domainPerformanceByWeek(S,gTable,pSave,savename);
    TLA_plot_domainByWeek(W,pSave,savename);
    
    %% individuals
    WClass = table;
    WClass.week = W.week;
    WClass.Class = W.Overall;
    
    pidu = unique(S.pid);
    for pii = 1:numel(pidu)
        % save name
        sn2 = sprintf('pct by week class%d pid%d',classu(classn),pidu(pii));
        % get individual data
        Sindv = S(S.pid==pidu(pii),:);
        WInd = TLA_domainPerformanceByWeek(Sindv,gTable,pSave,sn2,'savefile','false');
        %% plot domain per individual
        TLA_plot_domainByWeek(WInd,pSave,[sn2,' by domain']);

        %% comparison with over all score, individual
        W1 = table;
        W1.week = WInd.week;
        W1.(['Participant_', num2str(pidu(pii))]) = WInd.Overall;
        WX = outerjoin(WClass, W1, 'Key','week','MergeKey',1);
        TLA_plot_overallscore_comp2(WX,pSave,[sn2,' overall']);     
   
    end
    
end
% ------------------------------------------------------------------------

%% run practice time +++++++++++++++++++++++++++++++++++++++++++++++++++++
dailyPracticeTime(Score,pSave)
% ------------------------------------------------------------------------


%% done +++++++++++++++++
fprintf('done\n');
% ----------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%















