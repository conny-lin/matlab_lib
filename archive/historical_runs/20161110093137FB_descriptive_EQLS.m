%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% ----------------------------


%% SETTING +++++++++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
% ---------------

%% load data +++++++++++++
load(fullfile(pData,'Data.mat'));
% ----------------------------

%% EQ descriptive +++++++++++++++
% EQ35
s = statsBasic(EQ35.score,'outputtype','table');
r = statsBasic(EQ35.RT,'outputtype','table');
a = statsBasic(EQ35.accuracy,'outputtype','table');
T = table;
T.type = {'score';'RT';'accuracy'};
T = [T [s;r;a]];
writetable(T,fullfile(pM,'Stroop.csv'));

% EQ37
s = statsBasic(EQ37.score,'outputtype','table');
r = statsBasic(EQ37.RT,'outputtype','table');
a = statsBasic(EQ37.accuracy,'outputtype','table');

T = table;
T.type = {'score';'RT';'accuracy'};
T = [T [s;r;a]];
writetable(T,fullfile(pM,'MoodRecognition.csv'));
% -------------------------------

%% Lifestyle
t = statsBasic(LS_Score.total,'outputtype','table');


for x = 2:size(LS_Score_subsection,2)
    t2 = statsBasic(LS_Score_subsection(:,x),'outputtype','table');
    t =[t;t2];
end

% create
a = legend_LS_Q.subsection_id;
a = tabulate(a);
maxs = [97;a(2:end,2)];

% create legend
T = table;
T.category = [{'total'};legend_LS_subsection.subsection(2:end)];
T = [T t];
T.maxpoints = maxs;
writetable(T,fullfile(pM,'Lifestyle.csv'));

return




%% historgram
Mtype = {'score';'RT';'accuracy'};
for x = 1:numel(Mtype)
    mtype = Mtype{x};
    hist(EQ35.(mtype),50)
    titlename = ['Stroop ',mtype];
    title(titlename)
    printfig(titlename,pM);
end

for x = 1:numel(Mtype)
    mtype = Mtype{x};
    hist(EQ37.(mtype),50)
    titlename = ['MoodRecog ',mtype];
    title(titlename)
    printfig(titlename,pM);
end