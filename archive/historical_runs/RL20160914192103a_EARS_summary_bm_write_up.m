% function StatOut = EARS_summary_bm_writeup(strain)

%% SETTING
clc; clear; close all;
% paths
pM = setup_std(mfilename('fullpath'),'RL','genSave',false);
% addpath(pM);
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/4-STH genes/3-EARS/Data/ephys_accpeak_graph3_bm';
% IV
pvlimit = 0.001;
alpha = 0.05;
baselinetime = -0.1;
responseT1 = 0.1;
responseT2 = 1;

%% get shared data
% get strain info
% get strains
fn = dircontent(pData);
a = regexpcellout(fn,'[A-Z]{2,}\d{3,}','match');
a(cellfun(@isempty,a)) = [];
strain_name_list = unique(a);

% get strain info
load('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/MWTDatabase/StrainNames.mat');
strainNames(~ismember(strainNames.strain,strain_name_list),:) = [];
strainNames = sortrows(strainNames,{'genotype'});


%% cycle through strains
cd(fileparts(pM));
diary on;


for si = 27%1:size(strainNames,1)
    %% get strain
    strain = strainNames.strain{si};  
    % get genotype
    genotype = strainNames.genotype{si}; 

    % state genotype
    fprintf('For %s, ',genotype);
    
    % sample size
    load(sprintf('/Users/connylin/Dropbox/RL Pub PhD Dissertation/4-STH genes/Data/10sIS by strains/%s/ephys graph/data_ephys_t28_30.mat',strain),'DataG')
    n_sample = nan(size(DataG,2),1);
    gname = cell(4,1);
    for gi = 1:size(DataG,2)
        gname{gi} =(DataG(gi).name);
        n_sample(gi) = size(DataG(gi).speedb,1);
    end
    i = regexpcellout(gname,'N2');
    k= [find(i); find(~i)];
    n_sample = n_sample(k);
    fprintf(['N=',strjoin(num2cellstr(n_sample)',','),', ']);
   
    
    %% load data files
    load(sprintf('%s/%s',pData,strain));
    GraphData = readtable(sprintf('%s/%s graph values.csv',pData,strain));

    
    %% rANOVA
    S = StatOut.t28_30.ranova;
    if any(S.pValue(2:end) < alpha)
    
        fprintf('rANOVA revealed significant effect of ');
        % anova strain
        rowName = 'strain:t';
        pvalue = S.pValue(rowName);
        if pvalue < alpha
            df1 = S.DF(rowName);
            df2 = S.DF('Error(t)');
            f = S.F(rowName);
            pvaluestr = print_pvalue(pvalue,pvlimit,alpha);
            fprintf('strain, F(%d,%d)tap = %.3f, %s',df1, df2,f,pvaluestr);
        end
        
        % anova dose
        rowName = 'dose:t';
        pvalue = S.pValue(rowName);
        if pvalue < alpha
            df1 = S.DF(rowName);
            df2 = S.DF('Error(t)');
            f = S.F(rowName);
            pvaluestr = print_pvalue(pvalue,pvlimit,alpha);
            fprintf(', dose, F(%d,%d)tap = %.3f, %s',df1, df2,f,pvaluestr);
        end
        
        % anova dose/strain
        rowName = 'strain:dose:t';
        pvalue = S.pValue(rowName);
        if pvalue < alpha
            fprintf(', and interaction between strain and dose, ');
            df1 = S.DF(rowName);
            df2 = S.DF('Error(t)');
            f = S.F(rowName);
            pvaluestr = print_pvalue(pvalue,pvlimit,alpha);
            fprintf('F(%d,%d)tap = %.3f, %s',df1, df2,f,pvaluestr);
        end
    end
    fprintf('. ');
    
    %% wildtype -----------------------------------------------------------
    fprintf('Wildtype 0mM and 400mM group showed ');
    S = StatOut.t28_30.mcomp_g;
    % wildtype curve
    i = ismember(S.groupname_1,'N2') & ismember(S.groupname_2,'N2_400mM');
    p = S.pValue(i);
    if p < alpha
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        fprintf('significantly different velocity curve (%s). ',pstr);
    else
        fprintf('similar velocity curve (%s), ',pstr);
        fprintf('suggesting ethanol treatment may have failed. ');
    end
    
    %% wildtype 0mM pairwise time
    fprintf('Velocity of wildtype 0mM group ');
    %% get data
    baseline = GraphData.N2_y(GraphData.N2_x == baselinetime);
    response = GraphData.N2_y(GraphData.N2_x >= responseT1 & GraphData.N2_x <= responseT2);
    response_lower = response < baseline;
    response_rev = response < 0;
    response_time = GraphData.N2_x(GraphData.N2_x >= responseT1 & GraphData.N2_x <= responseT2);
    S = StatOut.t28_30.mcomp_t_g;
    pv = S.pValue(ismember(S.groupname,'N2') & S.t_1 == 0 & ismember(S.t_2,1:10));
    pvs = pv(response_lower) < alpha;
    
    if any(pvs)
        fprintf('significantly decreased after the tap ');  
        if sum(pvs) == numel(response) % if all have lower response
            if all(pv < pvlimit) 
                fprintf('(%.1fs-%.0fs vs. baseline, p<%.3f), ',responseT1,responseT2,pvlimit);
            else  
                error('need coding');
                response_time(pvs & pv > pvlimit)
                
                
            end
            
        end
    end
%     sum(response_lower) == numel(response_lower)
%     'but wildtype 400mM group velocity significantly increased 0.1-0.4s after the tap (p < 0.001), indicating wildtype showed EARS. npr-1(ad609) 0mM and 400mM group had significantly different velocity curve (p<0.001). Velocity curves of npr-1(ad609) 0mM and 400mM groups were significantly different (p<0.001), suggesting npr-1(ad609) did not entirely knock out the effect of ethanol on response velocity. Velocity of both npr-1(ad609) 0mM and 400mM group significantly decreased after the tap (0.1s-1s < baseline, p < 0.001), as well as wildtype 400mM group velocity significantly increased 0.1-0.4s after the tap (p < 0.001), indicating npr-1(ad609) failed to show EARS, and that npr-1 is required for EARS.'; 

    

end
fprintf('\n');
diary off


return

%% genotype
% load strain database files
load('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/MWTDatabase/StrainNames.mat');
genotype = char(strainNames.genotype(ismember(strainNames.strain,strain)));
mutation_type = char(strainNames.mutation(ismember(strainNames.strain,strain)));
gene = char(regexp(genotype,'\w{3,}-\d{1,}','match'));

% sample size
load(sprintf('/Users/connylin/Dropbox/RL Pub PhD Dissertation/4-STH genes/Data/10sIS by strains/%s/ephys graph/data_ephys_t28_30.mat',strain),'DataG')
n_sample = nan(size(DataG,2),1);
for gi = 1:size(DataG,2)
    n_sample(gi) = size(DataG(gi).speedb,1);
end
% clear DataG;

%% find information from text files ---------------------------------------
% load stats text files
a = fopen(sprintf('%s/%s Stats.txt',pData,strain),'r');
dataArray = textscan(a, '%s%[^\n\r]', 'Delimiter', '','ReturnOnError', false);
fclose(a);
textfile = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans d;

% gt hab response text
i = find(regexpcellout(textfile,'*** t1 ***'));
tf_t1 = textfile(i+1:end);
tf_t30 = textfile(2:i-1);

% find index
i1 = find(strcmp(tf_t30,'RMANOVA(t28_30,t:strain*dose):'));
i2 = find(strcmp(tf_t30,'Posthoc(Tukey)curve by group:'));
i3 = find(strcmp(tf_t30,'Posthoc(Tukey)groupname by t:'));
i4 = find(strcmp(tf_t30,'Posthoc(Tukey)t by groupname:'));

% get anova results
a = tf_t30(i1+1:i2-1);
b = regexpcellout(a,', p(<|=)','split');
d = b(:,1);
d = regexprep(d,'Intercept*t','tap');
e = regexpcellout(d,'([)]|=)','split');
e = regexprep(e(:,2),'(Intercept)|*t','');
e = regexprep(e,' ','');
% e(cellfun(@isempty,e)) = {'tap'};
d = regexprep(d,'*t','');
c = b(:,2);
i = regexpcellout(c,'n.s.');
strinsig = char(strjoinrows(e(i)',', '));
d = regexprep(d,'*t','');

a = regexprep(a,'Intercept*t','tap');
a = regexprep(a,'*t','');
b = strjoinrows([e(~i) a(~i)],', ');
b1 = strjoin(b(1:end-1)',', ');
strsig = strjoin([{b1} a(end)],', and ');


%% text output ------------------------------------------------------------
clc; diary on;
fprintf('%s\n',generatetimestamp);

fileout = fopen(sprintf('%s result text.txt',strain),'w');
fprintf('For %s %s allele, ',genotype, mutation_type); % title sentence
% anova
if ~isempty(strinsig)
    fprintf('rANOVA revealed significant effect of %s, but not %s.',strsig,strinsig);
else 
    fprintf('rANOVA revealed significant effect of %s.',strsig);
end
fprintf(' ');
% N
fprintf(['(N=',strjoin(num2cellstr(n_sample)',','),').']);
fprintf(' ');



%% EARS: N2 400mM
D = StatOut.t28_30.mcomp_t_g;
D1 = StatOut.t28_30.mcomp_g;

[~, p_peakt_wt, ears_sig_wt, tsig_wt] = findEARSt(D, 'N2', alpha);
[~, p_curvet_wt, curve_sig_wt] = findCurveS(D1,'N2', alpha);
printEARS(ears_sig_wt, curve_sig_wt, 'Wildtype', p_curvet_wt, tsig_wt, p_peakt_wt);
if ears_sig_wt && curve_sig_wt
    fprintf('.');
end
fprintf(' ');


%% EARS: Mutant 400mM
[~,p_peakt,ears_sig,tsig] = findEARSt(D,strain,alpha);
[~,p_curvet,curve_sig] = findCurveS(D1,strain,alpha);
printEARS(ears_sig, curve_sig,genotype,p_curvet,tsig,p_peakt);
ecurve_flat = ETcurve_flat(StatOut,strain);
    
if ~ears_sig
   fprintf(' suggesting that ');
   switch mutation_type
       case 'lof'; fprintf('EARS requires %s.',gene);
       case 'gof'; fprintf('activation of %s inhibits EARS.',gene);
       case 'rescue'; fprintf('%s did not rescue EARS.',genotype);

   end
   if ecurve_flat 
      fprintf(' In addition, %s 400mM response curve was flat, suggesting that ',genotype);
       switch mutation_type
           case 'lof'; fprintf('forward response requires %s.',gene);
           case 'gof'; fprintf('activity of %s inhibited foward response.',gene);
       end
   end
   
elseif ears_sig
    fprintf(', indicating %s did not affect EARS.',genotype);
end
fprintf(' ');

%% Wildtype not showing EARS
if ~ears_sig_wt
fprintf('However, since wildtype did not show EARS, this experiment needs to be repeated.');
end

%% EARS mutant 400mM = wildtype 400mM?
% The flp-18(gk3063) 400mM was indistinguishable from wildtype 400mM, indicating flp-18(gk3063) had no effect on EARS. 

D = StatOut.t28_30.mcomp_g;
p_curve = D.pValue(ismember(D.groupname_1,'N2_400mM') & ismember(D.groupname_2,[strain,'_400mM']));

PW = StatOut.t28_30.mcomp_g_t;
i = ismember(PW.groupname_1,'N2_400mM') & ismember(PW.groupname_2,[strain,'_400mM']);
% PW(i,{'t','pValue'})
% PW(PW.t==1,:);

%% conclusion

fprintf('\n\n');
diary(fullfile(pData,sprintf('%s results text.txt',strain)));
diary off;
fclose(fileout);
% end



























