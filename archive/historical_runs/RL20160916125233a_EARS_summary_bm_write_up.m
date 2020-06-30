% function StatOut = EARS_summary_bm_writeup(strain)

%% SETTING
clc; clear; close all;
% paths
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
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


%% generate output files
cd(pM);
diaryfile = sprintf('writeup diary.txt');
if exist(diaryfile,'file')
    diaryfile_archive =sprintf('writeup diary %s.txt', generatetimestamp);
    movefile(diaryfile, diaryfile_archive);
end
fid = fopen(diaryfile,'w');
fclose(fid);
diary(diaryfile);



%% cycle through strains

for si = 1:size(strainNames,1)
    %% starting: strain + sample size
    % get strain
    strain = strainNames.strain{si};  
    % get genotype
    genotype = strainNames.genotype{si}; 
    mutation_type = strainNames.mutation{si};
    
    % state genotype
    fprintf('For %s, ',genotype);
    
    % sample size
    fprintf('%s, ',sample_size_text(strain));
   
       
    %% load data files
    load(sprintf('%s/%s',pData,strain));
    GraphData = readtable(sprintf('%s/%s graph values.csv',pData,strain));
    
    
    %% get common variables
    SG = StatOut.t28_30.mcomp_g;
    ST = StatOut.t28_30.mcomp_t_g;
    STG = StatOut.t28_30.mcomp_g_t;
    xtime = GraphData.N2_x;
    rtime = GraphData.N2_x(GraphData.N2_x >= responseT1 & ...
        GraphData.N2_x <= responseT2);
    
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
    
    %% wildtype 0mM pairwise time
    fprintf('Velocity of wildtype 0mM group ');
    gname = 'N2';
    % get data
    fn = [gname,'_y'];
    [baseline, response, response_lower, response_rev, response_higher] = response_data(GraphData,fn, xtime, rtime, baselinetime);
    [pv,tr] = get_pvalue(ST,10,gname);
    
    rval = response_lower;
    [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
    
    if any(tv)
        fprintf('significantly decreased ');  
        taptime_pvalue(tv,pstr)
    end
    
    rval = response_rev;
    [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
    if any(response_rev) % if any response are reversals
       fprintf(', and decreased to negative (reversal) at ')
       taptime_pvalue(tv,pstr)
    end
    
    % determine normality in wt response
    conditions = [response_rev(1) == false;
                  all(response_rev(2:3) == true)];
    if all(conditions)
       fprintf(', indicating normal wildtype responses');
    end
    fprintf('. ');
        
    %% wildtype 400mM vs 0mM curve
    fprintf('Wildtype 400mM group showed ');
    % wildtype curve
    i = ismember(SG.groupname_1,'N2') & ismember(SG.groupname_2,'N2_400mM');
    pvalue = SG.pValue(i);
    if pvalue < alpha
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        fprintf('significantly different velocity curve compared to wildtype 0mM (%s)',pstr);
    else
        fprintf('similar velocity curve (%s)',pstr);
    end
    
    
    % wildtype 400mM pairwise time
    gname = 'N2_400mM'; gnametext = 'wildtype';

    % get data
    fn = [gname,'_y'];
    [baseline, response, response_lower, response_rev, response_higher] = response_data(GraphData,fn, xtime, rtime, baselinetime);
    [pv,tr] = get_pvalue(ST,10,gname);
    
    rval = response_higher;
    [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
    if any(tv)
        fprintf('and the velocity of %s significantly increased ',gnametext);  
        taptime_pvalue(tv,pstr)
    end
    
    %% determine
    conditions = [any(response_higher(2:5) == true) & rval(pv < alpha)];
    if all(conditions)
        fprintf(', indicating %s showed EARS', gnametext);
    else
        fprintf(', but response velocity did not increase above baseline');
        fprintf(', suggesting ethanol treatment may have failed');
    end
    fprintf('. ');
 



    %% mutant 0mM vs wt 0mM
    % compare with 0mM curve 
    fprintf('Velocity curve of %s 0mM ', genotype);

    i = ismember(SG.groupname_1,strain) & ismember(SG.groupname_2,'N2');
    pvalue = SG.pValue(i);
    pstr = print_pvalue(pvalue,pvlimit,alpha);

    if pvalue < alpha
        fprintf('was significantly different from wildtype 0mM (%s), ',pstr);
        fprintf('suggesting %s mutation changed response velocity. ',genotype);
    else
        fprintf('was similar to that of wildtype 0mM (%s), ',pstr);
        fprintf('suggesting %s had no effect on response velocity. ', genotype)
    end
    

    
    %% mutant 0mM pairwise
    fprintf('Velocity of %s 0mM group ',genotype);
    gname = strain; gnametext = genotype;
    fn = [gname,'_y'];
    [baseline, response, response_lower, response_rev, response_higher] = response_data(GraphData,fn, xtime, rtime, baselinetime);
    [pv,tr] = get_pvalue(ST,10,gname);
    
    rval = response_lower;
    [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
    
    if any(tv)
        fprintf('significantly decreased ');  
        taptime_pvalue(tv,pstr)
    end
    
    rval = response_rev;
    [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
    if any(response_rev) % if any response are reversals
       fprintf(', and decreased to negative (reversal) at ')
       taptime_pvalue(tv,pstr)
    else
       fprintf(', but did not decreased below zero');
    end
    
    % determine normality in wt response
    conditions = [response_rev(1) == false;
                  all(response_rev(2:3) == true)];
    if all(conditions)
       fprintf(', indicating %s 0mM had wildtype responses',genotype);
    end
    fprintf('. ');
    
    % comparison of wt 0mM and mt 0mM
    i = ismember(STG.groupname_1,'N2') & ismember(STG.groupname_2,strain);
    pv = STG.pValue(i);
    tr = STG.t(i);
    
    rtimec = [0;rtime];
    rval = pv < alpha;
    [pstr,~,tv] = pvaluestring(rtimec,rval,pv,alpha,pvlimit);
    if ~isempty(tv)
        fprintf('Pair-wise comparison between %s and wildtype 0mM velocity',genotype)
        fprintf(' showed significant difference ');
        taptime_pvalue(tv,pstr)
        fprintf(', suggesting %s altered responses. ',genotype);
    end

    
    
    
    %% mutant 400mM vs wt 400mM
    % compare with 0mM curve 
    fprintf('Velocity curve of %s 400mM ', genotype);
    i = ismember(SG.groupname_1,[strain,'_400mM']) & ismember(SG.groupname_2,'N2_400mM');
    pvalue = SG.pValue(i);
    if pvalue < alpha
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        fprintf('was significantly different from that of wildtype 400mM (%s), ',pstr);
        fprintf('suggesting %s mutation changed response velocity on ethanol. ',genotype);
    else
        fprintf('was similar to that of wildtype 400mM, ');
        fprintf('suggesting %s had no effect on response velocity on ethanol. ', genotype)
    end
    
    
    
    
    %% mutant 0 vs 400 -------------------------------------------------------------
    fprintf('%s 0mM and 400mM group showed ', genotype);
    % mutant curve
    i = ismember(SG.groupname_1,strain) & ismember(SG.groupname_2,[strain,'_400mM']);
    pvalue = SG.pValue(i);
    
    if pvalue < alpha
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        fprintf('significantly different velocity curve (%s), ',pstr);
        switch mutation_type
            case 'lof'
                fprintf('suggesting %s did not eliminate the effect of ethanol on response velocity',genotype);
            case 'gof'
                fprintf('suggesting %s had additive effect on the effect of ethanol on response velocity',genotype);

            case 'rescue'
                fprintf('suggesting %s did not rescue the effect of ethanol on response velocity',genotype);
                
        end
    else
        fprintf('similar velocity curve');
        switch mutation_type
            case 'lof'
                fprintf(', suggesting %s do not play a role in the effect of ethanol on response velocity', genotype)
            case 'gof'
    
            case 'rescue'
                
        end
                
    end
    
    fprintf('. ');
    
  
    
   %% mutant 400mM pairwise time
    gname = [strain,'_400mM']; gnametext = [genotype, ' 400mM'];

    % get data
    fn = [gname,'_y'];
    [baseline, response, response_lower, response_rev, response_higher] = response_data(GraphData,fn, xtime, rtime, baselinetime);
    [pv,tr] = get_pvalue(ST,10,gname);
    
    rval = response_higher;
    [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
    if any(tv)
        fprintf('and the velocity of %s significantly increased ',gnametext);  
        taptime_pvalue(tv,pstr)
    end
    
    % determine
    conditions = [any(response_higher(1:5) == true) & rval(pv < alpha)];
    if all(conditions)
        fprintf(', indicating %s showed EARS', gnametext);
    else
        fprintf(', but response velocity did not increase above baseline');
        fprintf(', suggesting %s did not show EARS',genotype);
    end
    fprintf('. ');
    
    
    %% finish
    fprintf('\n');
end
fprintf('\n');
diary(diaryfile);
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



























