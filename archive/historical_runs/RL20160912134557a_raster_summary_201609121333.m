
%% INITIALIZING
% clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false);
addpath(pM);
return
%%

pRoot = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/3-STH N2/3-Results/';
pS = fullfile(pRoot,'3.1 raster summary');
pD = fullfile(pRoot,'Data/10sISI Dose/fx-response shift effect is biphasic and dose dependent/raster plot new/');

%% get data paths
dircontent(pD)

%% get 1 seconds before tap
col_tap = 11:50:size(rTime,2)-10;
col_rest = [];
for x = 1:numel(col_tap)
    col_rest(x,:) = col_tap(x)-5:col_tap(x)-1;
end
col_rest = reshape(col_rest,numel(col_rest),1);
col_rest = sort(col_rest);

% get data
d = Data(:,col_rest);
d = reshape(d,numel(d),1);
mean(d)
