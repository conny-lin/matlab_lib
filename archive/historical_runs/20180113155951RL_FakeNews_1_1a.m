%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datapath = fileparts(pM);
addpath(fullfile(datapath,'Function'));
pResult = pM;
pData = fullfile(fileparts(pM), 'FakeNews 1.1.xlsx');
% datapath = '/Users/connylin/Dropbox/CA/Neuropolitics Reiner Owen/Data Exp 1';

%% IMPORT DATA
Data = import_data_1_1(pData);



%% CLEAN
fprintf('original data number: %d rows\n',size(Data,1));
% get only data with video or text
i = cellfun(@isempty,Data.VideoOrText);
fprintf('number of samples with video or text time: %d\n',sum(i));
Data(i,:) = [];
fprintf('Data N removed no video or tex time: %d rows\n',size(Data,1));

% consolidate duplicates answers
% i = isnan(Data.Proceed1Areyoureadytoproceed);
% a = Data.Proceed2Areyoureadytoproceed(i);
% a(cellfun(@isempty,a)) = {5};
% b = cell2mat(a);
% Data.ProceedConsolidate = Data.Proceed1Areyoureadytoproceed;
% Data.ProceedConsolidate(i) = b;

% remove samples without validator questions = yes
% a = Data(:,{'Instructions_Time','Instructions_Attention','Instructions_Distractions','Sound','ProceedConsolidate'});
% a = table2array(a);
% i = any(a~=1,2);
% Data(i,:) = [];
% fprintf('%d rows\n',size(Data,1));

% take out gregor and mother
a = Data(:,{'Gregor','BT'});
a = table2array(a);
i = any(a~=2,2);
Data(i,:) = [];
fprintf('take out Gregor and BT: %d rows\n',size(Data,1));



%% ANALYSIS #1: plausible VS Video or Text
% anova
Y = Data.Plausible; yvarname = 'plausible';
X = Data.VideoOrText; xvarname = 'video or text';
prefix = sprintf('%s vs %s', yvarname, xvarname);
[text,T,p,s,t,ST] = anova1_autoresults(Y,X);
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
    T = anova_multifactor(X,xvarname,Y,yvarname,pResult);
    % bar
    make_bar_graph(T,yvarname,pResult,prefix);
end
end
end


%% ANALYSIS #4: scatter plausible VS verify/age, videotext
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
    YsubVarNames = unique(Y);
    for subvari = 1:numel(YsubVarNames)
        % sub var
        subYvar = YsubVarNames{subvari};
        [r,p,name] = corr_by_sub_ans(X,xvarname,Y,yvarname,subYvar);
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


%% Analysis #3 Time on page
% get video time data
VideoTime = Data.TimeOnPage;
a = VideoTime;
a(isnan(a)) = [];
VideoTime = a;
VideoLegend = repmat({'Video'},numel(VideoTime),1);

% text time data conversion
TextTime = Data.TimeOnPage;
a = TextTime;
a(cellfun(@isempty,a)) = [];
TextTime = cell2mat(a);
TextLegend = repmat({'Text'},numel(TextTime),1);

% create table
TimeSpent = table;
TimeSpent.Type = [VideoLegend;TextLegend];
TimeSpent.time = [VideoTime;TextTime];

% analysis
prefix = 'videotime vs textime';
[text,T,p,s,t,ST] = anova1_autoresults(TimeSpent.time ,TimeSpent.Type );
writetable(ST,fullfile(datapath,[prefix,' anova.csv']),'WriteRowNames',1);
writetable(T,fullfile(datapath,[prefix,' descriptive.csv']));

h = barwitherr(T.SE, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',T.gnames);
ylabel('Time(s)');
xlim([0.5 numel(T.mean)+0.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',numel(T.mean));










