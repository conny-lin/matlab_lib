%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
Gvar.pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
addpath(Gvar.pM);
cd(Gvar.pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% GLOBAL SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gvar.pDataFolder = '/Users/connylin/Dropbox/FB Collaboration RS Analysis zscore/get profile id 20161020';
cd(Gvar.pDataFolder);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get email id for lauren's emails ========================================
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'email_guid.mat');
Lauren = load(p);
Lauren.email = Lauren.emailguid(:,2);
% ----------------

% load data ++++++
p = fullfile(Gvar.pDataFolder, 'emails.mat');
FB = load(p);
% ----------------

% =========================================================================


% get email id from email id list =========================================
% =========================================================================

% match lauren email with user profile id +++++
% =========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%