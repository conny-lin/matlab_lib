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
pSF = create_savefolder(pM,'_Functions'); % add sub function folder
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
% CURVE | 20170819
% -------------------------------------------------------------------------
    % get information
%     To investigate whether the DGK ortholog dgk-1 is involved in ethanol?s effect
%     on responses to repeated taps, I tested a mutant carrying the 
    R = RT(si,:); 
    gene = R.gene;
    allele = R.genotype;
    % dgk-1(nu62) allele. 
    allelename = sprintf('%s allele',allele);
    statopen = sprintf('For ethanol''s effect on body curve');
    % wildtype
    wt_change = R.curve_wt_pct
    return
    wtr = 'wild-type worms showed a 30%% decrease (t(48)=31.961, p<.001)';
    junc = 'and the';
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




























