%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);


%% SETTING
pSF = '/Users/connylin/Dropbox/RL/PubInPrep/PhD Dissertation/4-STH genes/Data/10sIS by strains';

% SEttings
Setting = struct;
Setting.Color = {[0.5 0.5 0.5]; [1 0.5 0.5];[0 0 0];[1 0 0]};
Setting.Marker = {'o' 'o' 'o' 'o'};
Setting.MarkerEdgeColor = Setting.Color;
Setting.MarkerFaceColor = Setting.Color;
Setting.MarkerSize = {2 2 2 2};


strainlist = dircontent(pSF);
strainlist(~ismember(strainlist,'NM1380')) = [];


%% load data
for si =1:numel(strainlist)
% get strain info
strain = strainlist{si};
fprintf('%d/%d: %s\n',si, numel(strainlist), strain);
% load data for strain
pData = sprintf('%s/%s',pSF,strain);
pSave = pM;


%% graph space out graphs
load(sprintf('%s/%s/ephys graph/data_ephys_t28_30.mat',pSF,strain));

%% get data
G = struct;
for gi = 1:size(DataG,2)
    x = DataG(gi).time(1,6:41);
    Y = DataG(gi).speedb(:,6:41);
    Y(:,6) = NaN;
    y = nanmean(Y);
    n = sum(~isnan(Y));
    e = nanstd(Y)./sqrt(n-1);
    e2 =e*2;
    g = {DataG(gi).name};    
    G.g(1,gi) = g;
    G.x(:,gi) = x';
    G.y(:,gi) = y';
    G.e(:,gi) = e2';
end

Setting.DisplayName = G.g;


errorbar1 = errorbar(G.x,G.y,G.e);

SettingNames = fieldnames(Setting);
for si = 1:numel(SettingNames)
    nms = SettingNames{si};
for gi = 1:size(errorbar1,2)
    errorbar1(gi).(nms) = Setting.(nms){gi};
end
end
title(strain)
xlim([-.5 2]);
ylim([-.3 .4]);
ylabel('velocity (body length/s)')



savename = sprintf('%s ephys t28-30',strain);
printfig(savename,pSave,'w',1,'h',2,'closefig',0);

end

fprintf('Done\n');




























    
    
    
    
    
    
    
    
    
    
    
    