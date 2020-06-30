%% OBJECTIVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get comparison between time within group 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SETTINGS
msrlist = {'curve','speed'};


%% DATA
pDataFolder = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/2-Wildtype/3-Results/Figures & Data/Fig2-1 Body Curve 60m 3 4 5 do/AssayAge/Dance_DrunkMoves';
datafilename = 'Dance_DrunkMoves.mat';
pData = fullfile(pDataFolder,datafilename);
load(pData,'MWTSet');
Data = MWTSet.Data_Plate;
VarRef_groupname = MWTSet.Info.VarIndex.groupname;


%% CYCLE BY MSRLIST
uniqueIDRef = {'groupname','mwtname','timeind'};

for msri = 1:numel(msrlist)
    
    msr = msrlist{msri}; % get variable name

    %% set up first table
    D = Data.(msr)(:,{'groupname','mwtname','timeind','frame_N','mean','SD','SE'}); % get data
    %%
    return
    D.groupname = VarRef_groupname(D.groupname); % replace groupname index to text
    %%
    
    
    %% Data transformation
    msr = msrlist{msri}; % get variable name
    D = Data.(msr)(:,{'groupname','mwtname','timeind','frame_N','mean','SD','SE'}); % get data
    D.groupname = VarRef_groupname(D.groupname); % replace groupname index to text
    
    
    %% rmANOVA, tukey between time
    [B,G1,AT,vn,rmu] = anovarm_convtData2Input(D,'timeind','groupname','mean','groupname')
    return

end


























