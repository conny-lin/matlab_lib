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
% get strains
fn = dircontent(pData);
a = regexpcellout(fn,'[A-Z]{2,}\d{1,}','match');
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
    % pairwise
    fprintf('%s',taptime_result(GraphData,ST,gname,'decreased'));
    fprintf(', %s',taptime_result(GraphData,ST,gname,'reversed'));
    
    % determine normality in wt response
    [rq,rd] = response_data2(GraphData,gname);
    conditions = [rq.rev(1) == false;
                  all(rq.rev(2:3) == true)];
    if all(conditions)
       fprintf(', indicating normal wildtype responses');
    end
    fprintf('. ');
      
    
    
    %% wildtype 400mM 
    gname = 'N2_400mM'; gnametext = 'wildtype 400mM'; fn = [gname,'_y'];
    % title sentence
    fprintf('Velocity curve of %s group ', gnametext);
   
    % vs 0mM wildtype curve
    i = ismember(SG.groupname_1,'N2') & ismember(SG.groupname_2,'N2_400mM');
    pvalue = SG.pValue(i);
    if pvalue < alpha
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        fprintf('was significantly different from wildtype 0mM (%s)',pstr);
        fprintf(', indicating ethanol altered response velocity');
    else
        fprintf('was not different from wildtype 0mM (%s)',pstr);
        fprintf(', indicating ethanol did not alter response velocity ');
        fprintf('so that the treatment may have failed');
    end
    
    
    % linker
    fprintf('. ');

    % wildtype 400mM pairwise time
    [str,passed] = taptime_result(GraphData,ST,gname,'increased');
    if ~passed
        fprintf('However, velocity of %s group %s',gnametext, str);
        fprintf(' indicating wildtype did not show EARS');
        wtEARS_failed = true;
    else
        fprintf('In addition, velocity of %s group %s',gnametext, str);
        fprintf(' indicating wildtype showed EARS');
        wtEARS_failed = false;
    end
    % linker
    fprintf('. ');
    
    
    

    %% mutant 0mM vs wt 0mM
    % mutant 0mM pairwise description
    fprintf('Velocity of %s 0mM group ',genotype);
    gname = strain; 
    [str,passed] = taptime_result(GraphData,ST,gname,'decreased');
    if passed
        fprintf('%s',str);
    end
    [str,passed] = taptime_result(GraphData,ST,gname,'reversed');
    if passed
        fprintf(', and %s',str);
    end
    
    % determine normality in wt response
    [rq,rd] = response_data2(GraphData,gname);
    conditions = [rq.rev(1) == false;all(rq.rev(2:3) == true)];
    if all(conditions)
       fprintf(', indicating responses similar to wildtype responses');
    end
    fprintf('. ');

    % compare with 0mM curve 
    fprintf('Velocity curve of %s 0mM ', genotype);
    i = ismember(SG.groupname_1,strain) & ismember(SG.groupname_2,'N2');
    pvalue = SG.pValue(i);
    pstr = print_pvalue(pvalue,pvlimit,alpha);
    if pvalue < alpha
        fprintf('was significantly different from wildtype 0mM (%s), ',pstr);
        mut_vs_wt_d = true;
    else
        fprintf('was similar to that of wildtype 0mM (%s), ',pstr);
        fprintf('suggesting %s had no effect on response velocity. ', genotype)
        mut_vs_wt_d = false;
    end
    
    % comparison of wt 0mM and mt 0mM
    if mut_vs_wt_d
        i = ismember(STG.groupname_1,'N2') ...
            & ismember(STG.groupname_2,strain) ...
            & ismember(STG.t,1:10);
        pv = STG.pValue(i);
        rval = pv(1:end) < alpha;
        [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
        if ~isempty(tv)
            s = taptime_pvalue(tv,pstr);
            fprintf('and significantly different at %s',s)
            
            fprintf(', suggesting %s altered responses. ',genotype);
        end
    end

    
    
    
    
    %% mutant 400mM vs mutant 0mM
    % compare with 0mM curve 
    fprintf('Velocity curve of %s 400mM ', genotype);
    i = ismember(SG.groupname_1,[strain,'_400mM']) & ismember(SG.groupname_2,strain);
    pvalue = SG.pValue(i);
    if pvalue < alpha
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        fprintf('was significantly different from %s 0mM (%s), ',genotype, pstr);
        fprintf('indicating %s ', genotype);
        fprintf('did not eliminiate the effect of ethanol on response velocity');
    else
        fprintf('was not different from %s 0mM, ',genotype);
        fprintf('indicating %s eliminated the effect of ethanol on response velocity', genotype);
    end
    
   %% mutant 400mM pairwise time
    fprintf('Velocity of %s 400mM ', genotype);
    gname = [strain,'_400mM']; gnametext = [genotype, ' 400mM'];
    [str,passed] = taptime_result(GraphData,ST,gname,'increased');
    if passed
        fprintf(' %s, indicating %s had intact EARS',str,genotype);
    else
        fprintf('did not increase above baseline');
        fprintf(', suggesting %s did not show EARS', genotype);
    end
    fprintf('. ');
    
    
    %% mutant 400mM vs wt 400mM
    % compare with 0mM curve 
    fprintf('Velocity curve of %s 400mM ', genotype);
    i = ismember(SG.groupname_1,[strain,'_400mM']) & ismember(SG.groupname_2,'N2_400mM');
    pvalue = SG.pValue(i);
    if pvalue < alpha
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        fprintf('was significantly different from wildtype 400mM (%s), ',pstr);
        m4vsw4sig = true;
        fprintf('suggesting %s mutation changed response velocity on ethanol. ',genotype);
    else
        fprintf('was similar to that of wildtype 400mM, ');
        fprintf('suggesting %s had no effect on response velocity on ethanol. ', genotype)
        m4vsw4sig = false;
    end
        
  
    
    %% final conclusion
    if wtEARS_failed
     fprintf('Since wildtype did not show EARS, more experiment is required to confirm this finding. ');
    end
    
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



























