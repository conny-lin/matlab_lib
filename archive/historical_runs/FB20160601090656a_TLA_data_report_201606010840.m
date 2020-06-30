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
%% convert time
d_utc = T.played_at_utc;

utcstd = repmat(datenum(1970,1,1),numel(d_utc),1);
a = (d_utc/86400) + datenum(1970,1,1);
date_utc = datetime(datestr(a));
date_pst = date_utc - hours(7);
date_pst = datetime(date_pst,'Format','yyyy-MM-dd HH:mm:ss');
T.playtimestamp = date_pst;
