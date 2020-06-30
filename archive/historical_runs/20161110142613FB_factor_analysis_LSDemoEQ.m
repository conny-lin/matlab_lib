%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% ----------------------------


%% SETTING +++++++++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
% ---------------

%% load data +++++++++++++
load(fullfile(pData,'Data.mat'));
% ----------------------------


%% factor analysis
% S = [Userinfo(:,{'age','gender','education'}) ScoreFinal];
S = [ScoreFinal(:,1:3)];
S = table2array(S);
S(any(isnan(S),2),:) = [];
[cidx2,cmeans2] = kmeans(S,2);
[silh2,h] = silhouette(S,cidx2,'sqeuclidean');

ptsymb = {'bs','r^','md','go','c_'};
for i =1:2
    clust = find(cidx2 ==i);
    plot3(S(clust,1),S(clust,2),S(clust,3),ptsymb{i});
end







