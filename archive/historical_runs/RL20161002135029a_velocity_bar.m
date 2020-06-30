%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);


%% paths
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-STH genes/Data/10sIS by strains';

%% definitions
time_baseline = -0.1;
time_assay = [0.2 1];
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



%% CALCULATIONS

A = nan(size(groupnames),8);
for gi = 1:numel(groupnames) % for each groups
   
    % get group name
    gn = groupnames{gi};
    % get ephys data
    DataE = Ephys.(gn);
    % get time index
    t = D.time{gi}(1,:);
    % get velocity
    v = D.(dataname){gi};
    
    % get baseline
    bs = v(:,t == time_baseline);    
    % get mean response from 0.2-0.3s 
    r = nanmean(v(:,t == 0.2 | t==0.3),2);
    % combine data
    d = [bs r];
    % exclude data: bs or r can't be nan
    d(any(isnan(d),2),:) =[];
    % exclude data: bs can't be reversals
    d(d(:,1) < 0,:) = [];
    % exclude data: bs and r both zeros
    d(d(:,1)==0 & d(:,2) == 0,:) = [];
    % get n
    n = size(d,1);
    
    % calculate diff
    d(:,3) = d(:,2) - d(:,1);
    
    
    %% get mean
%     mean(d(:,4))
     a = statsBasic(d(:,3));
     A(gi,:) = a;
     
end


%% GRAPH




















