
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Dance/Dance_RespType');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = pM;
addpath(fileparts(pM));
pData = fileparts(pM);
% ---------------------------

%% RECREATE PROBABILITY PLOT WITHOUT SPIKES
% load data -----
p = fullfile(pData,'matlab.mat');
load(p);

% ---------------

% settings %--------------------
% timelist = [95:10:29*10+95];
timelist = 100:10:(100+(29*10));
coli = [1:6:(30*6)];
% --------------------------------

%% extract only 0.1s data
glist = fieldnames(Out);
for gi = 1:numel(glist)
    gn = glist{gi};
end


%% plot errorbar across time (manual)
titlename = {'Wildtype 0mM','Wildtype 400mM'};
for gi = 1:numel(glist)
    % get group specific info ---------
    gn = glist{gi};
    % ---------------------------------
    
    % get data ---------------------
    d = Out.(gn);
    % ------------------------------
    
    % get variables -----------------------------
    y = d.mean(:,coli)';
    e = d.se(:,coli)';
    x = repmat(timelist,size(d.mean,1),1)';
    % ------------------------------------------
    
    % save figure ---------
    fig_pResp(pM,x,y,e,titlename{gi},gn)
    % ---------------------
end


% report done --------------
fprintf('\n--- Done ---\n\n' );
return
% --------------------------






























