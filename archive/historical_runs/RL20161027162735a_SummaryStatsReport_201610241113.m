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

for si = 1:size(strainNames,1);
    
    % get strain +++
    processIntervalReporter(size(strainNames,1),1,'*** strain',si);
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    % --------------
    
    % curve sensitivity +++++++++++++++
    curveData = rmANOVACurveReport;
    curveData.datapath = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
    % calculate percentage difference +++++++++
    pC = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivityPct','data.mat');
    DC = load(pC,'DataMeta','MWTDB');
    CS = CurveStats;
    CS.mwtid = DC.DataMeta.mwtid;
    CS.curve = DC.DataMeta.curve;
    CS.MWTDB = DC.MWTDB;
    txt = reportCurveSensitivity2(curveData,CS);
    % -----------------------------------------
    
    
    % -------------------------------

    % TAR ++++++++++
    TAR = rmANOVATARReport;
    TAR.datapath = fullfile(pData_Strain, strain, 'TAR/Dance_rType/AccProb RMANOVA.txt');
    txt2 = reportTAR(TAR);
    % --------------
    
    txtFinal = sprintf('%s\n%s',txt,txt2);

    
    % EXPORT REPORT +++++++++
    p2 = fullfile(pSave,sprintf('%s stats writeup.txt',strain));
    fid = fopen(p2,'w');
    fprintf(fid,'%s',txtFinal);
    fclose(fid);
    %-----------
    
    % save objects ++++
    p3 = fullfile(pSave,sprintf('%s.mat',strain));
    save(p3,'curveData','TAR');
    
    % -------------------
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





























