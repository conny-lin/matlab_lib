
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% SETTINGS
% data source
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/Summary v3/Graph and stats/ephys_accpeak_graph_vbm/mat files';
pGraphData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/Summary v3/Graph and stats/ephys_accpeak_graph_vbm/Graph csv t28_30';
% settings
tmax = 10;

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

%% RANOVA summary ------------------------------------------------------
colNames = {'df1' 'df2' 'strainc' 'dose' 'rm'};
T = array2table(nan(nStrain, numel(colNames)),'VariableNames',colNames);

for si = 1:size(strainNames,1)
    strain = strainNames.strain{si};    
    % load data files
    load(sprintf('%s/%s',pData,strain));

    S = StatOut.t28_30.ranova;
    T.df1(si) = S.DF('strain:t');
    T.df2(si) = S.DF('Error(t)');
    T.strainc(si) = S.pValue('strain:t');
    T.dose(si) = S.pValue('dose:t');
    T.rm(si) = S.pValue('strain:dose:t');

end
T = [strainNames T];
cd(pM); writetable(T,'ranova summary.csv');



%% CURVE SUMMARY ---------------------------------------------------------
nStrain =size(strainNames,1);
CurvePValue = nan(nStrain,6);
PWP = nan(nStrain*4, tmax);
pairwisePValue_legend = cell(nStrain*4,2);
nRow1 = 1;

for strain_i = 1:size(strainNames,1)
    % get strain data
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
    
end

% curve output table summary
colNames = {'WT0xWT4'    
    'WT0xMT0'
    'WT0xMT4'
    'WT4xMT0'      
    'WT4xMT4'
    'MT0XMT4'};
T = array2table(CurvePValue,'VariableNames',colNames);
T = [strainNames T];

cd(pM); writetable(T,'curve sig summary.csv');



%% PAIRWISE COMPARISON TABLE --------------------------------------------
nTime = 11;
% comp array abbreviataion name
pairNamesab = {'W0','W4','M0','M4'};
CompArrayAbbr = pairwisecomp_getpairs(pairNamesab);
CompArrayAbbr = strjoinrows(CompArrayAbbr,'x');
% make entry table
PWP = nan(nStrain, nTime*numel(CompArrayAbbr));
colStep = [1:nTime:nTime*numel(CompArrayAbbr)];


for strain_i = 1:size(strainNames,1)
    % get strain data
    strain = strainNames.strain{strain_i}; % get strain name
    load(sprintf('%s/%s',pData,strain), 'StatOut'); % load data
    
    % get comparison array
    pairNames = {'N2';'N2_400mM';strain;[strain,'_400mM']};
    CompArray = pairwisecomp_getpairs(pairNames);

    
    % get graph reference data
    p = fullfile(pGraphData,[strain,' graph values.csv']);
    GraphData = readtable(p);
    t0_ref = find(GraphData.N2_x == -.1);
    tp_ref = t0_ref+2:t0_ref+tmax+1;
    colRef = strjoinrows([pairNames, repmat({'y'},size(pairNames))],'_');
    % get rid of unnecesssary data
    GraphData = GraphData([t0_ref tp_ref],colRef);
    % change column names
    GraphData.Properties.VariableNames =  pairNames;
    
    %% get stats
    %% cycle through pairs
    S = StatOut.t28_30.mcomp_g_t;

    for pairi = 1:size(CompArray,1)
        gn1 = CompArray{pairi,1};
        gn2 = CompArray{pairi,2};

        % get stats
        i = ismember(S.groupname_1,gn1) & ismember(S.groupname_2,gn2);
        S1 = S(i,:);
        S1 = sortrows(S1,{'t'});
        if size(S1,1)~=nTime; error('time number does not match'); end
        pv = S1.pValue;
        % get data differences
        dd = zeros(size(S1,1),1);
        % if group 2 > group 1, positive
        dd((GraphData.(gn2) - GraphData.(gn1)) > 0) = 1;
        % if group 2 < group 1, negative
        dd((GraphData.(gn2) - GraphData.(gn1)) < 0) = -1;
        % add sign to pv
        pv = pv.*dd;
        % invert
        pv = pv';

        % place in master table
        PWP(strain_i, colStep(pairi):colStep(pairi)+nTime-1) = pv;
    end
        
end


% create colnames
colNames = {};
for x = 1:numel(CompArrayAbbr)
    a = repmat(CompArrayAbbr(x),nTime,1);
    b = num2cellstr(0:nTime-1)';
    a = strjoinrows([a b],'xt');
    colNames = [colNames; a];
end
PWP = array2table(PWP,'VariableNames',colNames');
PWP = [strainNames PWP];
cd(pM);
writetable(PWP,'pair-wise velocity pvalue.csv');
    


%% PHENOTYPES --------------------------------------------
pname = {'W0','W4','M0','M4'};
nTime = 11;
PNT = nan(size(strainNames,1), numel(pname)*nTime);

for strain_i = 1:size(strainNames,1)
    % get strain data
    strain = strainNames.strain{strain_i}; % get strain name
    
    % get graph reference data
    p = fullfile(pGraphData,[strain,' graph values.csv']);
    GraphData = readtable(p);
    t0_ref = find(GraphData.N2_x == -.1);
    tp_ref = t0_ref+2:t0_ref+tmax+1;
    colRef = strjoinrows([pairNames, repmat({'y'},size(pairNames))],'_');
    % get rid of unnecesssary data
    GraphData = GraphData([t0_ref tp_ref],colRef);
    % change column names
    GraphData.Properties.VariableNames =  pairNames;
    
    a = table2array(GraphData);
    b = reshape(a,1,numel(a));
    PNT(strain_i,:) = b;
    
end

% create colnames
colNames = {};
for x = 1:numel(pname)
    a = repmat(pname(x),nTime,1);
    b = num2cellstr(0:nTime-1)';
    a = strjoinrows([a b],'xt');
    colNames = [colNames; a];
end    
PNT = array2table(PNT,'VariableNames',colNames');
PNT = [strainNames PNT];
cd(pM);
writetable(PNT,'velocity summary.csv');
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


