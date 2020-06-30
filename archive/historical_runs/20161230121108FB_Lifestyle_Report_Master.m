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


%% CLEAN UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% score = full score only -------------------------------------------------
fprintf('original answers N = %d\n',size(answers,1));
% get only full answers
answers = LifestyleData_fullAnswers(answers); 
fprintf('keeping only full answers N = %d\n',size(answers,1));
% --------------------------------------------------------------------------


%% user inclusion criteria ------------------------------------------------
fprintf('original users info N = %d\n',size(user_info,1));
U = user_info;
% exclude 
i = (U.age >= 90) | (U.age < 10) | ismember(U.gender,'NULL');
user_info(i,:) = [];
fprintf('left N = %d\n',size(user_info,1));
% --------------------------------------------------------------------------

%% get education information ------------------------------------------------
% education is question 24
D = regexpcellout(answers.answers,'(?<=i:)\d{1,}','match'); % take out answers from string

return
% --------------------------------------------------------------------------



%% remove users scores with not full score entries ------------------------------
fprintf('original users score N = %d\n',size(user_scores,1));
user_scores(~ismember(user_scores.id, answers.id),:) = [];
fprintf('after removing non full answers users score N = %d\n',size(user_scores,1));
% --------------------------------------------------------------------------


%% get last user scores ---------------------------------------------------
fprintf('original users score N = %d\n',size(user_scores,1));
U = user_scores(:,{'id','user_id','played_at_utc'});
U = sortrows(U,{'user_id','played_at_utc'},{'ascend','descend'});
i = [1;diff(U.user_id)];
j = i~=0;
i = ismember(user_scores.id, U.id(j));
user_scores = user_scores(i,:);
fprintf('keeping only last scores, users score N = %d\n',size(user_scores,1));
% --------------------------------------------------------------------------


%% get user information
fprintf('original users info N = %d\n',size(user_info,1));
U = user_info;
% exclude 
i = (U.age >= 90) | (U.age < 10) | ismember(U.gender,'NULL');
user_info(i,:) = [];

% get user id from scores
user_id = user_scores.user_id;
% check unique
if numel(unique(user_id)) ~= size(user_scores,1)
    error('duplicate user_id'); 
end
% get user info
[i,j] = ismember(user_id, U.user_id);
user_info_with_scores = U(i,:);


%% LS scores
answersArray = LifestyleData(answers, user_scores);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%% CREATE USER OBJECT
U = UserInfo;
U.user_info = user_info_with_scores;
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



















