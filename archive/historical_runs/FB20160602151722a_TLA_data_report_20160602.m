%% INITIALIZING
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false); 
pSave = fileparts(pM);


%% settings
addpath('/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Share Code');
pShare = '/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Shared data';
[Score_std, gTable] = import_TLA_commonvar(pShare); % import common variables


%% load data
[~,pf] = dircontent(pSave,'scores-export-*.csv');
Score = import_TLAscore(pf,pShare); % import
TLA_practiceTime(Score,pSave); % get practice time summary
Score = transform_pctScore(Score,Score_std); % mod Score


%% summarize pct improvement per day per domain
% W = TLA_domainPerformance(Score,gTable,pSave,'pct all');
W = TLA_domainPerformanceByWeek(Score,gTable,pSave,'pct by week all');


%% performance per class
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
        sn2 = sprintf('pct by week class%d pid%d',classu(classn),pidu(pii));
        Sindv = S(S.pid==pidu(pii),:);
        WInd = TLA_domainPerformanceByWeek(Sindv,gTable,pSave,sn2,'savefile','false');
    
        %% comparison with over all score, individual
        W1 = table;
        W1.week = WInd.week;
        W1.Individual = WInd.Overall;
        
        
        WX = outerjoin(WClass, W1, 'Key','week','MergeKey',1);
        
        return
        %%
        y = table2array(WX(:,2:3));        
        x = repmat(W.week,1,size(y,2));
        
        
        figure1 = figure('Visible','off');
        axes1 = axes('Parent',figure1);
        hold(axes1,'on');
        
        pt1 = plot(x,y,'LineWidth',3);
        dn = {'class','individual'};
        for gi = 1:size(y,2)
            pt1(gi).DisplayName = dn{gi};
        end
        xlabel('Week');
        ylabel('Percentile');
        box(axes1,'off');
        set(axes1,'XTick',1:size(y,1),'XTickLabel',num2cellstr(W.week))
        legend1 = legend(axes1,'show');
        set(legend1,'Location','eastoutside','EdgeColor','none');
        title(['Participant ', num2str(pidu(pii))]);
        printfig(sn2,pSave,'h',4,'w',5)
        
   
    end
    
end


%% performance individual per class report





















