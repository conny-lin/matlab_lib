%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
addpath(fullfile(fileparts(pM),'functions'));

%% path
pD = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-STH genes/Data/10sIS by strains';

%% load data
strain = 'MT2633';
p = fullfile(pD,strain,'ephys graph','data_ephys_t28_30.mat');
load(p,'DataG')

%% get group names
groupnames = get_groupname_from_DataG(DataG);

%% convert data to table
for gi = 1:numel(groupnames)
    % group name
    gn = groupnames{gi};
    % extract data
    [t,v,mwtid,id] = extract_data_from_DataG(DataG,gn,-0.1,1);
    
    % stats per plate
    V = velocity_plate_stats(t,v,mwtid);
    T = statsBasic(V,'outputtype','table');


return
end




