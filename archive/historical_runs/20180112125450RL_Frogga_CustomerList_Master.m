%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pData = '/Users/connylin/Dropbox/CA/FroggaBio/Customer/Customer List/Source data';
load(fullfile(pData,'CustomerList.mat'));

%% EXTRACT FROM EACH LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TM = table; % master table;

% master list
T = extract_info_from_list(MasterList,{'Leads','Model','Researchfocus','Notes'});
TM = [TM;T];

% Contacts1botanyzoology
A = Contacts1botanyzoology;
A.Institution = repmat({'UBC'},size(A,1),1);
A.Building = repmat({'Botany Zoology'},size(A,1),1);
A.Room = repmat({''},size(A,1),1);
A.Address = repmat({''},size(A,1),1);
A.City = repmat({'Vancouver'},size(A,1),1);
T = extract_info_from_list(A,{'Notes'});
TM = [TM;T];

% Contacts2Wes
A = Contacts2Wes;
T = table;
T.Institution = A.Institution;
T.Building = repmat({''},size(A,1),1);
T.Room = repmat({''},size(A,1),1);
T.PI = repmat({''},size(A,1),1);
T.Name = strjoinrows(A(:,{'FirstName','LastName'}),' ');
T.Email = A.Email;
T.Phone = A.Phone;
T.Address = A.Address;
T.City = A.PrimaryCity;
T.Notes = repmat({''},size(A,1),1);
TM = [TM;T];

% Contacts3James
A = Contacts3James;
T = table;
T.Institution = A.Institution;
T.Building = A.Building;
T.Room = A.Room;
T.PI = A.PI;
T.Name = A.Labcontact;
T.Email = A.Email;
T.Phone = A.Phone;
T.Address = A.Address;
T.City = A.City;
T.Notes = repmat({''},size(A,1),1);
TM = [TM;T];


% customersBC
A = customersBC;
T = table;
T.Institution = repmat({''},size(A,1),1);
T.Building = repmat({''},size(A,1),1);
T.Room = repmat({''},size(A,1),1);
T.PI = repmat({''},size(A,1),1);
a = A.Name;
a = regexprep(a,'Mr\s{1}|Ms\s{1}|Dr\s{1}','');
T.Name = a;
T.Email = A.Email;
T.Phone = repmat({''},size(A,1),1);
T.Address = repmat({''},size(A,1),1);
T.City = repmat({''},size(A,1),1);
T.Notes = repmat({''},size(A,1),1);
TM = [TM;T];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% CLEAN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adjust PI name ----------------------------------------------------------
a = TM.PI;
b = regexpcellout(a,'\s|[(]|[)]','split');
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


% -------------------------------------------------------------------------
% merge
% remove duplicates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



















