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


%% create user object 
U = UserInfo;
U.age = user_info_with_scores.age;
U.gender = user_info_with_scores.gender;
U.education = user_info_with_scores.education;
U.user_id = user_info_with_scores.user_id;

%% make user table
T = age_gender_table(U,5);
writetable(T,fullfile(pM,'Table 1 - N gender x agegroup 5yr.csv'));






















