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
    curveMANOVA = importfile_curveMANOVA(p);
    % ------------------------

    % For ethanol sensitivity measured by the percentage of body curve depressed by ethanol, wildtype showed a 34% decrease in body curves, but the slo-1(js379) mutant showed only a 20% decrease, representing a 14% reduction in the effect of ethanol on body curve in the mutant (ANOVA, strain, F(1,4614) = 217.760, p < 0.001, dose, F(1,4614) = 2878.919, p < 0.001, strain*dose, F(1,4614) = 101.935, p < 0.001, pairwise comparison, wildtype 0mM vs slo-1(379) 0mM, p= 0.005, all other comparisons, p<0.001). This 14% reduction was less than the 24% reduction found in the slo-1(eg142) mutant, indicating that the slo-1(js379) mutation reduced ethanol sensitivity but perhaps not to the same extent as slo-1(eg142). slo-1(js379) mutation was previously shown to reduce ethanol sensitivity. While ethanol stimulated pharyngeal activity in wildtype animals, slo-1(js379) mutant showed normal pharyngeal activity on ethanol {Dillon, 2013}. We also found that slo-1(js379) showed less sensitivity to ethanol?s inhibitory effect on body curve. 

    % =========================================================================
    
    
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





























