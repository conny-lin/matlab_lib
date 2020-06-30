%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

datapath = '/Users/connylin/Dropbox/CA/Neuropolitics Reiner Owen/Data Exp 1';

%% IMPORT DATA
% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/connylin/Dropbox/CA/Neuropolitics Reiner Owen/Data Exp 1/Fake News 1.0.xlsx
%    Worksheet: Cleaned data
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2017/11/13 13:31:11

% Import the data
[~, ~, raw] = xlsread('/Users/connylin/Dropbox/CA/Neuropolitics Reiner Owen/Data Exp 1/Fake News 1.0.xlsx','Cleaned data');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[1,3,6,7,8,9,10,14,16,17,18,19,20,22,24,26,28,30,32,33,34,38,40,42,44,46,48]);
raw = raw(:,[2,4,5,11,12,13,15,21,23,25,27,29,31,35,36,37,39,41,43,45,47,49]);

% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

% Create output variable
data = reshape([raw{:}],size(raw));

% Create table
Data = table;
% Allocate imported array to column variable names
Data.Status = cellVectors(:,1);
Data.InternalID = data(:,1);
Data.Language = cellVectors(:,2);
Data.CreatedAt = data(:,2);
Data.UpdatedAt = data(:,3);
Data.Location = cellVectors(:,3);
Data.Username = cellVectors(:,4);
Data.GETVariables = cellVectors(:,5);
Data.Referrer = cellVectors(:,6);
Data.NumberofSaves = cellVectors(:,7);
Data.WeightedScore = data(:,4);
Data.CompletionTime = data(:,5);
Data.VideoTimeonPage = data(:,6);
Data.TextTimeonPage = cellVectors(:,8);
Data.QP1TimeonPage = data(:,7);
Data.IPAddress = cellVectors(:,9);
Data.InviteCode = cellVectors(:,10);
Data.InviteEmail = cellVectors(:,11);
Data.InviteName = cellVectors(:,12);
Data.Collector = cellVectors(:,13);
Data.ConsentIconsenttoparticipate = data(:,8);
Data.ConsentIdonotconsenttoparticipate = cellVectors(:,14);
Data.Instructions_Time = data(:,9);
Data.Instructions_Time1 = cellVectors(:,15);
Data.Instructions_Attention = data(:,10);
Data.Instructions_Attention1 = cellVectors(:,16);
Data.Instructions_Distractions = data(:,11);
Data.Instructions_Distractions1 = cellVectors(:,17);
Data.Sound = data(:,12);
Data.Sound1 = cellVectors(:,18);
Data.Proceed1Areyoureadytoproceed = data(:,13);
Data.Proceed1Areyoureadytoproceed1 = cellVectors(:,19);
Data.Proceed2Areyoureadytoproceed = cellVectors(:,20);
Data.Proceed2Areyoureadytoproceed1 = cellVectors(:,21);
Data.Plausible = data(:,14);
Data.Age = data(:,15);
Data.sex = data(:,16);
Data.sex1 = cellVectors(:,22);
Data.BT = data(:,17);
Data.BT1 = cellVectors(:,23);
Data.Gregor = data(:,18);
Data.Gregor1 = cellVectors(:,24);
Data.Mother = data(:,19);
Data.Mother1 = cellVectors(:,25);
Data.Voting = data(:,20);
Data.Voting1 = cellVectors(:,26);
Data.Media = data(:,21);
Data.Media1 = cellVectors(:,27);
Data.Verify = data(:,22);
% Clear temporary variables
clearvars data raw cellVectors R;
% save raw
save(fullfile(datapath,'data.mat'),'Data');


% create variable for video or text
Data.VideoOrText = ones(size(Data,1),1);
Data.VideoOrText1 = repmat({'video'},size(Data,1),1);
a = Data.TextTimeonPage;
i = ~cellfun(@isempty,a);
Data.VideoOrText(i) = 2;
Data.VideoOrText1(i) = {'text'};
if sum(~isnan(Data.VideoTimeonPage(i))) ~= 0 
    error('some participants got video and text');
end
grpstats(Data.Plausible,Data.VideoOrText1,{'mean','sem'})



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
prefix = 'plausible vs videotext voting';
[text,T,p,s,t,ST] = anova1_autoresults(Plausible,VT);
writetable(ST,fullfile(datapath,[prefix,' anova.csv']),'WriteRowNames',1);
writetable(T,fullfile(datapath,[prefix,' descriptive.csv']));

h = barwitherr(T.SE, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',T.gnames);
ylabel('plausiblity');
xlim([0.5 2.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',3);

% ... vs voting
prefix = 'plausible vs videotext voting';
[sout,T] = anovan_std(Plausible,{VT,Voting},{'VT','Voting'},datapath,'prefix',[prefix,' ']);
writetable(T,fullfile(datapath,[prefix,'.csv']))
h = barwitherr(T.se, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',T.gnames);
ylabel('plausiblity');
xlim([0.5 2.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',3);
% ... vs sex
prefix = 'plausible vs videotext sex';
[sout,T] = anovan_std(Plausible,{VT,Sex},{'VT','Sex'},datapath,'prefix',[prefix,' ']);
writetable(T,fullfile(datapath,[prefix,'.csv']));
h = barwitherr(T.se, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',T.gnames);
ylabel('plausiblity');
xlim([0.5 2.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',3);
% ... vs media
prefix = 'plausible vs videotext media';
[sout,T] = anovan_std(Plausible,{VT,Media},{'VT','Media'},datapath,'prefix',[prefix,' ']);
writetable(T,fullfile(datapath,[prefix,'.csv']));
h = barwitherr(T.se, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',T.gnames);
ylabel('plausiblity');
xlim([0.5 2.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',3);
% ... vs voting, sex, media
prefix = 'plausible vs videotext voting sex media';
[sout,T] = anovan_std(Plausible,{VT,Sex, Voting, Media},{'VT','Sex','Voting','Media'},datapath,'prefix',[prefix,' ']);
writetable(T,fullfile(datapath,[prefix,'.csv']));
h = barwitherr(T.se, T.mean);
set(h(1),'FaceColor',[0.5 0.5 0.5]);
set(gca,'XTickLabel',T.gnames);
ylabel('plausiblity');
xlim([0.5 2.5])
ylim([0 100])
printfig(prefix,datapath,'h',3,'w',3);

%% Analyze #2 news varify vs plausibility
scatter(Plausible,NewsVarify)
xlabel('Plausible');
ylabel('News Varify');
printfig('plausible vs news varify scatter',datapath,'h',3,'w',3)

gscatter(Plausible,NewsVarify,VT,'','xo')
xlabel('Plausible');
ylabel('News Varify');
printfig('plausible vs news varify by videotext scatter',datapath,'h',4,'w',4)
















