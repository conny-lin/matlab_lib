function TLA_practiceTime(T,pSave)


%% get time
t = T.playtimestamp;
% t = datetime(t,'Format','MMdd');
t = datestr(t,'mmdd');
T.playdate  = t;
%% summary: play time

T = sortrows(T,{'playdate'});

[a,b,c,labels] = crosstab(T.playdate,T.participant_id);
coln = labels(:,2);
coln(cellfun(@isempty,coln)) = [];
colname = matlab.lang.makeValidName(coln,'Prefix','p');
rown = labels(:,1);
rown(cellfun(@isempty,rown)) = [];
PlayMinPerPar = array2table(a,'VariableName',colname,'RowName',rown);

%%
cd(pSave)

writetable(PlayMinPerPar,'Participant play_mins per day.csv','WriteRowNames',1)
return