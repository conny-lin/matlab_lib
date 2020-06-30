%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datapath = fileparts(pM);
addpath(fullfile(datapath,'Function'));
pResultHome = pM;
pData = fullfile(fileparts(pM), 'FakeNews 1.1.xlsx');
% datapath = '/Users/connylin/Dropbox/CA/Neuropolitics Reiner Owen/Data Exp 1';

%% IMPORT DATA
Data = import_data_1_1(pData);

%% CLEAN
fprintf('original data number: %d rows\n',size(Data,1));
% remove incomplete data
issueName = 'incomplete status';
i = ismember(Data.Status,'Incomplete');
Data = data_clean(issueName, i, Data);

% remove data heard of the media source
issueName = 'heard of media source';
i = Data.BT ==1;
Data = data_clean(issueName, i, Data);

% remove data heard of the media source
issueName = 'heard of the story';
i = Data.Gregor ==1;
Data = data_clean(issueName, i, Data);

%% ASSIGN GROUPS
% obtain groups info
T = Data.ProceedT;
Tc = Data.ProceedTtext;
T1 = Data.ProceedT1;
T1c = Data.ProceedT1text;

H = Data.ProceedH;
Hc = Data.ProceedHtext;
H1 = Data.ProceedH1;
H1c = Data.ProceedH1text;

% check if any overlap
A = [T T1 H H1];
if any(sum(isnan(A),2) < 3)
    error('duplicate stories entry');
end

% remove data with unkonwn group
issueName = 'unknown group';
i = sum(isnan(A),2) == 4;
Data = data_clean(issueName, i, Data);


% split data into groups
Data.Story = repmat({'2'},size(Data,1),1);
Data.Story(~isnan(Data.ProceedT)) = {'3'};
Data.Story(~isnan(Data.ProceedH1)) = {'3'};
% assign VideoOrText
Data.VideoOrText = repmat({''},size(Data,1),1);
Data.VideoOrText(~isnan(Data.ProceedT)) = {'Video'};
Data.VideoOrText(~isnan(Data.ProceedT1)) = {'Text'};
Data.VideoOrText(~isnan(Data.ProceedH)) = {'Video'};
Data.VideoOrText(~isnan(Data.ProceedH1)) = {'Text'};


%% Save as data master
DataMaster = Data;
Data = [];
Stories = unique(Data.Story);
for storyi = 1:numel(Stories)
    Data = DataMaster(ismember(DataMaster.Story,Stories(storyi)),:);
    
    pResult = create_savefolder(pResultHome,Stories{storyi});
    
    %% ANALYSIS #1: plausible VS Video or Text
    % anova
    yvarname = 'Plausible';
    Y = Data.(yvarname); 
    xvarname = 'VideoOrText';
    X = Data.(xvarname); 
    prefix = sprintf('%s vs %s', yvarname, xvarname);
    [text,T,p,s,t,ST] = anova1_autoresults(Y,X);
    T = sortrows(T,{'gnames'},{'descend'});
    writetable(ST,fullfile(pResult,[prefix,' anova.csv']),'WriteRowNames',1);
    writetable(T,fullfile(pResult,[prefix,' descriptive.csv']));
    % bar graph
    h = barwitherr(T.SE, T.mean);
    set(h(1),'FaceColor',[0.5 0.5 0.5]);
    set(gca,'XTickLabel',T.gnames);
    ylabel(yvarname);
    xlim([0.5 numel(T.mean)+0.5])
    ylim([0 100])
    printfig(prefix,pResult,'h',3,'w',numel(T.mean));


    %% ANALYSIS #2: plausible VS Video or Text by 3rd factor
    YfactorNames = {'Plausible'};
    XfactorNames = {'VideoOrText'};
    GfactorNames = {'Voting1','sex1','Media1'};

    for xi = 1:numel(XfactorNames)
    for yi =1:numel(YfactorNames)
    for gi = 1:numel(GfactorNames)
        % get variable names
        XfactorNameNow = XfactorNames{xi};
        YfactorNameNow = YfactorNames{yi};
        GfactorNameNow = GfactorNames{gi};
        % get data
        Y = Data.(YfactorNameNow); 
        yvarname = YfactorNameNow;
        X = {Data.(XfactorNameNow),Data.(GfactorNameNow)}; 
        xvarname = {XfactorNameNow,GfactorNameNow};
        % anova
        [T,prefix] = anova_multifactor(X,xvarname,Y,yvarname,pResult);
        % bar
        make_bar_graph(T,yvarname,pResult,prefix);
    end
    end
    end


    %% ANALYSIS #3: scatter plausible VS verify/age, videotext
    var = {};
    rt = [];
    pt = [];

    XfactorNames = {'Plausible'};
    YfactorNames = {'Verify','Age'};
    GfactorNames = {'VideoOrText'};
    for xi = 1:numel(XfactorNames)
    for yi =1:numel(YfactorNames)
    for gi = 1:numel(GfactorNames)
        % get variable names
        XfactorNameNow = XfactorNames{xi};
        YfactorNameNow = YfactorNames{yi};
        GfactorNameNow = GfactorNames{gi};
        % plaus vs verify
        X = Data.(XfactorNameNow); xvarname = XfactorNameNow;
        Y = Data.(YfactorNameNow); yvarname = YfactorNameNow;
        G = Data.(GfactorNameNow); gvarname = GfactorNameNow;
        % scatter plot
        [r,p,name] = scatter_2factor(X,xvarname,Y,yvarname,pResult);
        % enter into table
        var(end+1) = {name};    rt(end+1) = r;  pt(end+1) = p;
        % scatter plot by group
        scatter_by_group(X,xvarname,Y,yvarname,G,gvarname,pResult);

        % get y sub names
        GsubVarNames = unique(G);
        for subvari = 1:numel(GsubVarNames)
            % sub var
            subGvar = GsubVarNames{subvari};
            [r,p,name] = corr_by_sub_ans(X,xvarname,Y,yvarname,G,subGvar);
            % enter into table
            var(end+1) = {name};    rt(end+1) = r;  pt(end+1) = p;
        end
    end
    end
    end

    % consolidate table
    T = table;
    T.comparison = var';
    T.rho = rt';
    T.pvalue = pt';
    writetable(T,fullfile(pResult,'correlation.csv'));


    %% Analysis #4 Time on page

    xvarnames = {'TimeOnPage'}; xvarlabel = {'Time(s)'};
    gvarnames = {'VideoOrText'};

    % create table
    for xi = 1:numel(xvarnames)
        xvarnamesNow = xvarnames{xi};
    for gi = 1:numel(gvarnames)
        gvarnamesNow = gvarnames{gi};
        G = Data.(gvarnamesNow); 
        gunames = unique(G);
        LEGEND = {};
        TIME = [];
    for gui = 1:numel(gunames)
        gunameNow = gunames{gui};
        i = ismember(G,gunameNow);
        t = Data.(xvarnamesNow)(i);
        % get video time data
        t(isnan(t)) = [];
        L = repmat({gunameNow},numel(t),1);

        LEGEND = [LEGEND;L];
        TIME = [TIME;t];
    end
        TimeSpent = table;
        TimeSpent.Type = LEGEND;
        TimeSpent.time = TIME;
        % analysis
        u = unique(TimeSpent.Type);
        uname = strjoinrows(u',' vs ');
        prefix = sprintf('%s - %s',xvarnamesNow, char(uname));
        [text,T,p,s,t,ST] = anova1_autoresults(TimeSpent.time ,TimeSpent.Type);
        T = sortrows(T,{'gnames'},{'descend'});
        writetable(ST,fullfile(pResult,[prefix,' anova.csv']),'WriteRowNames',1);
        writetable(T,fullfile(pResult,[prefix,' descriptive.csv']));

        h = barwitherr(T.SE, T.mean);
        set(h(1),'FaceColor',[0.5 0.5 0.5]);
        set(gca,'XTickLabel',T.gnames);
        ylabel(xvarlabel{xi});
        xlim([0.5 numel(T.mean)+0.5])
        ylim([0 100])
        printfig(prefix,pResult,'h',3,'w',numel(T.mean));
    end
    end
end










