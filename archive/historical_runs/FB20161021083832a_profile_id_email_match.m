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
cd(Gvar.pDataFolder);seq
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% restrict sources to product id = 1 =====================================
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'sources.mat');
A = load(p);
% ----------------

% restrict to product id = 1 ++++



return
% =========================================================================

%% find emails at 
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'emails.mat');
FB = load(p);
% ----------------

%%
% get email id for lauren's emails ========================================
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'email_guid.mat');
A = load(p);
Lauren = table;
Lauren.guid = A.emailguid(:,1);
Lauren.email = A.emailguid(:,2);
Lauren.hc = A.emailguid(:,3);
clear A;
% ----------------

% match ++++++++
% [i,j] = ismember(FB.email, Lauren.email);
% k= j(i);
% k(1:10)
[i,j] = ismember(Lauren.email,FB.email);
k2 = j(i);
k2(1:10)
Lauren.emailID = k2;
% ----------------

% clear memory +++++++
clear FB p k2 i j;
% ------------------
% =========================================================================


%% get email id from email id list =========================================

% load data ++++++
p = fullfile(Gvar.pDataFolder, 'users.mat');
FBusers = load(p);
% ----------------

% match data ++++++++++
[i,j] = ismember(Lauren.emailID, FBusers.email_id);
k = (j(i));
Lauren.userID = zeros(size(Lauren.emailID,1),1);
Lauren.userID(i) = FBusers.id(k);
% ----------------


% clear memory +++++++
clear FBusers p k i j;
% ------------------

% =========================================================================

%% export ++++++++++
cd(Gvar.pDataFolder);
writetable(Lauren,'email_profileid_match.csv');
% -------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
























