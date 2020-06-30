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

%% convert user id
% parse participant id
a = T.email;
a = regexpcellout(a,'\d{1,}(?=@)','match');
a = regexprep(a,'0','');
partid = cellfun(@str2num,a);
T.participant_id = partid;

%% convert time
d_utc = T.played_at_utc;

utcstd = repmat(datenum(1970,1,1),numel(d_utc),1);
a = (d_utc/86400) + datenum(1970,1,1);
date_utc = datetime(datestr(a));
date_pst = date_utc - hours(7);
date_pst = datetime(date_pst,'Format','yyyy-MM-dd HH:mm:ss');
T.playtimestamp = date_pst;


%% get time
t = T.playtimestamp;
% t = datetime(t,'Format','MMdd');
t = datestr(t,'mmdd');
T.playdate  = t;
%% summary: play time
% D = table(partid,t);
% D = sortrows(D,{'t'});
T = sortrows(T,{'playdate'});

[a,b,c,labels] = crosstab(T.playdate,T.participant_id);
coln = labels(:,2);
coln(cellfun(@isempty,coln)) = [];
colname = matlab.lang.makeValidName(coln,'Prefix','p');
rown = labels(:,1);
rown(cellfun(@isempty,rown)) = [];
PlayMinPerPar = array2table(a,'VariableName',colname,'RowName',rown)

%%
cd(fileparts(pM))
writetable(PlayMinPerPar,'Participant play_mins per day.csv','WriteRowNames',1)
return



%%
% p(cellfun(@isempty,p)) = [];
% d = d(:,2);
% d1 = cellfunexpr(d,'d');
% p1 = cellfunexpr(p,'p');
% 
% strjoinrows([d1 d],'')
















