%% INITIALIZING
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false); 
pSave = fileparts(pM);


%% settings
addpath('/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Share Code');
pShare = '/Users/connylin/Dropbox/FB Collaborator TLA Operation Participant Report/Shared data';

%% load data
[~,pf] = dircontent(pSave,'scores-export-*.csv');
T = import_TLAscore(pf);
% import file
[Score_std, gTable] = import_TLA_commonvar(pShare);


%% mod Score
Score = T;
Score = transform_pctScore(Score,Score_std);

return
% 
% % calculate percentile from normal curve
% % get mean per game
% Score.score = double(Score.score);
% Score_std(Score_std.age_start~=60 | ~ismember(Score_std.gender,'ALL'),:) = []; % eliminate unnuecssary data
% Sstd = Score_std(:,{'game_id','score_mean','score_std'});
% S = outerjoin(Score(:,{'id','game_id','score'}), Sstd,'MergeKeys',1,'Type','left');
% % 1. substract mean from score
% S.z = S.score - S.score_mean;
% % 2. divide differences by std to find z-score
% S.z = S.z./S.score_std;
% % 3. convert z score to percentile using z-score chart or concerter.
% S.zabs = abs(S.z);
% S.pct = normcdf(S.zabs,0,1);
% % convert negative 
% a = 1-S.pct;
% S.pct(S.z<0) = a(S.z<0);
% S.pct = S.pct.*100;

%% summarize pct improvement per day per domain
% merge
a = Score(:,{'id','playdate','participant_id'});
b = S(:,{'id','game_id','pct'});
S1 = outerjoin(a,b,'Key','id','MergeKey',1);
S1.pid = S1.participant_id;
S1.participant_id = [];

% join domain
S1 = outerjoin(S1,gTable,'Key','game_id','MergeKey',1,'Type','left');
a = [num2cellstr(S1.pid), S1.playdate, S1.area];
S1.idf = strjoinrows(a,'-');

% 1. take maximum pct per person per game per day
[mx,gn] = grpstats(S1.pct,S1.idf,{'max','gname'});
a = regexpcellout(gn,'-','split');
S2 = table;
S2.pid = cellfun(@str2num,a(:,1));
S2.playdate = a(:,2);
S2.area = a(:,3);
S2.pct = mx;

% 2. take mean pct of per domain per day
A = grpstatsTable(S2.pct, strjoinrows([S2.area S2.playdate],'-'));
% 3. plot mean per domain per day
a = regexpcellout(A.gnameu,'-','split');

% get unique pair
areau = unique(gTable.area);
dateu = unique(Score.playdate);
d = repmat(dateu,numel(areau),1);
a = repmat(areau',numel(dateu),1);
a = reshape(a,numel(a),1);
b = strjoinrows([a d],'-');
c = table;
c.gnameu = b;
B = outerjoin(A,c,'Type','right','MergeKeys',1);
B.n(isnan(B.n)) = 0;
a = regexpcellout(B.gnameu,'-','split');
B.area = a(:,1);
B.playdate = a(:,2);
% get rid of emotion
B(regexpcellout(B.area,'(SOCIAL)|(SELF)'),:) = [];

% unstack

D = B(:,{'mean','playdate','area'});
W = unstack(D,'mean','area');
cd(fileparts(pM));
writetable(W,'pct by date domain summary.csv');






















