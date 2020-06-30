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
% restrict sources to product id = 1 =====================================
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'sources.mat');
A = load(p);
% ----------------

% restrict to product id = 1 ++++
A.email_id(A.product_id ~= 1,:) = [];
eid = A.email_id;
clear A;
% -------------------------------
% =========================================================================



% restrict emails to email_id from product 1 =============================
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'emails.mat');
A = load(p,'id','email');
A = struct2table(A);
% ----------------

% restrict to emails with profile id 1 ++++
A(~ismember(eid, A.id),:) = [];
Emails = A;
% -----------------------------------------
% =========================================================================



%% match lauren email  ====================================================
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'email_guid.mat');
A = load(p,'email');
A = struct2table(A);
% ----------------

% restrict email id list to lauren's email +++++++++
[i,j] = ismember(A.email,Emails.email);
k = j(i);
B = innerjoin(A,Emails);
% --------------------------------------------------
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
























