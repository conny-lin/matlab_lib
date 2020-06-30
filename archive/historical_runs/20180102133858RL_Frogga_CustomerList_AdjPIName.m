%% CLEAN CUSTOMER LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SHARED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pHome = '/Users/connylin/Dropbox/CA/FroggaBio/Customer List';
fnameData = 'Frogga_CustomerList_Cleaned';
pData = fullfile(pHome,fnameData);
% get customer list
[fcustomerlist,pcustomerlist] = dircontent(pData,'*csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLEAN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ci = 34%1:numel(fcustomerlist)
    filename = fcustomerlist{ci};
    fprintf('\n* evaluating file %s\n',filename);
    
    if ~strcmp(filename,'nonuniversities.csv')
        D = importfile_cleaned(filename);
    else
        D = importfile_cleaned_nonu(filename);
    end
    %% get PI name
    a = D.PI;
    regexpcellout(a,'\s','split')
    
    return
end