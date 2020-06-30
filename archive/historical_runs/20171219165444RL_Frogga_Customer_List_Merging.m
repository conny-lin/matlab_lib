%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pData = '/Users/connylin/Dropbox/CA/Fraggo/Customer List Merging';


%% IMPROT DATA
% manually import:
% % Contacts1botanyzoology
% % Contacts2Wes
% % Contacts3James
% % CustomerMasterList
% Saved to 
% save('Data.mat','Contacts1botanyzoology','Contacts2Wes','Contacts3James','CustomerMasterList');
cd(pData);
load('Data.mat','Contacts1botanyzoology','Contacts2Wes','Contacts3James','CustomerMasterList');

%% CustomerMasterList
% clean up
A = CustomerMasterList;
% correct format
A.Phone(cellfun(@isnumeric,A.Phone)) = {''};
% delete empty data
a = cellfun(@isempty,table2cell(A(:,2:end)));
ncol = size(A,2)-1;
A(sum(a,2) == ncol,:) = [];


%% Contacts1botanyzoology
B = Contacts1botanyzoology;
C = outerjoin(A,B,'MergeKeys',1);


%% Contacts2Wes
D = Contacts2Wes;
%% merge first and last name
% Labcontact = strjoinrows(

%% Contacts3James














