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
msr = 'RevFreq';
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
    D1(:,:,1) = x;
    D1(:,:,2) = y;
    D1(:,:,3) = e;
    % sort by N2
    gns = sortN2first(gn',gn');
    [i,j] = ismember(gn,gns);
    D1 = D1(:,j,:);
    X = D1(:,:,1);
    Y = D1(:,:,2);
    E = D1(:,:,3);
    % -------------------------------
    
    % plot --------------------------
    Graph_HabCurveSS(X,Y,E,gn,msr,pSave,'graphpack','cathy','graphname',strain);
    % --------------------------------
return    
end
%% ========================================================================
















