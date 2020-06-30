
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);


%% import file
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

% transform time to numeric values
a = T.playtimestamp;
a = regexprep(a,'(-)|(:)','');
a = regexprep(a,' ','');
a = cellfun(@str2double,a);
T.playtimestampnum = a;

% add fields
cd(fileparts(pM));
load('gamenameTable.mat','gamenameTable');
[i,j] = ismember(T.game_id,gamenameTable.id);
if any((gamenameTable.id(j(i)) - T.game_id)~=0);
    error('game match error')
end

T.domain =  gamenameTable.area(j(i));
T.game_name = gamenameTable.name(j(i));
T.score_id = (1:size(T,1))';

Score = T;
%% save table
cd(fileparts(pM));
writetable(Score,'Participant score raw.csv');
save('Score.mat','Score');














































return





%%









