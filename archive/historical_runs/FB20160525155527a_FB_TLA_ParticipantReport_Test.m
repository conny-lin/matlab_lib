
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);

%%
cd(fileparts(pM));
filename = 'score-export.txt';
formatStr = '%s%s%d%d%f%f%s%[^\n\r]';
T = import_txtfile2table(filename,formatStr); % get data
T.playtimestamp = T.FROM_UNIXTIME_s_played_at_utc_;
T.FROM_UNIXTIME_s_played_at_utc_ = [];


%% prep table
% parse participant id
a = T.email;
a = regexpcellout(a,'\d{1,}(?=@)','match');
a = regexprep(a,'0','');
partid = cellfun(@str2num,a);
T.participant_id = partid;

% parse time
a = regexpcellout(T.playtimestamp,' ','split');
T.playdate = a(:,1);
T.playtime = a(:,2);
% save table
writetable(T,'Participant score raw.csv');


%% summary: play time
[a,b,c,labels] = crosstab(T.playdate,T.participant_id);
coln = labels(:,2);
coln(cellfun(@isempty,coln)) = [];
colname = matlab.lang.makeValidName(coln,'Prefix','p');
rown = labels(:,1);
rown(cellfun(@isempty,rown)) = [];
PlayMinPerPar = array2table(a,'VariableName',colname,'RowName',rown);

cd(pM)
writetable(PlayMinPerPar,'Participant play_mins per day.csv','WriteRowNames',1)


%% summary: game id score
cd(fileparts(pM));
load('gamenameTable.mat','gamenameTable');

%%
return





%%









