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
secid = legend_LS_subsection.subsection_id;
for x = 1:numel(secid)
    
end

