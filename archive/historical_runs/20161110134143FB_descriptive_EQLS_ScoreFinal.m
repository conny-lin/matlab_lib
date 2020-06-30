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


%% EQ descriptive +++++++++++++++
%% zscore
S = ScoreFinal;
Mtype = S.Properties.VariableNames;
a = statsBasic(S(:,1),'outputtype','table');
colnames = a.Properties.VariableNames(2:end);
ST = nan(numel(Mtype),numel(colnames));
for x = 1:numel(Mtype)
    mtype = Mtype{x};
    s = S.(mtype);
    st = statsBasic(S.(mtype));
    ST(x,:) = st;
end


ST = array2table(ST,'VariableNames',colnames);
T = table;
T.msr = Mtype;
T = [T ST];
writetable(T,fullfile(pM,'descriptive stats.csv'));

return

