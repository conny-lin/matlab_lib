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
% summarize pct improvement per day per domain
W = TLA_domainPerformance(Score,gTable,pSave,'pct all');

%% performance per class
classu = unique(Score.class);
for classn = 1:numel(classu)
    S = Score(Score.class==classu(classn),:);
    savename = sprintf('pct class%d',classu(classn));
    W1 = TLA_domainPerformance(S,gTable,pSave,savename);
    
    
    %% plot
    xname = W1.playdate;
    
    a = regexpcellout(xname,'/','split');
    xname= a(:,2);
    
    %%
    fn = fieldnames(W1);
    fn(ismember(fn,{'playdate','Properties'})) = [];
    y = table2array(W1(:,fn));
    x = repmat((1:numel(xname))',1,numel(fn));
    
    color= [[0.501960813999176 0.501960813999176 0.501960813999176];
        [1 0.843137264251709 0];
        [0 0 1];
        [1 0 0];
        [0 0.498039215803146 0];
        [0.494117647409439 0.184313729405403 0.556862771511078]];
    
    % Create figure
    figure1 = figure;

    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');

    % Create multiple lines using matrix input to plot
    plot1 = plot(x,y,'Parent',axes1);
    for gi = 1:size(y,2)
        set(plot1(gi),'DisplayName',fn{gi},'Color',color(gi,:));
    end
    xlabel('date');
    ylabel('percentile');
    box(axes1,'off');
    % Set the remaining axes properties
    set(axes1,'XTick',1:numel(xname),'XTickLabel',xname);
    % Create legend
    legend1 = legend(axes1,'show');
    set(legend1,'Location','eastoutside','EdgeColor',[1 1 1]);


    
    %%
    printfig('test',pSave,'h',5,'w',7);
    
    return
end


%% performance individual per class report























