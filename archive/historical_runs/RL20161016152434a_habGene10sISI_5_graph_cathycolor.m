%  habituation curve 10sISI of valid experiments

%% INITIALIZING ===========================================================
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
pSaveM = fileparts(pM);
%% ========================================================================

%% SETTING ================================================================
% paths
pDataHome = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
pSave = create_savefolder(fullfile(pM,'Figure'));
% get strain names
strainlist = dircontent(pDataHome);
% strainlist(~ismember(strainlist,{'VG254'})) = [];

% other settings ----------------------------
msr = {'RevFreq'};
% -------------------------------------------
%% ========================================================================


%% make new graphs ========================================================
for si = 1:numel(strainlist)
    
    % report progress %------------
    fprintf(''); % separator
    processIntervalReporter(numel(strainlist),1,'strain',si);
    % ------------------------------
    
    % load data -----------------------
    strain = strainlist{si};
    p = fullfile(pDataHome,strain,'Dance_ShaneSpark4','Dance_ShaneSpark4.mat');
    load(p);
    % ---------------------------------
    
    % get graph data ----------------
    D = MWTSet.ByGroupPerPlate.RevFreq;
    y = D.Mean;
    e = D.SE;
    x = D.tap;
    gn = D.groupname;
    % -------------------------------
    
    % plot --------------------------
    Graph_HabCurveSS(x,y,e,gn,msr,pSave,'graphpack','cathy','graphname',strain);
    % --------------------------------
return    
end
%% ========================================================================















