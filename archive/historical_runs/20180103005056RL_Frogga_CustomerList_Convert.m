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
Data.Building = regexprep(Data.Building,'[(]|[)]|[/]',' ');
Data.Institution(ismember(Data.Institution,'Trinity Western University')) = {'TRU'};


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

b = unique(UBC.Building);
for ib = 1:numel(b)
   if isempty(b{ib})
       savename = 'UBC unkonwn';
   else
       savename = ['UBC ', b{ib}];
   end
   j = ismember(UBC.Building,b{ib});
   UData = UBC(j,:);
   UData = sortrows(UData,{'Institution','Building','PI','Labcontact'});
   writetable(UData,fullfile(pM,[savename,'.csv']));
end

%% universities
universities = {'UBCO'
        'UNBC'
        'UVic'
        'TRU'
        'Vancouver Community College'
        'Vancouver Island Univesity'
        'University of the Fraser Valley'
        'SFU'};
    

for ui = 1:numel(universities)
    u = universities{ui};
    UData = D(ismember(D.Institution,u),:);
    b = unique(UData.Building);
    for ib = 1:numel(b)
       if isempty(b{ib})
           savename = [u, ' unkonwn'];
       else
           savename = [u, ' ',b{ib}];
       end
       j = ismember(UData.Building,b{ib});
       writetable(UData(j,:),fullfile(pM,[savename,'.csv']));
    end
end



%% non u
nonuniversities = D.Institution(~ismember(D.Institution,[universities;{'UBC'}]));
nonuniversitiesu = unique(nonuniversities);

UData = D(ismember(D.Institution,nonuniversitiesu),:);
UData = sortrows(UData,{'Institution','Building','PI','Labcontact'});
writetable(UData,fullfile(pM,['non-universities','.csv']));




return

































return






