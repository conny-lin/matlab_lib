%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);



return
%% convert data to table
DGT = struct2table(DataG); % convert to table
DGT.Properties.RowNames = DGT.name; % add group name as row name


%% get group data
gn = 'MT2633_400mM';
% get id
id = DGT.id(gn); % get id
id = id{1};
mwtid = id.mwtid;

% get time
time = DGT.time(gn); % get time
time = time{1}(1,:);
% time of interest is -0.1s - 1s
ti = time >= -0.1 & time <=1;
t = time(ti);

% get speed
v = DGT.speedb(gn); % get speed
v = v{1}(:,ti);


%% get average per plate
mwtidu = unique(id.mwtid);
V = nan(numel(mwtidu),numel(t));
for mi = 1:numel(mwtidu)
    i = id.mwtid==mwtidu(mi);
    va = v(i,:);
    va_mean = nanmean(va);
    V(mi,:) = va_mean;
end
