%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% paths
pData = '/Users/connylin/Dropbox/FB/Database/LifeAssessment_20161212/LS_user.mat';
addpath('/Users/connylin/Dropbox/Publication/Manuscript FB Lifestyle Paul/Data 201612/Functions')
addpath('/Users/connylin/Dropbox/Publication/Manuscript FB Lifestyle Paul/Data/Code');
% load data
load(pData)

%% get last user scores
U = user_scores(:,{'id','user_id','played_at_utc'});
U = sortrows(U,{'user_id','played_at_utc'},{'ascend','descend'});
i = [1;diff(U.user_id)];
j = i~=0;

i = ismember(user_scores.id, U.id(j));
user_scores_last = user_scores(i,:);
save(pM,'user_scores_last');


%% get user information
U = user_info;
% exclude 
i = (U.age >= 90) | (U.age < 10) | ismember(U.gender,'NULL');
U(i,:) = [];

% get user id from scores
user_id = user_scores_last.user_id;
% check unique
if numel(unique(user_id)) ~= size(user_scores_last,1)
    error('duplicate user_id'); 
end

% get user info
[i,j] = ismember(U.user_id, user_id);
user_info_with_scores = U(i,:);
save(pM,'user_info_with_scores','-append');


%% CREATE USER OBJECT
U = UserInfo;
U.user_info = user_info_with_scores;
U.devices = devices;
U.device_data = device_data;

%% Table 1: age x gender table 
T = age_gender_table(U,5);
writetable(T,...
    fullfile(pM,'Table 1 - N gender x agegroup 5yr.csv'),...
    'WriteRowNames',1);

%% TABLE2: country 
T = country_table(U);
writetable(T,fullfile(pM,'Table 2 - countries.csv'));

%% TABLE3: AGE X EDUCATION


%% LS scores
answersArray = LifestyleData(answers, user_scores)
return

%% get raw answers data
A = answers;
% get only completed answers
val = ones(size(A,1),1);
D = regexp(A.answers,'(?<=i:)\d{1,}','match');
i = cellfun(@numel,D) ~= 194;
fprintf('%d complete 97 answers collected\n',sum(~i));
% report incomplete answers
n = size(A,1)-sum(~i);
fprintf('%d incomplete answers\n',n);

% check if question numbers are correct
ind_q = 1:2:194;
Q = D(:,ind_q);
for i = 1:97
   q = Q(:,i);
   q = cellfun(@str2num,q);
   j = q ~= i-1;
   if sum(j) > 0
       error('stop')
   elseif sum(j) == 0
       fprintf('question #%d ok\n',i);
   end
end
clear Q q j

% get answers
ind_a = 2:2:194;
B = D(:,ind_a);
B1 = nan(size(B,1),97);
for i = 1:97
   a = B(:,i);
   a = cellfun(@str2num,a);
   B1(:,i) = a;
   fprintf('ans #%d done\n',i);
end

% export answers
q = B1;
Q = array2table(q);
if size(Q,1) ~= size(A,1)
    error('reference score id not equal');
end

A.answers = [];
A = [A Q];
return

%% get user id
clear 
[pData,pSQL] = add_common_paths;
Data = readtable([pSQL,'/Life_user_user_scores.csv']);
load([pData,'/LA_master_20160111.mat'],'ANS');
% get only info contained in cleaned data LA_master_20160111.mat
[i,j] = ismember(ANS.score_id,Data.id);
k = j(i);
sid = Data.id(k);
if sum(ANS.score_id - sid) > 0
    error('scoreid match failed')
end
u = Data.user_id(k);
u1 = table;
u1.user_id = u;

% export
ANS = [u1 ANS];
save([pData,'/LA_master_20160111.mat'],'ANS');

%% add device_id, total and created at utc
clear 
[pData,pSQL] = add_common_paths;
Data = readtable([pSQL,'/Life_user_user_scores.csv']);
load([pData,'/LA_master_20160111.mat'],'ANS');
% get only info contained in cleaned data LA_master_20160111.mat
[i,j] = ismember(ANS.score_id,Data.id);
k = j(i);
sid = Data.id(k);
if sum(ANS.score_id - sid) > 0
    error('scoreid match failed')
end
ANS.user_id = [];
u1 = Data(k,:);
ANS_Info = u1;
save([pData,'/LA_master_20160111.mat'],'ANS','ANS_Info');


%% get only first and last answers
clear 
[pData,pSQL] = add_common_paths;
Data = readtable([pSQL,'/Life_user_user_scores.csv']);
load([pData,'/LA_master_20160111.mat']);

% get first answer
A = sortrows(ANS_Info,{'user_id','created_at_utc'});
d = [1;diff(A.user_id)];
ANS_First = ANS(d>0,:);

%% get only last answers
A = sortrows(ANS_Info,{'user_id','created_at_utc'});
d = [1;diff(A.user_id)];
d1 = find(d);
d2 = [d1(2:end); size(d,1)];
ANS_Last = ANS(d2,:);
save([pData,'/LA_master_20160111.mat'],'-append','ANS_Last','ANS_First');



%% USER INFORMATION
% get user info
clear
[pData,pSQL] = add_common_paths;
D = readtable([pSQL,'/Life_user_user_info.csv']);

% remove name and education
D.name = [];
D.education = [];

% make sure user_id is numeric
if isnumeric(D.user_id) ~= 1
    error('userid is not numeric')
end

% make sure user_id is contained in ANS
load([pData,'/LA_master_20160111.mat'],'ANS_Info');
i = ismember(D.user_id,ANS_Info.user_id);
n = sum(i);
fprintf('%d users have user information\n',n);
D(~i,:) = [];

% convert age to numeric
i = ismember(D.age,'NULL');
a = nan(size(D,1),1);
a(~i) = cellfun(@str2num,D.age(~i));
D.age = a;

% convert gender to numeric (M=1,female=0)
a = nan(size(D,1),1);
g = D.gender;
a(ismember(g,'M')) = 1;
a(ismember(g,'F')) = 0;
D.gender = a;

% report missing information
i = isnan(D.age) | isnan(D.gender);
n = sum(i);
fprintf('%d users did not have age or gender or both\n',n)

% add education from user's answers
load([pData,'/LA_master_20160111.mat'],'ANS');
a = ANS.q24;
a = a+1;
anskey = {'no high school', 'high school','post-secondary','masters','doctoral'};
Legend_Education = anskey';

% join education
T = table;
T.score_id = ANS_Info.id;
T.user_id = ANS_Info.user_id;
T.created_at_utc = ANS_Info.created_at_utc;
T.device_id = ANS_Info.device_id;

T1 = table;
T1.score_id = ANS.score_id;
T1.education = a;

T2 = innerjoin(T,T1);

% review duplicated answers
a = tabulate(T2.user_id);
a(a(:,2) == 0,:) = [];
u = a(a(:,2) > 1,1);
fprintf('%d users have entered more than one answer\n',numel(u));
invalN = 0;
for i = 1:numel(u);
    u1 = u(i);
    j = T2.user_id == u1;
    e = unique(T2.education(j));
    if numel(e) > 1 % if more than one education entered, remove
        T2.education(j) = nan;
        invalN = invalN + 1;
    end
end
fprintf('%d users have entered inconsistent education answer\n',invalN);

% put in education
D.education = nan(size(D,1),1);
% eliminate nan
T2(isnan(T2.education),:) = [];
% get only unique
[~,j] = unique(T2.user_id);
T2 = T2(j,:);
[i,j] = ismember(D.user_id,T2.user_id);
% D.education(i) = T2.education(j);
if sum(T2.user_id(j(i)) - D.user_id(i)) ~= 0
    error('error in matching')
end
D.education(i) = T2.education(j(i));
i = isnan(D.age) | isnan(D.gender) | isnan(D.education);
fprintf('%d users have full user info\n',sum(~i));

% save
User_Info = D;
save([pData,'/LA_master_20160111.mat'],'-append',...
    'Legend_Education','User_Info');


%% create Legend_Country
Legend_Country = readtable([pSQL,'/Life_global_countries.csv']);
p = '/Users/connylin/Dropbox/FB/Publication InPrep/Manuscript Lifestyle Paul/Data/FB201510061325_lifestylePaulRequest/countries-20140629.csv';
Legend_Country_Text = readtable(p);

[i,j] = ismember(Legend_Country.code,Legend_Country_Text.Code);
a = cell(size(Legend_Country,1),1);
a(i) = Legend_Country_Text.EnglishName(j(i));
Legend_Country.EnglishName = a;

% see which codes are missing english name
i = cellfun(@isempty,a);
% reference: http://dev.maxmind.com/geoip/legacy/codes/iso3166/
otherCodes = {'A2' 'Anonymous Poxy'
    'A1' 'Satellite Provider'
    'EU' 'European Union'
    'AP' 'Asia/Pacific Region'};
[i,j] = ismember(Legend_Country.code,otherCodes(:,1));
Legend_Country.EnglishName(i) = otherCodes(j(i),2);
save([pData,'/LA_master_20160111.mat'],'-append',...
    'Legend_Country');


%% Userinfo: country ID
clear
[pData,pSQL] = add_common_paths;
D = readtable([pSQL,'/Life_user_device_data.csv']);
D1 = table;
D1.device_id = D.id;
D1.country_id = nan(size(D1,1),1);
a = D.country_id;
i = ismember(a,'NULL');
sum(i)
b = cellfun(@str2num,a(~i));
D1.country_id(~i) = b;

% check device ID
load([pData,'/LA_master_20160111.mat'],...
    'User_Info','ANS_Info','Legend_Country');



%% see duplicate players and if they use different device and from different countries
A = table;
A.user_id = ANS_Info.user_id;
A.device_id = ANS_Info.device_id;
UI = unique(A,'rows');
a = tabulate(UI.user_id);
a(a(:,2) == 0,:) = [];
a = a(a(:,2) > 1,1);
fprintf('%d users have used more than one device\n',numel(a));
invalN = 0;
for i = 1:numel(a);
    u = a(i);
    j = UI.user_id == u;
    di = unique(UI.device_id(j));
    j = ismember(D1.device_id,di);
    cid = D1.country_id(j);
    cidu = unique(cid);
    if numel(cidu) > 1 % if more than one device id entered,
        [i,j] = ismember(cidu,Legend_Country.id);
        Legend_Country.EnglishName(j(i))
        UI(UI.user_id == u,:) = [];
        pause;
        invalN = invalN+1;
    end
end
fprintf('%d users with multiple device have entered inconsistent country location\n',invalN);

% add country id
UI = innerjoin(UI,D1);
a = nan(size(User_Info,1),1);
[i,j] = ismember(User_Info.user_id,UI.user_id);
a(i) = UI.country_id(j(i));
User_Info.country_id = a;

save([pData,'/LA_master_20160111.mat'],'-append',...
    'User_Info');


%% add user_id to ANS_Info
u = nan(size(ANS,1),1);
ANS_Info.score_id = ANS_Info.id;
ANS_Info.id = [];
A2 = outerjoin(ANS_Info,ANS);
ANS = table;
ANS.score_id = A2.score_id_ANS_Info;
A2.score_id_ANS_Info = [];
A2.score_id_ANS = [];
ANS = [ANS A2];
% save
save([pData,'/LA_master_20160111.mat'],'-append',...
    'ANS');





































