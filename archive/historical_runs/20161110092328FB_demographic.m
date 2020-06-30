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
load(fullfile(pData,'Data.mat'));
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
T= table;
T.age = b(:,1);
T.n = b(:,2);
writetable(T,fullfile(pM,'agegroup.csv'));

% -----------

%% gender +++ 
a = Userinfo.gender;
a = tabulate(a);
leg = cell(size(a,1),1);
leg(a(:,1) == 2) = {'unknown'};
leg(a(:,1) == 1) = {'male'};
leg(a(:,1) == 0) = {'female'};

T= table;
T.gender = leg;
T.n = a(:,2);
T.percent = a(:,2)./sum(a(:,2));
writetable(T,fullfile(pM,'gender.csv'));
% -----------


%% country +++ 
a = Userinfo.countrycode;
a(cellfun(@isempty,a)) = {'N/A'};
b = tabulate(a);

T= table;
T.countrycode = b(:,1);
T.n = cell2mat(b(:,2));
T.percent = cell2mat(b(:,3));
writetable(T,fullfile(pM,'country.csv'));
% -----------


%% education +++++
e1 = Userinfo.education;
b = tabulate(e1);
T = table;
T.education = legend_education_table.name(1:end-1);
T.n = b(:,2);
T.percent = b(:,3);
writetable(T,fullfile(pM,'education.csv'));
% ----------------


%% marital status +++++
leg = legend_LS_QAscore(legend_LS_QAscore.qid ==1,:);

a = LS_AnsIDu(:,1);

b = tabulate(a);


T = table;
T.marital_status = leg.statement;
T.n = b(:,2);
T.percent = b(:,3);
writetable(T,fullfile(pM,'marital_status.csv'));
% ----------------




return





















