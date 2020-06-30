%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false);
% addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% objective;
% 1.1. investigating how initial performance outcomes in emotion training
% games are correlated with demographic (age, gender, education) factors

load('/Users/connylin/Dropbox/Publication/Report FB MITACS EQ and Lifestyle/Data/Data_A1_1.mat');
%% exclude 
% scores = 0
score(score.score == 0,:)= [];


%% find first score
U = demographic(:,{'profile_id','age','gender','education'});
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
gid_list = unique(score.game_id)';
for gid = gid_list
    A = FirstScore.(['game',num2str(gid)]);
    x = A.age;
    y = A.score;
    [rho,pval] = corr(x,y);
    f = scatter(x,y);
%     printfig
    
    return
    
    
end

























