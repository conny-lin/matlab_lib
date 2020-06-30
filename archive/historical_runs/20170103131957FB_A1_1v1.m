%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% objective;
% 1.1. investigating how initial performance outcomes in emotion training
% games are correlated with demographic (age, gender, education) factors

load('/Users/connylin/Dropbox/Publication/Report FB MITACS EQ and Lifestyle/Data/Data_A1_1.mat');
%% exclude 
% scores = 0
score(score.score == 0,:)= [];

%% transform gender and education to numeric values
U = demographic(:,{'profile_id','age','gender','education'});

load('/Users/connylin/Dropbox/Code/Matlab/Library FB/Modules/Variable Legends/legend_gender.mat')
[i,j] = ismember(U.gender,legend_gender_table.letter);
U.gender = legend_gender_table.id(j);

load('/Users/connylin/Dropbox/Code/Matlab/Library FB/Modules/Variable Legends/legend_education.mat')
[i,j] = ismember(U.education,legend_education_table.database);
U.education = legend_education_table.id(j);




%% find first score
gid_list = unique(score.game_id)';
for gid = gid_list
    D = score(score.game_id==gid,{'id','profile_id','played_at_utc','score'});
    D = sortrows(D,{'profile_id','played_at_utc'});
    i = D.id([1;diff(D.profile_id)] >0);
    A = innerjoin(U,D(:,{'id','profile_id','score'}),'Key','profile_id');
    FirstScore.(['game',num2str(gid)]) = A;
end

%% correlation 
iv = {'age','gender','education'};


%%
gid_list = unique(score.game_id)';
for gid = gid_list
    for ivi = 1:numel(iv)
        A = FirstScore.(['game',num2str(gid)]);
        x = A.(iv{ivi});
        y = A.score;
        [rho,pval] = corr(x,y);
        f = scatter(x,y);
        title(sprintf('game %d, rho=%.3f, p=%d',gid,rho,pval));
        xlabel(iv{ivi});
        ylabel('score');
        savename = sprintf('game%d score x %s scatter',gid,iv{ivi});
        printfig(savename,pM,'w',5,'h',5)
    end
    
    
    
end

























