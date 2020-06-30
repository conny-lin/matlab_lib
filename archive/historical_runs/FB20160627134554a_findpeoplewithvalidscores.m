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

%%
Email = cell(numel(pf));
EmailValid = Email;
ScoreCount = Email;
for pfi = 1:numel(pf)
    %% read table
    T = readtable(char(pf(pfi)));

    %% get rid of games not in focus
    T(~ismember(T.game_id, game_idTarget),:) = [];

    %% find if have more than 24*4 scores
    a = tabulate(T.email);
    i = cell2mat(a(:,2)) > numel(game_idTarget)*4;
    eT = a(i,1); % get email targets
    T(~ismember(T.email, eT),:) = [];

    %%
    [tbl,~,~,labels] = crosstab(T.email, T.game_id);
    a = tbl > 4;
    b = sum(a,2);
    e = labels(:,1); % emails
    % store
    e(cellfun(@isempty,e)) = [];
    Email{pfi} = e;
    ScoreCount{pfi} = tbl;
    % valid emails
    v = b > numel(game_idTarget); % get valid emails
    if sum(v) > 0
        EmailValid{pfi} = e(v);
    end 
    
end


return
