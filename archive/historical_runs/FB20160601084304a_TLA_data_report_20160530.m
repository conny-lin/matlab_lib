%% INITIALIZING
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false); 
pSave = fileparts(pM);

%%
addpath('/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Test codes');

%%
[~,pf] = dircontent(pSave,'scores-export-*.csv');
T = readtable(char(pf));

%%
% unique(T.product_id)
dateVectorUtc = T.played_at_utc(1)

% dateStringLocal = utc_to_local_time( dateVectorUtc, 0 )