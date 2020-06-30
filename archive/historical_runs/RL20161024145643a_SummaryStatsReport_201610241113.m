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
pSave = create_savefolder(fullfile(pM,'Report'));
% --------------------

% settings ++++++
% strains
pvsig = 0.05;
pvlim = 0.001;
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for si = 35%1:size(strainNames,1);
    
    % get strain +++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    % --------------
    
    % curve sensitivity +++++++++++++++
    p = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
    txt = reportCurveSensitivity(p);
    % -------------------------------

    %% TAR 
    pH = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
    p = fullfile(pH, strain, 'TAR/Dance_rType/AccProb RMANOVA.txt');
    txt2 = reportTAR(p);

    txtFinal = sprintf('%s\n\n%s',txt,txt2);



    
    %% EXPORT REPORT ==========================================================
    p = fullfile(pSave,sprintf('%s stats writeup.txt',strain));
    fid = fopen(p,'w');
    fprintf(fid,'%s',txtFinal);
    fclose(fid);
    % =========================================================================
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





























