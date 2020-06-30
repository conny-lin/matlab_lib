
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
CurvePValue = nan(size(strainNames,1),6);

for strain_i = 1:size(strainNames,1)
    strain = strainNames.strain{strain_i}; % get strain name
    load(sprintf('%s/%s',pData,strain), 'StatOut'); % load data
    % get comparison array
    pairNames = {'N2';'N2_400mM';strain;[strain,'_400mM']};
    CompArray = pairwisecomp_getpairs(pairNames);
    
    
    % curve pvalue
    S = StatOut.t28_30.mcomp_g;
    pV = nan(1,size(CompArray,1));
    for ci = 1:size(CompArray)
        i = ismember(S.groupname_1, CompArray(ci,1)) & ...
            ismember(S.groupname_2, CompArray(ci,2));
        pV(ci) = S.pValue(i);
    end
    CurvePValue(strain_i,:) = pV;
    
    
    %% pair wise t comparison
    % t1-5 larger than t0
    S = StatOut.t28_30.mcomp_t_g;
    pV = nan(numel(pairNames),5);
    for pairi = 1:numel(pairNames)
        gn = pairNames(pairi);
        i = ismember(S.groupname, gn) &...
            S.t_1 == 0 & ...
            ismember(S.t_2, 1:5);
        % get pvalue
        pv = S.pValue(i)';
        
        % add negative sign
        k = S.Difference(i) < 0;
        pv(k) = pv(k).*-1;
        pV(pairi,:) = pv;
        
        
        
    end
    pVrs = reshape(pV,1,numel(pV));
    
    return
    
    
end

%% pair-wise t0 vs t1-5





%% output table
colNames = {'WT0xWT4'    
    'WT0xMT0'
    'WT0xMT4'
    'WT4xMT0'      
    'WT4xMT4'
    'MT0XMT4'};
T = array2table(CurvePValue,'VariableNames',colNames);
T = [strainNames T];

cd(pM); writetable(T,'curve sig summary.csv');



    



