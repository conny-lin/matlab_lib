%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pDataHome = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/5-Tolerance/3-Results/0-Data/200mM 24h 200mM Chronic';
% --------------------

% settings ++++++
pvsig = 0.05;
pvlim = 0.001;
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strainlist = {'DA609','MT14480','RB1025','RB1347'};


for si = 1:numel(strainlist)
% prepare data ++++++++++++++++++++++
strain= strainlist{si};
p = fullfile(pDataHome, strain,'Dance_RapidTolerance','raw.csv');
% import
Raw = readtable(p);

% get variables
Data = table;
Data.group = Raw.condition_short;
Data.speed = Raw.speed;

% filter conditions

% ------------------------------------

% get data +++++++++++++
ictrl = ismember(Data.group,'0mM 0mM');
DataC = Data(ictrl,:);
DataG = Data(~ictrl,:);
% ----------------------------

% get data for lines ++++
d = DataC.speed;
n = numel(unique(DataG.group));
[x,leg] = statsBasic(d,'outputtype','table');
m1 = x.min;
m2 = x.max;
se1 = x.mean+x.se;
se2 = x.mean-x.se;
sd1 = x.mean+x.sd;
sd2 = x.mean-x.sd;
% -----------------------

%% FIGURE
% settings
linedata = 'range';

% dot (exclude 0-0)
fig1 = clusterDotsErrorbar(DataG.speed,DataG.group,...
        'markersize',6,...
        'groupseq',{'200mM 0mM','0mM 200mM','200mM 200mM'},...
        'yname','Speed','xname','',...
        'fontsize',12,'scatterdotcolor',[0.5 0.5 0.5]);

setting = get(fig1);
hold all

% add line (0-0) max min
linec = [0 0 0];

switch linedata
    case 'range'
        plot([0.5 n+0.5],[m1 m1],'Color',linec,'LineStyle','--')
        plot([0.5 n+0.5],[m2 m2],'Color',linec,'LineStyle','--')
    case 'se'
        plot([0.5 n+0.5],[se1 se1],'Color',linec,'LineStyle',':')
        plot([0.5 n+0.5],[se2 se2],'Color',linec,'LineStyle',':')
    case 'sd'
        plot([0.5 n+0.5],[sd2 sd2],'Color',linec,'LineStyle','--')
        plot([0.5 n+0.5],[sd1 sd1],'Color',linec,'LineStyle','--')
end
% print 
printfig(strain,pM,'w',5,'h',3)




end





















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%