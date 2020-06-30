%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% ----------------------------

%% setting ++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
% ---------------

%% load data +++++++++++++
load(fullfile(pData,'Data.mat'),'Userinfo');
% ----------------------------

%% age ++++++
a = Userinfo.age;
b = tabulate(a);
T= table;
T.age = b(:,1);
T.n = b(:,2);
writetable(T,fullfile(pM,'age.csv'));
% -----------

%% age group +++ 
a = Userinfo.age;
a = floor(a./10).*10;
b = tabulate(a);
b(b(:,2)==0,:) = [];
%%
T= table;
T.age = b(:,1);
T.n = b(:,2);
writetable(T,fullfile(pM,'agegroup.csv'));

% -----------


