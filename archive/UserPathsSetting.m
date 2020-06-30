% path to standard functions
%% UserPathsSetting
userpath('/Users/connylinlin/Documents/Programming/MATLAB');
USERPATH = strrep(userpath,pathsep,''); cd(USERPATH);

%% ADD SEARCH PATHS

% MWT MATLAB program paths
addpath([USERPATH,'/MATLAB MWT']);

% common function paths
addpath([USERPATH,'/Functions_General']);


%% SAVE STANDARD SEARCH PATHS
cd(USERPATH);
savepath pathdef.m;


%% hard drives
% pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
% pRosePick = '/Volumes/Rose/MWT_Analysis_20130811';
% pIronMan = '/Volumes/IRONMAN';

% 
% %% MWT functions
% pFun = [userpath,'/MATLAB MWT'];
% 
% %% general paths
% pFunG = [userpath1,'/Functions_General'];
% addpath(pFunG); 
% 
% %% function paths
% path.pFunG = [userpath1,'/Functions_Graph'];
% path.pFunVL = [userpath1,'/Functions_VivityLab'];
% path.pDV = '/Users/connylinlin/Documents/Career Vivity Lab/SQL Analysis/Data';
% 
% %% RNAseq
% path.pFunRNAseq = [userpath1,'/MATLAB RNAseq'];
% 
% %% MWT 
% path.pSet = [userpath1,'/MATLAB MWT/MatSetfiles'];
% path.pFunMWT = [userpath1,'/MATLAB MWT'];
% path.pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
% path.pSave = '/Users/connylinlin/Documents/Lab/Lab Project & Data/Lab Data Matlab';
% 

