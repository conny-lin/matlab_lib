%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);


%% paths
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-STH genes/Data/10sIS by strains';

%% definitions
time_baseline = -0.1;
time_assay = [0.2 0.3];
dataname = 'speedb';

%% cycle across strains
% define strain
strain = 'NM1968';
% strain data path, last 3 taps
p = fullfile(pData, strain, 'ephys graph','data_ephys_t28_30.mat');
% load data
load(p);
% convert data to table
D = struct2table(DataG);
%% get groups
groupnames = D.name;

return

%% CALCULATIONS

for gi = 1:numel(groupnames) % for each groups
    % get time index
    t = D.time{gi}(1,:);
    % get baseline
    d = D.(dataname){gi}(:,t == time_baseline);
    nanmean(d)
    nanstd(d)
    sum(~isnan(d))
    
% get 0.2-0.3s average
% find percent change from baseline


return
end


%% GRAPH



