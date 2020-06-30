
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);

%%
cd(fileparts(pM));
filename = 'FB game_id friendly_name.txt';
formatStr = '%d%s%s%s%d%[^\n\r]';
T = import_txtfile2table(filename,formatStr); % get data
%%
cd(fileparts(pM));
gamenameTable = T;
save('gamenameTable.mat','gamenameTable');

%%

gamedomains = tabulate(gamenameTable.area);
