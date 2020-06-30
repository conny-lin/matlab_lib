
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);


%% import file
cd(fileparts(pM));
filename = 'score_stats.txt';
formatStr = '%d%s%d%d%f%f%f%f%f%f%f%s%[^\n\r]';
T = import_txtfile2table(filename,formatStr); % get data
% T.playtimestamp = T.FROM_UNIXTIME_s_played_at_utc_;
% T.FROM_UNIXTIME_s_played_at_utc_ = [];







