%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths & settings -----------
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
% ---------------------------

% strains %------
pDataHome = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/2-Wildtype/3-Results/0-Data/10sISI Food 400mM';
%----------------

% time settings
taptimes = [100:10:(10*29+100)];
% ------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% raster ==================================================================
% create save path +++++++++++++++++++
pSave = fullfile(pDataHome,'Raster');
% -----------------------------------

% load mwt paths +++++++++++++++++++
load(fullfile(pData,'MWTDB.mat'));
% check if all MWTDB are dir
i = cellfun(@isdir,MWTDB.mwtpath);
if sum(i) ~= numel(i)
   MWTDB(~i,:) = [];
   if isempty(MWTDB)
       error('no data');
   end
end
% ---------------------------------- 

% dance raster ++++++++++++++++
if ~isempty(MWTDB)
    Dance_Raster(MWTDB,'pSave',pSave,'graphopt',0);
end
% ----------------------------
% =========================================================================


%% TAR ====================================================================
% create save path +++++++++++++++++++
pSave = create_savefolder(fullfile(pDataHome,'TAR'));
% -----------------------------------

% data path +++++++++++++++++++
pData = fullfile(pDataHome,'Raster/Dance_Raster');
% ------------------------------

% Dance_rType ++++++++++++++
Data = Dance_rType(pData,'pSave',pSave);
% -------------------------

%% make a copy of the files ++++
pGraph = create_savefolder(fullfile(pM,'Graph'));
pGS = fullfile(pSave,'Dance_rType','AccProb.pdf');
pGD = fullfile(pGraph,[strain,' AccProb.pdf']);
copyfile(pGS,pGD);

pGS = fullfile(pSave,'Dance_rType','AccProb RMANOVA.txt');
pGD = fullfile(pGraph,[strain,' AccProb RMANOVA.txt']);
copyfile(pGS,pGD);

%% -------------------
    
% end


