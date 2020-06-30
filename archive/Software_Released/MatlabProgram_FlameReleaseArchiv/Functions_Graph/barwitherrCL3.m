%% OBJECTIVE: PRODUCE time dependent graph
%% INSTRUCTION
% modifited 20121203

%% CLEAN UP VARIABLES 
clearvars;

%% DEFINE PATHS
% get common paths
a = regexp(userpath,':','split'); cd(a{:,1}); PathCommonList; clearvars a;
% define 
pD = '/Users/connylinlin/Dropbox/Career Vivity Lab/Baseline SQL/Analysis Performance change x age/Data';
pO = '/Users/connylinlin/Dropbox/Career Vivity Lab/Baseline SQL/Analysis Performance change x age/Result';
pFunV = '/Users/connylinlin/Dropbox/Career Vivity Lab/Baseline SQL/Analysis Performance change x age/Matlab';
addpath(pFunV);


%% graphing
gameN = 12;
cd(pO);
load('Result.mat','Result');
for x = 1:gameN
    game = strcat('game',num2str(x));
    varargout = barwitherrCL2(Result.(game)(:,3),Result.(game)(:,1),...
        Result.(game)(:,2));
    titlename = game;
    savefigjpeg(titlename,pO);
end




























