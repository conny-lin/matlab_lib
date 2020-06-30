%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
addpath(fullfile(fileparts(pM),'functions'));

%% path and settings
pD = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-STH genes/Data/10sIS by strains';
startime = -0.1;
endtime = 1;

%% load data
strain = 'MT2633';
p = fullfile(pD,strain,'ephys graph','data_ephys_t28_30.mat');
load(p,'DataG')

%% get exploratory stats by plates
GT = stats_by_plates(DataG,startime,endtime);

%% make side by side wildtype mutant line graph





