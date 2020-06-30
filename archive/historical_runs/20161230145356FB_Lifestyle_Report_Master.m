%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pData = '/Users/connylin/Dropbox/FB/Database/LifeAssessment_20161212/LS_user.mat';
addpath('/Users/connylin/Dropbox/Publication/Manuscript FB Lifestyle Paul/Data 201612/Functions')
addpath('/Users/connylin/Dropbox/Publication/Manuscript FB Lifestyle Paul/Data/Code');
pLegend = '/Users/connylin/Dropbox/Code/Matlab/Library FB/Modules/Variable Legends';
% load data
load(pData)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% CLEAN UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% score = full score only -------------------------------------------------
fprintf('original answers N = %d\n',size(answers,1));
% get only full answers
[answers, score_id_bad] = LifestyleData_fullAnswers(answers); 
fprintf('keeping only full answers N = %d\n',size(answers,1));
% --------------------------------------------------------------------------

% delete non full answers -------------------------------------------------
user_scores(ismember(user_scores.id, score_id_bad),:) = [];
% --------------------------------------------------------------------------

% get last user scores ---------------------------------------------------
fprintf('original users score N = %d\n',size(user_scores,1));
U = user_scores(:,{'id','user_id','played_at_utc'});
U = sortrows(U,{'user_id','played_at_utc'},{'ascend','descend'});
i = [1;diff(U.user_id)];
j = i~=0;
i = ismember(user_scores.id, U.id(j));
user_scores = user_scores(i,:);
fprintf('keeping only last scores, users score N = %d\n',size(user_scores,1));
% --------------------------------------------------------------------------


% user inclusion criteria ------------------------------------------------
fprintf('original users info N = %d\n',size(user_info,1));
U = user_info;
% exclude 
i = (U.age >= 90) | (U.age < 10) | ismember(U.gender,'NULL');
user_info(i,:) = [];
fprintf('left N = %d\n',size(user_info,1));
% --------------------------------------------------------------------------


% merge answers score id with user info ----------------------------------
user_profile = innerjoin(user_scores, user_info,'Key','user_id');
user_profile.score_id = user_profile.id;
user_profile.id = [];
% --------------------------------------------------------------------------

% keep scores with user profile --------------------------------------------------
user_profile = innerjoin(user_profile,answers,'Key','score_id');
% --------------------------------------------------------------------------


% get education information ------------------------------------------------
load(fullfile(pLegend,'legend_education.mat'));
% education is question 24
a = regexpcellout(user_profile.answers,'(?<=i:23;i:)\d{1}','match'); % take out answers from string
a = cellfun(@str2num,a);
a = a+1;
user_profile.education = legend_education_table.name(a);
% --------------------------------------------------------------------------

% LS scores --------------------------------------------------------------
D = convert_Lifestyle_to_Array(user_profile.answers);
% --------------------------------------------------------------------------

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% CREATE USER OBJECT
U = UserInfo;
U.user_info = user_profile;
U.devices = devices;
U.device_data = device_data;


%% Table1: age x gender table 
T = age_gender_table(U,5);
writetable(T,...
    fullfile(pM,'Table 1 - N gender x agegroup 5yr.csv'),...
    'WriteRowNames',1);


%% TABLE2: country 
T = country_table(U);
writetable(T,fullfile(pM,'Table 2 - countries.csv'));



%% TABLE3: AGE X EDUCATION
user_profile.agegroup = convertAge2AgeGroup(user_profile.age);
T = crosstab_table2(user_profile.agegroup,user_profile.education);
writetable(T,...
    fullfile(pM,'Table 3 - N education x agegroup 10yr.csv'),...
    'WriteRowNames',1);


%% TABLE4: yes/no answer summary
load(fullfile(pLegend,'ind_LS_q_binary.mat'));
D_binary = D(:,Index_YesNoQuestions) ==1;
% pct
T = table;
load(fullfile(pLegend,'legend_LS_questions.mat'), 'Legend_questions_table');
T.q = Legend_questions_table.shorter(Index_YesNoQuestions);
% all age
n = size(D_binary,1);
T.All = sum(D_binary==1)'./n;
% female
n = sum(ismember(user_profile.gender,'F'));
a = sum(ismember(user_profile.gender,'F') & D_binary==1);
T.F = (a./n)';
% male
n = sum(ismember(user_profile.gender,'M'));
a = sum(ismember(user_profile.gender,'M') & D_binary==1);
T.M = (a./n)';
% age group
for age = 10:10:80
    n = sum(user_profile.agegroup == age);
    a = sum(user_profile.agegroup == age & D_binary==1);
    T.(['age',num2str(age)]) = (a./n)';
end
writetable(T,...
    fullfile(pM,'Table 4 - binary answers.csv'));

%% TABLE5: MC answer summary
load(fullfile(pLegend,'ind_LS_q_MC.mat'),'Index_MultipleChoiceQuestions');
Index_MultipleChoiceQuestions(24) = false; % get rid of education question
D_MC = D(:,Index_MultipleChoiceQuestions);
load(fullfile(pLegend,'legend_LS_answers.mat'), 'Legend_Answers')
LAns = Legend_Answers(Index_MultipleChoiceQuestions,:);
load(fullfile(pLegend,'legend_LS_questions.mat'), 'Legend_questions_table');
LQ = Legend_questions_table.shorter(Index_MultipleChoiceQuestions);

for q = 1:size(D_MC,2)
   a = D_MC(:,q);
   atxtref = LAns(q,:);
   a = atxtref(a)';
   n = size(D_MC,1);
   b = tabulate(a);
   c = cell2mat(b(:,3))./100;
   
   T = table;
   T.Answers = b(:,1);
   T.All = c;
   
   % female/male
   T1 = crosstab_table2(a,user_profile.gender);
   T.F = T1.F;
   T.M = T1.M;
   
    % age group
   T1 = crosstab_table2(a,user_profile.agegroup);
   T = [T T1];

    writetable(T,fullfile(pM,sprintf('Table 5-%d - %s.csv',q,LQ{q})));

end




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
save(fullfile(pM,'data.mat'),'user_profile','D')















