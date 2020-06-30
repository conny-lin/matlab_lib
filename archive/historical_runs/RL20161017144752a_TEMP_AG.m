


%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
% get strain info
s = dircontent(pData);
strainNames = DanceM_load_strainInfo(s);
strainlist = strainNames.strain;
%----------------

%% Organize
for si = 1:numel(strainlist)
    
    % report progress +++++
    fprintf(''); % separator
    processIntervalReporter(numel(strainlist),1,'strain',si);
    % ---------------------

    % strain specific data % +++++
    strain = strainNames.strain{si}; 
    pstrain = fullfile(pData,strain);
    % ----------------------------
    
    %% files
    dircontent(pstrain)
    
    
    return
end
























