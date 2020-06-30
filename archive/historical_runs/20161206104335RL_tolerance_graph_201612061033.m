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
% prepare data ++++++++++++++++++++++
strain= 'MT14480';
p = fullfile(pDataHome, strain,'Dance_RapidTolerance','raw.csv');
% import
Raw = readtable(p);

% get variables
Data = table;
Data.group = Raw.condition_short;
Data.speed = Raw.speed;

% filter conditions

% ------------------------------------

% get control data +++++++++++++
ictrl = ismember(Data.group,'0mM 0mM');
DataC = Data(ictrl,:);
DataG = Data(~ictrl,:);



% -------------------------------

% get experiemntal data +++++=
% Spe
% -----------------

%% FIGURE


% dot (exclude 0-0)
fig1 = clusterDotsErrorbar(DataG.speed,DataG.group,'markersize',10)

% add line (0-0) max min







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%