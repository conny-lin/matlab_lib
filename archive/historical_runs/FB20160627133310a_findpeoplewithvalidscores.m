%% load score
%% INITIALIZING
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false); 
pSave = fileparts(pM);

%% setting

game_idTarget = [7 23 41 50 51 24 19 20 21 8 49 40 32 18 60 6 10 42 43 62 54 38 48 63];

%%
pSave = '/Users/connylin/Dropbox/FB Collaborator Rosetta Anita/score import';
pShare = '/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Shared data';
[Score_std, gTable] = import_TLA_commonvar(pShare); % import common variables

[~,pf] = dircontent(pSave,'scores-export-*.csv');

pfi = 1;
%% read table
T = readtable(char(pf(pfi)));

%% find if have more than 24*4 scores
a = tabulate(T.email);
i = a(:,2) > numel(game_idTarget)*4;
a(i,1)

return

%%
%% convert time
d_utc = T.played_at_utc;
utcstd = repmat(datenum(1970,1,1),numel(d_utc),1);
a = (d_utc/86400) + datenum(1970,1,1);
date_utc = datetime(datestr(a));
date_pst = date_utc - hours(7);
date_pst = datetime(date_pst,'Format','yyyy-MM-dd HH:mm:ss');
T.playtimestamp = date_pst;
% get time
t = T.playtimestamp;
t = datestr(t,'mm/dd');
T.playdate  = cellstr(t);



%%


