
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

cd(fileparts(pM));
load('gamenameTable.mat','gamenameTable');
[i,j] = ismember(T.game_id,gamenameTable.id);
if any((gamenameTable.id(j(i)) - T.game_id)~=0);
    error('game match error')
end

T.domain =  gamenameTable.area(j(i));
T.game_name = gamenameTable.name(j(i));
Score = T;
% save table
cd(pM);
writetable(Score,'Participant score raw.csv');


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
% make table align pid, game id, d1-dx
pid = unique(Score.participant_id);
gameidu = unique(gamenameTable.id);
dateu = unique(Score.playdate);
dateuid = (1:numel(dateu))';
domainu = unique(gamenameTable.area);
domainidu = (1:numel(domainu))';


%% construct calculation table
dheader = nan(numel(pid)*numel(gameidu),2);
darray = nan(size(dheader,1),numel(dateu));
rowN = 1;
for pii = 1:numel(pid)
   for gid = 1:numel(gameidu)
       i = ismember(Score.participant_id,pid(pii)) & ...
           ismember(Score.game_id,gameidu(gid));
       s = Score(i,:);
       dheader(rowN,1) = pid(pii);
       dheader(rowN,2) = gameidu(gid);
       if ~isempty(s)      
           dates = s.playdate;
           score = s.score;
           [score,dates] = grpstats(score,dates,{'max','gname'});
           [i,j] = ismember(dateu,dates);
           col = j(i);
           darray(rowN,col) = score;
       end
       rowN = rowN+1;
   end 
end



%% remove zero scores
% darray(darray==0) = NaN;

%% add domain id
[i,j] = ismember(dheader(:,2),gamenameTable.id);
a = gamenameTable.area(j(i));
[i,j] = ismember(a,domainu);
a = domainidu(j(i));
dheader(:,3) = a;
dheader = array2table(dheader,'VariableNames',{'pid','gameid','domainid'});

%% fill in NaN score
darray2 = darray;
for ci = 2:size(darray,2)
    d = darray2(:,ci);
    d1 = darray2(:,ci-1);
    i = isnan(d);
    darray2(i,ci) = d1(i);
end

%%
d = diff(darray2')'; % get score diff from last try
d1 = darray2(:,1:end-1); % get previous day score
d2 = (d./d1).*100; % get percent diff from previous day
d3 = d2;
d3(isnan(darray(:,2:end))) = NaN;

%% combine with domain average per day
sarray = cell(numel(pid),1);
sheader = cell(numel(pid),1);
for pii= 1:numel(pid)
    parray = nan(numel(domainidu),numel(dateu)-1);
    for ci =1:size(d3,2)
        i = dheader.pid == pid(pii);
        s = d3(i,ci);
        g = dheader.domainid(i);
        [m,gn] = grpstats(s,g,{'mean','gname'});
        rowid = cellfun(@str2num,gn);
        parray(rowid,ci) = m;
    end
    
    sheader{pii} = [repmat(pid(pii),numel(domainidu),1) domainidu];
    sarray{pii} = parray;
end

%% convert to table;
day = cell2mat(sarray);
day = [zeros(size(day,1),1) day];
a = array2table(day);
b = array2table(cell2mat(sheader),'VariableNames',{'pid','domain'});
T = [b a]































































return





%%









