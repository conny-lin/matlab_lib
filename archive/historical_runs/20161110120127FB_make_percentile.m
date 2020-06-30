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


%% transform data
Mtype = Score.Properties.VariableNames;
P = nan(size(Score));
for x = 1:numel(Mtype)
   
    mtype = Mtype{x};
    data = Score.(mtype);
    n = numel(unique(data));
    titlename = regexprep(mtype,'_',' ');
    
    %% transform to percentile
    d = Score.(mtype);
    pct = transform_percentile(d);
    
    P(:,x) = pct;
end


























