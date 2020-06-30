
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

% data source
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/4-STH genes/3-EARS/Data/ephys_accpeak_graph2_stats';

%% get strain info
% get strains
fn = dircontent(pData);
a = regexpcellout(fn,'[A-Z]{2,}\d{3,}','match');
a(cellfun(@isempty,a)) = [];
strain_name_list = unique(a);

% get strain info
load('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/MWTDatabase/StrainNames.mat');
strainNames(~ismember(strainNames.strain,strain_name_list),:) = [];

% clear memory
clear fn a strain_name_list;


%% Curve summary
EmptyArray = nan(size(strainNames,1));


%%
CurvePValue = nan(size(strainNames,1),6);

for strain_i = 1:size(strainNames,1)
    strain = strainNames.strain{strain_i}; % get strain name
    load(sprintf('%s/%s',pData,strain), 'StatOut'); % load data
    S = StatOut.t28_30.mcomp_g;
    % get comparison array
    pairNames = {'N2';'N2_400mM';strain;[strain,'_400mM']};
    CompArray = pairwisecomp_getpairs(pairNames);
    
    %%
    pV = nan(1,size(CompArray,1));
    for ci = 1:size(CompArray)
        i = ismember(S.groupname_1, CompArray(ci,1)) & ...
            ismember(S.groupname_2, CompArray(ci,2));
        pV(ci) = S.pValue(i);
    end
    CurvePValue(strain_i) = pV;
    
end

%% output table
    colNames = {'WT0xWT4'    
    'WT0xMT0'
    'WT0xMT4'
    'WT4xMT0'      
    'WT4xMT4'
    'MT0XMT4'};
    



