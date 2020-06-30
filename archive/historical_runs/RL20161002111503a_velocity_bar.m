%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);


%% paths
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-STH genes/Data/10sIS by strains';


%% cycle across strains
% define strain
strain = 'NM1968';
% strain data path, last 3 taps
p = fullfile(pData, strain, 'ephys graph','data_ephys_t28_30.mat');
% load file
load(p);

%% CALCULATIONS
% for each groups

% get baseline
% get 0.2-0.3s average
% find percent change from baseline

%% GRAPH

