%% CONVERT TO JAMES FORMAT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SHARED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pHome = '/Users/connylin/Dropbox/CA/FroggaBio/Customer List';
fnameData = 'Frogga_CustomerList_Convert';
pData = fullfile(pHome,fnameData);
% get customer list
[fcustomerlist,pcustomerlist] = dircontent(pData);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET JAMES FORMET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% manually import headings
% TableVarNames = CustomerListTemplate.Properties.VariableNames;
% 'Floor'
% 'Room'
% 'PI'
% 'LabContact'
% 'Email'
% 'Phone'
% 'Leads'
% 'ReferenceEquipmentReference'
VarAdd = {'FroggaFT'
'LGFTTips'
'Conicals'
'mL'
'Serologicals'
'DL'
'PL'
'FroggaMix'
'SYBR'
'RedSafe'
'Geneaid'
'SyringeF'
'Cryovial'};
VarAddConvt = {
'FroggaFT', 'FroggaFT';
'filter tips', 'LGFTTips';
'LGFTTips', 'LGFTTips';
'Conicals', 'Conicals';
'1.7ml','mL';
'Serologicals', 'Serologicals';
'DL', 'DL';
'PL', 'PL';
'FroggaMix', 'FroggaMix';
'SYBR', 'SYBR';
'RedSafe', 'RedSafe';
'Geneaid', 'Geneaid';
'SyringeF', 'SyringeF';
'Cryovial', 'Cryovial'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMPORT LIST AND CONVERT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ci = 1:numel(pcustomerlist)
    % get file name
    filename = fullfile(pcustomerlist{ci});
    % load table
    D = importfile_froggacustomerlist(filename);
    % convert to james format
    D1 = D(:,{'Floor','Room','PI','Labcontact','Email','Phone','Leads','ReferenceEquipmentReference'});
    % fill room number as ? if empty
    room = D1.Room;
    room(cellfun(@isempty,D1.Room)) = {'?'};
    % get room number first digit
    a = regexpcellout(room,'[0-9]','match');
    room1digit = a(:,1);
    % check if no floor, room number first digit
    i = cellfun(@isempty,D1.Floor);
    % put in 1st digit room number for missing floors
    D1.Floor(i) = room1digit(i);
    % see how many floors
    flooru = unique(D1.Floor);
    % create master cell
    CMaster = cell(numel(flooru),1);
    %% go by floor
    for floori = 1:numel(flooru)
        % index to floor
        floor = flooru(floori);
        floorind =ismember(D1.Floor,floor);
        % get floor data
        D1F = D1(floorind,:);
        % find data on products
        prod = D.Productsinuse(floorind);
        [i,j] = ismember(prod,VarAddConvt(:,1));
        prodName = repmat({''},numel(prod),1);
        prodName(i) = VarAddConvt(j(i),2);
        % create cell array for products
        nrow = size(D1F,1);
        ncol = numel(VarAdd);
        C = cell(nrow,ncol);
        % mark x to products
        [i,j] = ismember(prodName,VarAdd);
        i= sub2ind(size(C),find(i),j(j>0));
        C(i) = {'x'};
        % create james product table
        T = cell2table(C,'VariableNames',VarAdd);
        % combine
        D2 = [D1F T];
        % sort by room, PI
        D2 = sortrows(D2,{'Room','PI'});
        %% add
        if floori>1
            D3 = [D3;D2];
        else
            D3 = D2;
        end
    end
    %% save as adjusted list
    savename = fullfile(pM,fcustomerlist{ci});
    writetable(D3,savename)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% XXXXX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






























