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
% exclude age
i = (U.age >= 90);
i = (U.age < 10);
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
return

%% clean up user_info
U = user_info_with_scores;


agegroup_5yr = convertAge2AgeGroup_5yr(U.age);
T = makeAgexGenderTable(agegroup_5yr, U.gender);
writetable(T,'Table 1C - N gender by agegroup 5yr all age.csv');






















