%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pData = '/Users/connylin/Dropbox/CA/FroggaBio/Customer List';


%% IMPROT DATA
% manually import:
% % Contacts1botanyzoology
% % Contacts2Wes
% % Contacts3James
% % CustomerMasterList
% Saved to 
% Data = CustomerMasterList;
% save(fullfile(pData,'Data.mat'),'Data');
load(fullfile(pData,'Data.mat'));

%% LIST CLEAN UP
a = Data.PI;
unique(a)

%%
% remove dr. 
% remove lab
% space
regexpcellout(a)

return






