%% path to standard functions

%% updated for Flame
userpath1 = '/Volumes/FLAME/MatlabProgram/';
% userpath1 = strrep(userpath,pathsep,'');
addpath([userpath1,'/Functions_General']); % add path to general functions


%% hard drives
paths.pRose = '/Volumes/Rose 3';
paths.pIronMan = '/Volumes/IRONMAN';
paths.pFlame = '/Volumes/FLAME/';

%% general function paths
paths.Fun.graph = [userpath1,'/Functions_Graph'];
paths.Fun.Java = '/Users/connylinlin/Documents/Programming/Java_Programs';


%% FIT BRAINS data paths
paths.FB.pHome = '/Users/connylinlin/Documents/Rosetta/FitBrains Research In House/Data Analysis/';
paths.FB.pData = [paths.FB.pHome,'SQL Analysis/Data'];
paths.FB.pOutput = [paths.FB.pHome,'SQL Analysis/Outputs'];
% Vivity lab functionp path
paths.FB.pFunVL = [userpath1,'/Functions_VivityLab'];

%paths.pDV = '/Users/connylinlin/Documents/Rosetta/FitBrains Research In House/Data Analysis/SQL Analysis/Data';



%% RNAseq
paths.pFunRNAseq = [userpath1,'/MATLAB RNAseq'];

%% MWT 
paths.MWT.pFun = [userpath1,'/Functions_MWT'];
paths.MWT.pSet = [paths.MWT.pFun,'/Settings'];
%paths.pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
%paths.MWT.pSave = '/Users/connylinlin/Documents/Lab/Lab Project & Data/Lab Data Matlab';
paths.MWT.pRepeatFiles = [paths.pFlame,'/MWT_RepeatFiles'];
paths.MWT.pBadFiles = [paths.pFlame,'/MWT_BadFiles'];
paths.MWT.pBadTap = [paths.pFlame,'/MWT_TapIncorrectFiles'];
% hard drive data paths
paths.MWT.pAWMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
paths.MWT.pRoseDataPick = '/Volumes/Rose/MWT_Analysis_20130811';
%paths.MWT.pRoseData = [paths.pRose,'/MWT_Analysis_20131020'];
paths.MWT.pFlameData = [paths.pFlame,'/MWT_Analysis_20131020'];
paths.MWT.pFlameSave = '/Volumes/FLAME/Analysis Output';


%% clear
clear userpath1;

