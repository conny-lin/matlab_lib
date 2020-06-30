%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pData_Strain = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
% addpath(fullfile(fileparts(pM),'functions'));
pSave = create_savefolder(fullfile(pM,'Results'));
% --------------------

% settings ++++++
pvsig = 0.05;
pvlim = 0.001;
w = 9;
h = 4;
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sum = ones(size(strainNames, 1),2);
for si = 1:size(strainNames,1);
    
    % get strain +++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    processIntervalReporter(size(strainNames,1),1,strain,si);
    % --------------
    
    
    %% get curve data +++++++++++
    Data = rmANOVACurveReport;
    Data.datapath = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
    
    %% get direction of curve effect wildtype vs strain
    i = ismember(Data.posthoc.g1,'N2 0mM') & ismember(Data.posthoc.g2,[strain ' 0mM']);
    if sum(i) == 0
        i = ismember(Data.posthoc.g2,'N2 0mM') & ismember(Data.posthoc.g1,[strain ' 0mM']);
    end
    pv =Data.posthoc.pvalue(i);
   mut = Data.mean(ismember(Data.groupnames,[strain, ' 0mM']));
   wt = Data.mean(ismember(Data.groupnames,'N2 0mM'));
   d = mut-wt;
   Sum(si,1) = d;
    Sum(si,2) = pv;

    
end

T = array2table(Sum,'VariableNames',{'dMut_WT','p'});
writetable(T,fullfile(pSave,'curve 0mM.csv'));


























