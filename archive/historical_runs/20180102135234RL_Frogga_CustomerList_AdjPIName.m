%% CLEAN CUSTOMER LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SHARED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pHome = '/Users/connylin/Dropbox/CA/FroggaBio/Customer List';
fnameData = 'Frogga_CustomerList_Clean';
pData = fullfile(pHome,fnameData);
% get customer list
[fcustomerlist,pcustomerlist] = dircontent(pData,'*csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLEAN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ci = 1:numel(fcustomerlist)
    filename = fcustomerlist{ci};
    fprintf('\n* evaluating file %s\n',filename);
    
    if ~strcmp(filename,'nonuniversities.csv')
        D = importfile_cleaned(filename);
    else
        D = importfile_cleaned_nonu(filename);
    end
    %% get PI name
    a = D.PI;
    b = regexpcellout(a,'\s|[(]|[)]','split');
    if size(b,2) > 2
        n = sum(cellfun(@isempty,b),2);
        ni = size(b,2)-2;
        i = n == ni;
        % get rid of ones with comma
        j = regexpcellout(b,'[,]');
        i(j) = false;
        % combine
        c = b(i,1:2);
        d = strjoinrows(c(:,[2 1]),', ');
        e = regexprep(d,'^,{1}\s{1}','');
        a(i) = e;
        D.PI = a;
    end
    writetable(D,fullfile(pM,filename));
    
end