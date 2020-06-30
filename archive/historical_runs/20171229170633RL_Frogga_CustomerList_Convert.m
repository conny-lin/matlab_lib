%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pData = '/Users/connylin/Dropbox/CA/FroggaBio/Customer List';

%% create save folder

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

%% CLEAN UP DATA

%% single cases fixes
Data.Institution(ismember(Data.Building,{'Sovereign Juice Co Inc.'})) = {'Sovereign Juice Co Inc.'};

%%
D = Data;

%% institution
unique(D.Institution)

universities = {'UBC'
        'UBCO'
        'UNBC'
        'UVic'
        'Vancouver Community College'
        'Vancouver Island Univesity'
        'University of the Fraser Valley'
        'SFU'};


    
%% UBC
UBC = D(ismember(D.Institution,'UBC'),:);
UBC.Building(ismember(UBC.Building,'FHN')) = {'FNH'};
UBC.Building(ismember(UBC.Building,'Pharmacology')) = {'Pharmaceutical'};
UBC.Building(ismember(UBC.Building,'Pharmacy')) = {'Pharmaceutical'};
UBC.Building(ismember(UBC.Building,'Pharmaceutical')) = {'CDRD'};
UBC.Building(ismember(UBC.Building,'Spinal Cord')) = {'ICORD'};
UBC.Building(ismember(UBC.Building,'Hospital')) = {'Detwiller'};
UBC.Building(ismember(UBC.Building,'McGavin')) = {'MCML'};
UBC.Building(ismember(UBC.Building,'GIP account')) = {''};
UBC.Building(ismember(UBC.Building,'St Pauls')) = {'St Paul'};
UBC.Building(ismember(UBC.Building,'VGH Research Pavillion')) = {'VGH'};

%%
UBC(ismember(UBC.Building,'Engineering'),:)

%%
b = unique(UBC.Building);


for i = 1:numel(b)
   j = ismember(UBC.Building,b(i));
   if isempty(b(i))
       savename = 'unkonwn';
   else
       savename = b{i};
   end
%    writetable(UBC(j,:),fullfile(pData,
   
    
    return
    
end

return






