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
    
    
    %% CURVE SENSITIVITY ======================================================
    % get data +++++++++++++++
    p = fullfile(pData_Strain,strain,'Etoh sensitivity','InitialEtohSensitivity','curve MANOVA.txt');
    curveData = rmANOVACurveReport;
    curveData.datapath = p;
    % ------------------------

    % opening sentence +++++++++
    txt = 'For ethanol sensitivity measured by';
    txt = sprintf('%s the percentage of body curve depressedby ethanol,',txt);
    % ---------------------------
     
    % wildtype percentage effect +++++++++++++++++++++++++++++
    D = percentChange(curveData);
    v1 = D.pct('N2');
    txt = sprintf('%s wildtype showed a %.0f%%',txt,abs(v1));
    if v1<0
        txt = sprintf('%s decrease',txt);
    else
        txt = sprintf('%s increase',txt);
    end
    % ----------------------------------------------------------
    
    % mutant percentage effect +++++++++++++++++++++++++++++
    D = percentChange(curveData);
    v2 = D.pct(strain);
    jctword = 'and';
    if v2<0
        effectword = 'decrease';
    else
        effectword = 'increase';
    end
    txt = sprintf('%s, %s %s showed a %.0f%% %s',txt,jctword, genotype, abs(v2), effectword);
    % -------------------------------------------------------

    % anova +++++++++++
    A = curveData.manova;
    i = A.pvalue < pvsig;
    a = strjoin(A.txt',', ');
    s = sprintf('(ANOVA, %s',a);
    txt = sprintf('%s %s',txt, s);
    % ------------------
    
    % pairwise +++++++++++
    D = percentChange(curveData);
    gn = D.Properties.RowNames;
    gn =regexprep(gn,'N2','wildtype');
    gn = regexprep(gn,strain,genotype);
    b = repmat({'0mM vs 400mM'},numel(gn),1);
    c = strjoinrows([gn b], ' ');
    d = D.p;
    s = strjoin(strjoinrows([c d],', ')',', ');
    s = sprintf('pairwise comparison, %s)',s);
    txt = sprintf('%s %s.',txt, s);
    % ----------------------

    % =========================================================================
    
    
    %% EXPORT REPORT ==========================================================
    p = fullfile(pSave,sprintf('%s stats writeup.txt',strain));
    fid = fopen(p,'w');
    fprintf(fid,'%s',txt);
    fclose(fid);
    % =========================================================================
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





























