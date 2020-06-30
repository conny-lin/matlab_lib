
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

% data source
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/Summary v3/Graph and stats/ephys_accpeak_graph_vbm/mat files';
pGraphData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/Summary v3/Graph and stats/ephys_accpeak_graph_vbm/Graph csv t28_30';
% settings
tmax = 9;

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
nStrain =size(strainNames,1);
CurvePValue = nan(nStrain,6);
pairwisePValue = nan(nStrain*4, tmax);
pairwisePValue_legend = cell(nStrain*4,2);
nRow1 = 1;

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
    %% get graph reference data
    p = fullfile(pGraphData,[strain,' graph values.csv']);
    GraphData = readtable(p);
    t0_ref = find(GraphData.N2_x == -.1);
    tp_ref = t0_ref+2:t0_ref+tmax+1;
    
    colRef = strjoinrows([pairNames, repmat({'y'},size(pairNames))],'_');
    
    
     
    %% t1-5 larger than t0
    S = StatOut.t28_30.mcomp_t_g;
    pV = nan(numel(pairNames),tmax);
    nRow2 = nRow1+numel(pairNames)-1;
    
    for pairi = 1:numel(pairNames)
        gn = pairNames(pairi);
        i = ismember(S.groupname, gn) &...
            S.t_1 == 0 & ...
            ismember(S.t_2, 1:tmax);
        % get pvalue
        pv = S.pValue(i)';
        
        
        % add negative sign
        
        t0_value = GraphData.(colRef{pairi})(t0_ref);
        tp_value = GraphData.(colRef{pairi})(tp_ref);
        negi = tp_value < t0_value;
        pv(negi) = pv(negi).*-1;
        pV(pairi,:) = pv;
       
    end
    pairwisePValue(nRow1:nRow2,:) = pV;
    
    
    %% add legend
    pairwisePValue_legend(nRow1:nRow2,1) = {strain};
    pairwisePValue_legend(nRow1:nRow2,2) = pairNames;   
   
    % add rowN
    nRow1 = nRow2+1;
    
  
    
end


%% curve output table
colNames = {'WT0xWT4'    
    'WT0xMT0'
    'WT0xMT4'
    'WT4xMT0'      
    'WT4xMT4'
    'MT0XMT4'};
T = array2table(CurvePValue,'VariableNames',colNames);
T = [strainNames T];

cd(pM); writetable(T,'curve sig summary.csv');


%% pair wise output table
% add genotype
[i,j] = ismember(pairwisePValue_legend(:,1),strainNames.strain);
A = pairwisePValue_legend;
L = table;
L.strain = A(:,1);
L.genotype = strainNames.genotype(j);
L.group = A(:,2);



% combine
colNames = strjoinrows([repmat({'t'},tmax,1) num2cellstr(1:tmax)'],'')';
T = [L, array2table(pairwisePValue,'VariableNames',colNames)];

cd(pM); writetable(T,'pairwise time summary.csv');











    



