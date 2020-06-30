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


A = LS_AnsIDu; 
leg = legend_LS_QAscore; 

S = nan(size(A)); 
[i,j] = ismember(A,leg.aidu);
S = leg.score(j);

%%
secidref = legend_LS_subsection.subsection_id;
secid = legend_LS_Q.subsection_id;
A = nan(size(S,1),numel(secidref));
for x = 1:numel(secidref)
    i = secid == secidref(x);
    S1 = S(:,i);
    A(:,x) = sum(S1,2);
end
LS_Score_subsection = A;
save(fullfile(pData,'Data.mat'),'LS_Score_subsection','-append');