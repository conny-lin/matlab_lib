%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pData_Strain = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
addpath(fullfile(fileparts(pM),'functions'));
% --------------------

% settings ++++++
% strains
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for si = 35%1:size(strainNames,1);
    
    % get strain +++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    % --------------
    
    
    %% CURVE SENSITIVITY ======================================================
    % get data +++++++++++++++
    p = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
    A = rmANOVACurveReport;
    A.datapath = p;
    
    percentChange(A)
    return
    % ------------------------

    % opening sentence +++++++++
    txt = 'For ethanol sensitivity measured by';
    txt = sprintf('%s the percentage of body curve depressedby ethanol,',txt);
    % ---------------------------
     
    % wildtype percentage effect +++++++++++++++++++++++++++++
    % calculate precent change
    a = bcurve(ismember(groupnames,'N2 0mM'));
    b = bcurve(ismember(groupnames,'N2 400mM'));
    pct = ((b/a)*100);
    if pct < 100
        pctchangeWT = 100 - pct;
    elseif pct > 100
        pctchangeWT = pct - 100;
    end
    % get pairwise comparison stats
    i = ismember(curvePosthoc.g1,'N2 0mM') & ismember(curvePosthoc.g2,'N2 400mM');
    if sum(i) ==1
        pvaluetxt = curvePosthoc.p{i};
    else
        error('no pvalue found or more than one found');
    end
    % generate txt string
    txt = sprintf('%s wildtype showed a %.0f%%',txt,pctchangeWT);
    if pct < 100
        txt = sprintf('%s decrease',txt);
    else
        txt = sprintf('%s increase',txt);
    end
    % ----------------------------------------------------------
    
    % mutant percentage effect +++++++++++++++++++++++++++++

    
%     ', but '
%     'the slo-1(js379) mutant showed '
%     'only a 20% decrease'

txt


%     ', '
%     'representing a 14%% '
%     'reduction in the effect of ethanol on body curve in the mutant '
%     '(ANOVA, strain, F(1,4614) = 217.760, p < 0.001'
%     ', '
%     'dose, F(1,4614) = 2878.919, p < 0.001'
%     ', '
%     'strain*dose, F(1,4614) = 101.935, p < 0.001'
%     ', '
%     'pairwise comparison, '
%     'wildtype 0mM vs slo-1(379) 0mM, p= 0.005'
%     ', '
%     'all other comparisons, p<0.001'
%     '). '
%     'This indicates that the slo-1(js379) mutation '
%     'reduced ethanol sensitivity. '
    % ----------------------

    % =========================================================================
    
    
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





























