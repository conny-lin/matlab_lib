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
% load object
A = rmANOVATARReport;
A.datapath = p;
% get genotype
strain = char(A.strain);
strainNames = DanceM_load_strainInfo;
genotype = strainNames.genotype{ismember(strainNames.strain, strain)};

% construct report
txt = sprintf('To see if %s affects ethanol modulated increase',genotype);
s = 'in the probability of acceleration response to repeated taps,';
txt = sprintf('%s %s',txt,s);
s = 'a repeated measures ANOVA evaluating the effects of strain, and ethanol on acceleration response probability revealed';
txt = sprintf('%s %s',txt,s);

% anova sig
D = A.anova;
pv = D.pvalue;
i = pv < pvsig;
if sum(i) >= 1
    F = [D.factor(i) D.F(i) D.ptxt(i)];
    if size(F,1) == 1
       Fsigtxt = strjoin(F',', ');
    else
        a = F(1:end-1,:);
        b = strjoinrows(a,', ');
        c = strjoin(b',', ');
        d = sprintf(', and %s',strjoin(F(end,:),', '));
        Fsigtxt = [c d];
    end
    s = sprintf('significant main effects of %s',Fsigtxt);
    s = regexprep(s,'dose','ethanol');
    txt = sprintf('%s %s',txt,s);
    siganova = true;
else
    siganova = false;
end

% anova not sig
pv = D.pvalue;
i = pv > pvsig;
if sum(i) > 1
    F = [D.factor(i)];
    if size(F,1) == 1
       Fsigtxt = strjoin(F',', ');
    else
        a = F(1:end-1,:);
        b = strjoinrows(a,', ');
        c = strjoin(b',', ');
        d = sprintf(', or %s',strjoin(F(end,:),', '));
        Fsigtxt = [c d];
    end
    if siganova
        s = sprintf(', but not %s',Fsigtxt);
        txt = sprintf('%s %s.',txt,s);
    else
        s = sprintf('no significant effect of %s',Fsigtxt);
    end
end

%% comparison in wildtype
s = 'Ethanol';
txt = sprintf('%s %s',txt,s);
D = A.posthoc_groups;
compname = {'N2*N2_400mM'};
pv = D.pvalue(compname);
if pv < pvsig
    s = 'produced the expected elevation of acceleration response probabilty in ';
    s1 = sprintf('wildtype (%s)',char(D.ptxt(compname)));
    s = sprintf('%s %s',s,s1);
else
    s = 'did not produce the expected elevation of acceleration response probabilty in wildtype';
end
txt = sprintf('%s %s',txt,s);

% 'but ethanol had no effect on the slo-1(js379) mutant (p=n.s.). '
% 'This suggested that the slo-1(js379) mutation eliminated ethanol?s enhancement in acceleration response. '
% 





    
    %% EXPORT REPORT ==========================================================
    p = fullfile(pSave,sprintf('%s stats writeup.txt',strain));
    fid = fopen(p,'w');
    fprintf(fid,'%s',txt);
    fclose(fid);
    % =========================================================================
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





























