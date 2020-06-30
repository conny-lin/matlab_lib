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
clear A;
% -----------------------------------------


% =========================================================================



%% match lauren email  ====================================================
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'email_guid.mat');
A = load(p,'email');
A = struct2table(A);
% ----------------

return
% restrict email id list to lauren's email +++++++++
[i,j] = ismember(A.email,Emails.email);
k = j(i);
B = innerjoin(A,Emails);
% ----------------------------------------------------


% join ++++++++++++++
T = table;
T.email_lauren = B.email;
T.email_id = B.id;
% -------------------

% clear memory +++++
clear B A i j k p
% ------------------
% =========================================================================


%% match email id in user table  ====================================================
% load data ++++++
p = fullfile(Gvar.pDataFolder, 'users.mat');
A = load(p,'id','email_id');
A = struct2table(A);
% ----------------

% join ++++++++++++++
T = table;
T.email_lauren = B.email;
T.email_id = B.id;
% -------------------

% =========================================================================


return
%% export ++++++++++
cd(Gvar.pDataFolder);
writetable(Lauren,'email_profileid_match.csv');
% -------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
























