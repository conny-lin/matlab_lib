%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datapath = fileparts(pM);
addpath(datapath);
pData = fullfile(fileparts(pM), 'FakeNews 1.1.xlsx');
% datapath = '/Users/connylin/Dropbox/CA/Neuropolitics Reiner Owen/Data Exp 1';

%% IMPORT DATA
Data = import_data_1_1(pData);

return




%% CLEAN
fprintf('%d rows\n',size(Data,1));
% consolidate duplicates answers
i = isnan(Data.Proceed1Areyoureadytoproceed);
a = Data.Proceed2Areyoureadytoproceed(i);
a(cellfun(@isempty,a)) = {5};
b = cell2mat(a);
Data.ProceedConsolidate = Data.Proceed1Areyoureadytoproceed;
Data.ProceedConsolidate(i) = b;

% remove samples without validator questions = yes
a = Data(:,{'Instructions_Time','Instructions_Attention','Instructions_Distractions','Sound','ProceedConsolidate'});
a = table2array(a);
i = any(a~=1,2);
Data(i,:) = [];
fprintf('%d rows\n',size(Data,1));

% take out gregor and mother
a = Data(:,{'Gregor','Mother','BT'});
a = table2array(a);
i = any(a~=2,2);
Data(i,:) = [];
fprintf('%d rows\n',size(Data,1));




%% Prepare variables
Plausible = Data.Plausible;
VT = Data.VideoOrText1;
VTN = Data.VideoOrText;
Age = Data.Age;
Sex = Data.sex1;
Voting = Data.Voting1;
Media = Data.Media1;
NewsVarify = Data.Verify;

%% ANALYZE # 1 categorical 
% VT vs plausible
prefix = 'plausible vs videotext';
[text,T,p,s,t,ST] = anova1_autoresults(Plausible,VT);
writetable(ST,fullfile(datapath,[prefix,' anova.csv']),'WriteRowNames',1);
writetable(T,fullfile(datapath,[prefix,' descriptive.csv']));

h = barwitherr(T.SE, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',T.gnames);
ylabel('plausiblity');
xlim([0.5 numel(T.mean)+0.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',numel(T.mean));

% ... vs voting
prefix = 'plausible vs videotext voting';
[sout,T] = anovan_std(Plausible,{VT,Voting},{'VT','Voting'},datapath,'prefix',[prefix,' ']);
writetable(T,fullfile(datapath,[prefix,'.csv']))
gname = T.gnameu;
gname = regexprep(gname,'text','t');
gname = regexprep(gname,'video','v');

h = barwitherr(T.se, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',gname);
ylabel('plausiblity');
xlim([0.5 numel(T.mean)+0.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',numel(T.mean));

% ... vs sex
prefix = 'plausible vs videotext sex';
[sout,T] = anovan_std(Plausible,{VT,Sex},{'VT','Sex'},datapath,'prefix',[prefix,' ']);
writetable(T,fullfile(datapath,[prefix,'.csv']));
gname = T.gnameu;
gname = regexprep(gname,'text','t');
gname = regexprep(gname,'video','v');

h = barwitherr(T.se, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',gname);
ylabel('plausiblity');
xlim([0.5 numel(T.mean)+0.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',numel(T.mean));

% ... vs media
prefix = 'plausible vs videotext media';
[sout,T] = anovan_std(Plausible,{VT,Media},{'VT','Media'},datapath,'prefix',[prefix,' ']);
writetable(T,fullfile(datapath,[prefix,'.csv']));
gname = T.gnameu;
gname = regexprep(gname,'text','t');
gname = regexprep(gname,'video','v');

h = barwitherr(T.se, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',gname);
ylabel('plausiblity');
xlim([0.5 numel(T.mean)+0.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',numel(T.mean));

% ... vs voting, sex, media
prefix = 'plausible vs videotext voting sex media';
[sout,T] = anovan_std(Plausible,{VT,Sex, Voting, Media},{'VT','Sex','Voting','Media'},datapath,'prefix',[prefix,' ']);
writetable(T,fullfile(datapath,[prefix,'.csv']));
gname = T.gnameu;
gname = regexprep(gname,'text','t');
gname = regexprep(gname,'video','v');

h = barwitherr(T.se, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',gname);
ylabel('plausiblity');
xlim([0.5 numel(T.mean)+0.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',numel(T.mean));


%% Analyze #2 news varify vs plausibility
var = {};
rt = [];
pt = [];

% plaus vs verify
name = 'plausible vs news verify';
scatter(Plausible,NewsVarify)
xlabel('Plausible');
ylabel('News Verify');
printfig([name ' scatter'],datapath,'h',4,'w',4)
[r,p] = corr(Plausible,NewsVarify);
var(end+1) = {name};
rt(end+1) = r;
pt(end+1) = p;

gscatter(Plausible,NewsVarify,VT,'','xo')
xlabel('Plausible');
ylabel('News Verify');
printfig('plausible vs news verify by videotext scatter',datapath,'h',4,'w',4)

name = 'plausible vs news verify x video';
i = VTN==1;
[r,p] = corr(Plausible(i),NewsVarify(i));
var(end+1) = {name};
rt(end+1) = r;
pt(end+1) = p;

name = 'plausible vs news verify x text';
i = VTN==2;
[r,p] = corr(Plausible(i),NewsVarify(i));
var(end+1) = {name};
rt(end+1) = r;
pt(end+1) = p;



% plaus vs age
name = 'plausible vs age';
scatter(Plausible,Age)
xlabel('Plausible');
ylabel('Age');
printfig([name ' scatter'],datapath,'h',4,'w',4)
[r,p] = corr(Plausible,Age);
var(end+1) = {name};
rt(end+1) = r;
pt(end+1) = p;


gscatter(Plausible,Age,VT,'','xo')
xlabel('Plausible');
ylabel('Age');
printfig('plausible vs age by videotext scatter',datapath,'h',4,'w',4)

name = 'plausible vs age x video';
i = VTN==1;
[r,p] = corr(Plausible(i),Age(i));
var(end+1) = {name};
rt(end+1) = r;
pt(end+1) = p;

name = 'plausible vs age x text';
i = VTN==2;
[r,p] = corr(Plausible(i),Age(i));
var(end+1) = {name};
rt(end+1) = r;
pt(end+1) = p;


T = table;
T.comparison = var';
T.rho = rt';
T.pvalue = pt';
writetable(T,'correlation.csv');

%% Analysis #3 Time on page
% get video time data
VideoTime = Data.VideoTimeonPage;
a = VideoTime;
a(isnan(a)) = [];
VideoTime = a;
VideoLegend = repmat({'Video'},numel(VideoTime),1);

% text time data conversion
TextTime = Data.TextTimeonPage;
a = TextTime;
a(cellfun(@isempty,a)) = [];
TextTime = cell2mat(a);
TextLegend = repmat({'Text'},numel(TextTime),1);


%% create table
TimeSpent = table;
TimeSpent.Type = [VideoLegend;TextLegend];
TimeSpent.time = [VideoTime;TextTime];

%%
% analysis
prefix = 'videotime vs textime';
[text,T,p,s,t,ST] = anova1_autoresults(TimeSpent.time ,TimeSpent.Type );
writetable(ST,fullfile(datapath,[prefix,' anova.csv']),'WriteRowNames',1);
writetable(T,fullfile(datapath,[prefix,' descriptive.csv']));

h = barwitherr(T.SE, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',T.gnames);
ylabel('Time(s)');
xlim([0.5 numel(T.mean)+0.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',numel(T.mean));










