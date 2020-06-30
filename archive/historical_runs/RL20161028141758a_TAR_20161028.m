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


%% cycle through strain ===================================================
% for si = 1:size(strainNames.strain,1)
%     % strain info +++++
%     strain = strainNames.strain{si};
%     genotype = strainNames.genotype{si};
%     % ------------------
    
%     % report progress %------------
%     fprintf('%s\n',strain); % separator
%     processIntervalReporter(size(strainNames.strain,1),1,'*** strain ****',si);
    % ------------------------------
   
% create save path +++++++++++++++++++
pSave = create_savefolder(fullfile(pDataHome,'TAR'));
% -----------------------------------

% data path +++++++++++++++++++
pData = fullfile(pDataHome,'Raster/raster colorspeed');
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


