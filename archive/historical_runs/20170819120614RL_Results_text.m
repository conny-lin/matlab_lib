% -------------------------------------------------------------------------
%                          INITIALIZING 
% -------------------------------------------------------------------------
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
% -------------------------------------------------------------------------
%                         VARIABLES | 20170819
% -------------------------------------------------------------------------
pResults = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Tbl2 genetic screen result summary/Data_by_ortholog/Results_Summary_Table/Result summary.csv';
pDB = '/Volumes/COBOLT/MWT/MWTDB.mat';
pData = '/Users/connylin/Dropbox/Publication/Manuscript RL Alcohol Genes/Figures Tables Data/Tbl2 genetic screen result summary/Data_by_ortholog/Data';
pSF = create_savefolder(pM,'_Functions'); % add sub function folder
pvsig = 0.05;
% -------------------------------------------------------------------------
% GET STRAIN INFO | 20170719
% -------------------------------------------------------------------------
% get group names
[fn,p] = dircontent(pData);
% minus archive code folder
p(regexpcellout(fn,'[_]')) = [];
% get gene names
[~,p] = cellfun(@dircontent,p,'UniformOutput',0);
p = celltakeout(p);
% get strain names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
pstrains = celltakeout(p);
strainnames = celltakeout(fn);
% -------------------------------------------------------------------------
% load data | 20170819
% -------------------------------------------------------------------------
RT = readtable(pResults); % read results table
load(pDB); % load allele 
% combine with strain
RT = outerjoin(RT,MWTDB.strain(:,{'strain','genotype'}),'MergeKeys',1,'Type','left');
% -------------------------------------------------------------------------
%%                     TRANSLATE STATS | 20170819
% -------------------------------------------------------------------------
for si = 1:size(RT,1)
% -------------------------------------------------------------------------
% GET GENERAL INFORMAITON | 20170819
% -------------------------------------------------------------------------
    % get information
    R = RT(si,:); 
    gene = char(R.gene);
    allele = char(R.genotype);
    pS = pstrains{ismember(strainnames,R.strain)};
% -------------------------------------------------------------------------
% CURVE | 20170819
% -------------------------------------------------------------------------
%     To investigate whether the DGK ortholog dgk-1 is involved in ethanol?s effect
%     on responses to repeated taps, I tested a mutant carrying the 
    % load data 
    load(fullfile(pS, 'Dance_InitialEtohSensitivityPct_v1707','data.mat'),'MWTSet'); % get path to data
    % get shared data
    TTEST = MWTSet.Stats.curve.pct_ttest_stat;
    % dgk-1(nu62) allele. 
    allelename = sprintf('%s allele',allele);
    % opening sentence
    statopen = sprintf('For ethanol''s effect on body curve');
    % wildtype
    wt_change = R.curve_wt_pct.*100;
    wt_ttest = R.curve_wt_pct_ttest;
    if abs(wt_ttest) < pvsig
        TTEST
        stext = print_stats('t',df,er,wt_ttest);
       if wt_change < 0
            wt_change_dir = 'decrease';
       else
            wt_change_dir = 'increase';
       end
    else
        wt_change_dir = 'no change';
    end
    

    return
    wtr = 'wild-type worms showed a 30%% decrease (t(48)=31.961, p<.001)';
    % junction
    junc = 'and the';
    % mutant
    mtr = sprintf('%s strain showed only a 3% decrease (t(51)=42.598, p<.001)',allele) ;
    compr = 'indicating a 27% reduction in the effect (ANOVA, F(1,99)=69.63, p<.001)';
    conclude = sprintf('This suggests that dgk-1 plays an important role in ethanol''s effect on body curve. ');
    sprintf('%s. %s, %s, %s %s, %s. %s',allelename,statopen,wtr, junc, mtr, compr, conclude)

    return
% REVERSAL| 20170819
% -------------------------------------------------------------------------
% ACCELERATION| 20170819
% -------------------------------------------------------------------------
% COMBINE CONCLUSION| 20170819
% -------------------------------------------------------------------------
end
% -------------------------------------------------------------------------
%                       SCRIPT ENDS | 20170819
% -------------------------------------------------------------------------
fprintf(' DONE\n');
% -------------------------------------------------------------------------




























