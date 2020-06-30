% -------------------------------------------------------------------------
%                          INITIALIZING 
% -------------------------------------------------------------------------
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
% -------------------------------------------------------------------------
%                         VARIABLES | 20170810
% -------------------------------------------------------------------------
pDataBase = '/Volumes/COBOLT/MWT';
pData = fullfile(fileparts(pM),'Data');
% add sub function folder
addpath(fullfile(pM,'_Functions'));
% -------------------------------------------------------------------------
% GET STRAIN INFO | 20170719
% -------------------------------------------------------------------------
% get group names
[fn,p] = dircontent(pData);
% minus archive code folder
p(regexpcellout(fn,'[_]')) = [];
% get gene names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
p = celltakeout(p);
% get strain names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
pstrains = celltakeout(p);
strainnames = celltakeout(fn);
% get gene name
p = cellfun(@fileparts,pstrains,'UniformOutput',0);
[p,genenames] = cellfun(@fileparts,p,'UniformOutput',0);
% get groupname
[p,groupnames] = cellfun(@fileparts,p,'UniformOutput',0);
% -------------------------------------------------------------------------
%                         COLLECT STATS | 20170810
% -------------------------------------------------------------------------
% MAKE OVER ALL TABLE | 20170810
% -------------------------------------------------------------------------
T = table;
T.group = groupnames;
T.gene = genenames;
T.strain = strainnames;
TALL = T;
% -------------------------------------------------------------------------
% MAKE INFO TABLE: CURVE | 20170815
% -------------------------------------------------------------------------
fprintf('\n\n** curve **\n');
% make empty table
T = table;
T.strain = strainnames;
colnames = {'curve_file_source','curve_N',...
            'curve_wt','curve_wt400',...
            'curve_wt_pct','curve_mt_pct',...
            'curve_wt_pct_ttest','curve_m_pct_ttest',...
            'curve_pct_anova','curve_pct_es'};
coltype = cellfunexpr(colnames','double');
coltype([1:2]) = {'cell'};
T = makeEmptyTable(T,colnames,coltype);

% cycle through strains
for si = 1:numel(strainnames)
    loopreporter(si,'strain',10,numel(strainnames));
    clear MWTSet;
    % get file
    sn_p = pstrains{si}; % strain path
    [~,sn] = fileparts(sn_p); % strain folder name
    aname = 'Dance_InitialEtohSensitivityPct_v1707'; % target analysis name
    fname = 'data.mat'; % file name
    pData = fullfile(sn_p, aname,fname); % get path to data

    % load data ------
    load(pData);
    % get shared data
    DS = MWTSet.Stats.curve.dscstat;
    DS = sortN2first(DS.group,DS);
    PCT = MWTSet.Stats.curve.pct_dscstat;
    PCT = sortN2first(PCT.group,PCT);
    TTEST = MWTSet.Stats.curve.pct_ttest_stat;
    ANOVA = MWTSet.Stats.curve.pct_anova;
    ES = MWTSet.Stats.curve.pct_effectsize;

    % treatment by colname
    for ci = 1:numel(colnames)
        cn = colnames{ci}; % get column name
        clear a
        switch cn
            case 'curve_file_source'
                a = aname;
            case 'curve_N'
                n = DS.n;
                a = num2cellstr(n);
                a = strjoin(a',', ');
            case 'curve_wt'
                a = DS.mean(ismember(DS.group,'N2'));
            case 'curve_wt400'
                a = DS.mean(ismember(DS.group,'N2_400mM'));
            case 'curve_wt_pct'
                a = PCT.mean(ismember(PCT.group,'N2_400mM'));
            case 'curve_mt_pct'
                a = PCT.mean(ismember(PCT.group,[sn,'_400mM']));
            case 'curve_wt_pct_ttest'
                a = TTEST.pv(ismember(TTEST.gn,'N2_400mM'));
            case 'curve_m_pct_ttest'
                a = TTEST.pv(ismember(TTEST.gn,[sn,'_400mM']));
            case 'curve_pct_anova'
                a = ANOVA.p('Groups');
            case 'curve_pct_es'
                a = ES;
        end
        % put in table
        if ismember(cn,{'curve_file_source','curve_N'})
            T.(cn){si} = a;
        else
            T.(cn)(si) = a;
        end
    end
end
TALL = outerjoin(TALL,T,'Key','strain','MergeKey',1); % put in overall table
% -------------------------------------------------------------------------
%% MAKE INFO TABLE: REV | 20170815
% -------------------------------------------------------------------------
fprintf('\n\n** reversals **\n');
% make empty table
T = table;
T.strain = strainnames;
colnames = {'rev_file_source','resp_c_N',...
                'rev_c_manova_g','rev_c_manova_e','rev_c_manova_int',...
                'rev_c_es','rev_c_wes','rev_c_mes',...
                'rev_c_ph_w0w4','rev_c_ph_w0m0','rev_c_ph_w0m4',...
                'rev_c_ph_w4m0','rev_c_ph_w4m4','rev_c_ph_m0m4',...
                'rev_c_spw_w0w4','rev_c_spw_w0m0','rev_c_spw_w0m4',...
                'rev_c_spw_w4w0','rev_c_spw_w4m4','rev_c_spw_m0m4',...
                'rev_hablevelchange_w0w4','rev_hablevelchange_m0m4'};
coltype = cellfunexpr(colnames','double');
coltype([1:2 15:20]) = {'cell'};
T = makeEmptyTable(T,colnames,coltype);
% cycle through strains
for si = 1:numel(strainnames)
    loopreporter(si,'strain',10,numel(strainnames));
    clear MWTSet;
    % get file
    sn_p = pstrains{si}; % strain path
    [~,sn] = fileparts(sn_p); % strain folder name
    aname = 'Dance_ShaneSpark_v1707'; % target analysis name
    fname = 'Dance_ShaneSpark_v1707.mat'; % file name
    pData = fullfile(sn_p, aname,fname); % get path to data

    % load data ------
    load(pData);
    % get shared data
    RM = MWTSet.Stats.RevFreq.Curve.rmanova;
    N = MWTSet.Graph.ByGroupPerPlate.RevFreq.N(1,:);
    G = MWTSet.Graph.ByGroupPerPlate.RevFreq.groupname; 
    PHC = MWTSet.Stats.RevFreq.Curve.posthoc.factors;
    PHCbytap = MWTSet.Stats.RevFreq.Curve.posthoc.factors_by_tap;
    HabLevel = MWTSet.Stats.RevFreq.Hablevel.anova.descriptive;
    ES = MWTSet.Stats.RevFreq.Curve.effectsize;
    ESG = MWTSet.Stats.RevFreq.Curve_by_strain;
    % treatment by colname
    for ci = 1:numel(colnames)
        cn = colnames{ci}; % get column name
        clear a
        switch cn
            case 'rev_file_source'
                a = aname;
            case 'resp_c_N'
                % sort N2 first
                n = sortN2first(G',N');
                % get number
                a = num2cellstr(n);
                % transform into text strin
                a = strjoin(a',', ');
            case 'rev_c_manova_g'
                a = RM.pValue('strain:tap');
            case 'rev_c_manova_e'
                a = RM.pValue('dose:tap');
            case 'rev_c_manova_int'
                a = RM.pValue('strain:dose:tap');
            case 'rev_c_es'
                a = ES;
            case 'rev_c_wes'
                a = ESG.N2.effectsize;
            case 'rev_c_mes'
                a = ESG.(strainnames{si}).effectsize;
            case 'rev_c_ph_w0w4'
                i = ismember(PHC.factors_1,'N2*0') & ismember(PHC.factors_2,'N2*400') | ...
                    ismember(PHC.factors_2,'N2*0') & ismember(PHC.factors_1,'N2*400');
                a = PHC.pValue(i);
            case 'rev_c_ph_w0m0'
                i = ismember(PHC.factors_1,'N2*0') & ismember(PHC.factors_2,[sn,'*0']) | ...
                    ismember(PHC.factors_2,'N2*0') & ismember(PHC.factors_1,[sn,'*0']);
                a = PHC.pValue(i);
            case 'rev_c_ph_w0m4'
                i = ismember(PHC.factors_1,'N2*0') & ismember(PHC.factors_2,[sn,'*400']) | ...
                    ismember(PHC.factors_2,'N2*0') & ismember(PHC.factors_1,[sn,'*400']);
                a = PHC.pValue(i);
            case 'rev_c_ph_w4m0'
                i = ismember(PHC.factors_1,'N2*400') & ismember(PHC.factors_2,[sn,'*0']) | ...
                    ismember(PHC.factors_2,'N2*400') & ismember(PHC.factors_1,[sn,'*0']);
                a = PHC.pValue(i);
            case 'rev_c_ph_w4m4'
                i = ismember(PHC.factors_1,'N2*400') & ismember(PHC.factors_2,[sn,'*400']) | ...
                    ismember(PHC.factors_2,'N2*400') & ismember(PHC.factors_1,[sn,'*400']);
                a = PHC.pValue(i);
            case 'rev_c_ph_m0m4'
                i = ismember(PHC.factors_1,'N2*0') & ismember(PHC.factors_2,[sn,'*400']) | ...
                    ismember(PHC.factors_2,'N2*0') & ismember(PHC.factors_1,[sn,'*400']);
                a = PHC.pValue(i);
            case 'rev_c_spw_w0w4'
                a = timecomppertap(PHCbytap,'N2*0','N2*400');
            case 'rev_c_spw_w0m0'
                a = timecomppertap(PHCbytap,'N2*0',[sn,'*0']);
            case 'rev_c_spw_w0m4'
                a = timecomppertap(PHCbytap,'N2*0',[sn,'*400']);
            case 'rev_c_spw_w4w0'
                a = timecomppertap(PHCbytap,'N2*400',['N2','*0']);
            case 'rev_c_spw_w4m4'
                a = timecomppertap(PHCbytap,'N2*400',[sn,'*400']);
            case 'rev_c_spw_m0m4'
                a = timecomppertap(PHCbytap,'N2*0',[sn,'*400']);
            case 'rev_hablevelchange_w0w4'
                a = HabLevel.mean(ismember(HabLevel.group,'N2_400mM')) ...
                    - HabLevel.mean(ismember(HabLevel.group,'N2'));
            case 'rev_hablevelchange_m0m4'
                a = HabLevel.mean(ismember(HabLevel.group,[sn,'_400mM'])) ...
                    - HabLevel.mean(ismember(HabLevel.group,sn));
        end
        % put in table
        if ismember(coltype{ci},'cell')
            T.(cn){si} = a;
        else
            T.(cn)(si) = a;
        end

    end
end
TALL = outerjoin(TALL,T,'Key','strain','MergeKey',1); % put in overall table
% -------------------------------------------------------------------------
%% MAKE INFO TABLE: ACC | 20170815
% -------------------------------------------------------------------------
fprintf('\n\n** acceleration **\n');
% make empty table
T = table;
T.strain = strainnames;
colnames = {'rev_file_source','resp_c_N',...
                'rev_c_manova_g','rev_c_manova_e','rev_c_manova_int',...
                'rev_c_es','rev_c_wes','rev_c_mes',...
                'rev_c_ph_w0w4','rev_c_ph_w0m0','rev_c_ph_w0m4',...
                'rev_c_ph_w4m0','rev_c_ph_w4m4','rev_c_ph_m0m4',...
                'rev_c_spw_w0w4','rev_c_spw_w0m0','rev_c_spw_w0m4',...
                'rev_c_spw_w4w0','rev_c_spw_w4m4','rev_c_spw_m0m4',...
                'rev_hablevelchange_w0w4','rev_hablevelchange_m0m4'};
colnames = regexprep(colnames,'rev','acc');
coltype = cellfunexpr(colnames','double');
coltype([1:2 15:20]) = {'cell'};
T = makeEmptyTable(T,colnames,coltype);

% cycle through strains
for si = 1:numel(strainnames)
    loopreporter(si,'strain',10,numel(strainnames));
    clear MWTSet;
    % get file
    sn_p = pstrains{si}; % strain path
    [~,sn] = fileparts(sn_p); % strain folder name
    aname = 'Dance_rType2_v1707'; % target analysis name
    fname = 'data.mat'; % file name
    pData = fullfile(sn_p, aname,fname); % get path to data

    
    % get shared data | 20170815
    load(pData); % load data
    N = MWTSet.Graph.AccProb.N(1,:)';
    G = MWTSet.Graph.AccProb.groupname; 
    % patch for strains without rtype analysis
    if ~ismember(fieldnames(MWTSet.Stats.AccProb),'rmanova')
        cnlist = 1:2; % only go through the first two
    else
        cnlist = 1:numel(colnames); % go through all data

        RM = MWTSet.Stats.AccProb.rmanova;
        PHC = MWTSet.Stats.AccProb.posthoc.factors;
        PHCbytap = MWTSet.Stats.AccProb.posthoc.factors_by_tap;
        HabLevel = table;
        HabLevel.group = MWTSet.Graph.AccProb.groupname;
        HabLevel.mean = mean(MWTSet.Graph.AccProb.Y(28:30,:))';
        ES = MWTSet.Stats.AccProb.effectsize;
        ESG = MWTSet.Stats_bystrain.AccProb;
    end
    
    % treatment by colname | 20170815
    for ci = cnlist
        cn = colnames{ci}; % get column name
        clear a
        switch cn
            case 'acc_file_source'
                a = aname;
            case 'acc_c_N'
                n = sortN2first(G,N); % sort N2 first
                a = num2cellstr(n); % get number
                a = strjoin(a',', '); % transform into text strin
            case 'acc_c_manova_g'
                a = RM.pValue('strain:tap');
            case 'acc_c_manova_e'
                a = RM.pValue('dose:tap');
            case 'acc_c_manova_int'
                a = RM.pValue('strain:dose:tap');
            case 'acc_c_es'
                a = ES;
            case 'acc_c_wes'
                a = ESG.N2.effectsize;
            case 'acc_c_mes'
                a = ESG.(strainnames{si}).effectsize;
            case 'acc_c_ph_w0w4'
                i = ismember(PHC.factors_1,'N2*0mM') & ismember(PHC.factors_2,'N2*400mM') | ...
                    ismember(PHC.factors_2,'N2*0mM') & ismember(PHC.factors_1,'N2*400mM');
                a = PHC.pValue(i);
            case 'acc_c_ph_w0m0'
                i = ismember(PHC.factors_1,'N2*0mM') & ismember(PHC.factors_2,[sn,'*0mM']) | ...
                    ismember(PHC.factors_2,'N2*0mM') & ismember(PHC.factors_1,[sn,'*0mM']);
                a = PHC.pValue(i);
            case 'acc_c_ph_w0m4'
                i = ismember(PHC.factors_1,'N2*0mM') & ismember(PHC.factors_2,[sn,'*400mM']) | ...
                    ismember(PHC.factors_2,'N2*0mM') & ismember(PHC.factors_1,[sn,'*400mM']);
                a = PHC.pValue(i);
            case 'acc_c_ph_w4m0'
                i = ismember(PHC.factors_1,'N2*400mM') & ismember(PHC.factors_2,[sn,'*0mM']) | ...
                    ismember(PHC.factors_2,'N2*400mM') & ismember(PHC.factors_1,[sn,'*0mM']);
                a = PHC.pValue(i);
            case 'acc_c_ph_w4m4'
                i = ismember(PHC.factors_1,'N2*400mM') & ismember(PHC.factors_2,[sn,'*400mM']) | ...
                    ismember(PHC.factors_2,'N2*400mM') & ismember(PHC.factors_1,[sn,'*400mM']);
                a = PHC.pValue(i);
            case 'acc_c_ph_m0m4'
                i = ismember(PHC.factors_1,'N2*0mM') & ismember(PHC.factors_2,[sn,'*400mM']) | ...
                    ismember(PHC.factors_2,'N2*0mM') & ismember(PHC.factors_1,[sn,'*400mM']);
                a = PHC.pValue(i);
            case 'acc_c_spw_w0w4'
                a = timecomppertap(PHCbytap,'N2*0mM','N2*400mM');
            case 'acc_c_spw_w0m0'
                a = timecomppertap(PHCbytap,'N2*0mM',[sn,'*0mM']);
            case 'acc_c_spw_w0m4'
                a = timecomppertap(PHCbytap,'N2*0mM',[sn,'*400mM']);
            case 'acc_c_spw_w4w0'
                a = timecomppertap(PHCbytap,'N2*400mM',['N2','*0mM']);
            case 'acc_c_spw_w4m4'
                a = timecomppertap(PHCbytap,'N2*400mM',[sn,'*400mM']);
            case 'acc_c_spw_m0m4'
                a = timecomppertap(PHCbytap,'N2*0mM',[sn,'*400mM']);
            case 'acc_hablevelchange_w0w4'
                a = HabLevel.mean(ismember(HabLevel.group,'N2_400mM')) ...
                    - HabLevel.mean(ismember(HabLevel.group,'N2'));
            case 'acc_hablevelchange_m0m4'
                a = HabLevel.mean(ismember(HabLevel.group,[sn,'_400mM'])) ...
                    - HabLevel.mean(ismember(HabLevel.group,sn));
        end
        % put in table
        if ~isempty(a)
            if ismember(coltype{ci},'cell')
                T.(cn){si} = a;
            else
                T.(cn)(si) = a;
            end
        else
            cn
            error('stop')
        end
    end
end
TALL = outerjoin(TALL,T,'Key','strain','MergeKey',1); % put in overall table
% -------------------------------------------------------------------------
%                       INTERPRET RESULTS | 20170815
% -------------------------------------------------------------------------
% general settings | 20170815
% -------------------------------------------------------------------------
psig = 0.05;
% -------------------------------------------------------------------------
% curve | 20170815
% -------------------------------------------------------------------------
colname = 'curve_decision';
TALL.(colname) = cell(size(TALL,1),1);
for si = 1:size(TALL,1)
    clear wt mut wmc decision     % reset
    
    % - wildtype effect
    wt_ttest = TALL.curve_wt_pct_ttest(si);
    wt_curve = TALL.curve_wt_pct(si);
    if wt_ttest < 0.05 && wt_curve< 0 % -- ttest < 0.05 & curve pct < 0
        wt = true; % = has alcohol effect
    else
        wt = false; % = no alcohol effect
    end
    
    % - mutant effect
    mut_ttest = TALL.curve_m_pct_ttest(si);
    mut_curve = TALL.curve_mt_pct(si);
    wt_mut_anova = TALL.curve_pct_anova(si);
    if mut_ttest < 0.05 && mut_curve< 0 % -- ttest < 0.05 & curve pct < 0
        mut = true; % = has alcohol effect
    else
        mut = false; % = has alcohol effect
    end
    
    % - comparison
    if wt_mut_anova > psig % w = m
        wmc = true; 
    else  %w ~ m
        wmc = false; 
    end
    
    % - decision
    decision = phenotype_decision(wt,mut,wmc);
    
    % record
    TALL.(colname){si} = decision;
end
% -------------------------------------------------------------------------
% reversal | 20170815
% -------------------------------------------------------------------------
colname = 'reversal_decision';
TALL.(colname) = cell(size(TALL,1),1);
for si = 1:size(TALL,1)
    clear interaction wt mut wmc decision     % reset
    
    % etoh + gene interactions
    inx = TALL.rev_c_manova_int;
    if inx < psig
        interaction = true;
    else
        interaction = false;
    end
    
    % - wildtype effect
    wtc = TALL.rev_c_ph_w0w4(si);
    wth = TALL.rev_hablevelchange_w0w4(si);
    if wtc < psig && wth < 0 % -- wt yes = 0 vs 400 < 0.05 & 400 hab level < 0 hab level
        wt = true;% = has alcohol effect
    else % -- wt no = otherwise 
        wt= false; % = no alcohol effect
    end
    
    % - mutant effect
    muc = TALL.rev_c_ph_m0m4(si);
    muh = TALL.rev_hablevelchange_m0m4(si);
    if muc < psig && muh < 0 % -- mut yes = 0 vs 400 < 0.05 & 400 hab level < 0 hab level
        mut = true; % -- m=w
    else
        mut = false;
    end
    
    % - comparison
    w0m0 = TALL.rev_c_ph_w0m0(si);
    w4m4 = TALL.rev_c_ph_w4m4(si);
    if w0m0 < psig && w4m4 < psig
        wmc = true;
    else
        wmc = false;
    end
    
    % - decision
    decision = phenotype_decision(wt,mut,wmc,interaction);
    
    % record
    TALL.(colname){si} = decision;
end
% -------------------------------------------------------------------------
% acceleration | 20170815
% -------------------------------------------------------------------------
colname = 'acceleration_decision';
TALL.(colname) = cell(size(TALL,1),1);
for si = 1:size(TALL,1)
    clear wt mut wmc decision     % reset
    
    % etoh + gene interactions
    inx = TALL.acc_c_manova_int;
    if inx < psig
        interaction = true;
    else
        interaction = false;
    end
    
    % - wildtype effect
    wtc = TALL.acc_c_ph_w0w4(si);
    wth = TALL.acc_hablevelchange_w0w4(si);
    if wtc < psig && wth > 0 % -- wt yes = 0 vs 400 < 0.05 & 400 hab level < 0 hab level
        wt = true;% = has alcohol effect
    else % -- wt no = otherwise 
        wt= false; % = no alcohol effect
    end
    
    % - mutant effect
    muc = TALL.acc_c_ph_m0m4(si);
    muh = TALL.acc_hablevelchange_m0m4(si);
    if muc < psig && muh > 0 % -- mut yes = 0 vs 400 < 0.05 & 400 hab level < 0 hab level
        mut = true; % -- m=w
    else
        mut = false;
    end
    
    % - comparison
    w0m0 = TALL.acc_c_ph_w0m0(si);
    w4m4 = TALL.acc_c_ph_w4m4(si);
    if w0m0 < psig && w4m4 < psig
        wmc = true;
    else
        wmc = false;
    end
    
    % - decision
    decision = phenotype_decision(wt,mut,wmc, interaction);
    
    % record
    TALL.(colname){si} = decision;
end
% -------------------------------------------------------------------------
%                   PHENOTYPE INTERPRETATIONS | 20170815
% -------------------------------------------------------------------------
% 3 PHENOTYPES KO | 20170815
% -------------------------------------------------------------------------

A = cell(size(TALL,1),1);
phenotype = {'ko'};
for si = 1:size(A,1)
    
    c = TALL.curve_decision(si);
    a = TALL.acceleration_decision(si);
    r = TALL.reversal_decision(si);
    
    ci = ismember(c,phenotype) ==1;
    ai = ismember(a,phenotype) ==1;    
    ri = ismember(r,phenotype) ==1;
    
    i = [ci ri ai];
    clear a
    if i == [1 1 1]
            a = 'all';
    elseif i== [1 0 0]
            a = 'curve';
    elseif i== [0 1 0]
            a = 'rev';
    elseif i== [0 0 1]
            a = 'acc';
    elseif i== [1 1 0]
            a = 'curve & rev';
    elseif i== [1 0 1]
            a = 'curve & acc';   
    elseif i== [0 1 1]
            a = 'rev & acc'; 
    elseif i==[0 0 0]
            a = 'wild-type';
    else
            error('wrong')
    end
    
    if any(ismember([c,a,r],'repeat experiment'))
        a = 'repeat experiment';
    end
    
    A{si} = a;

end


TALL.ko = A;
% -------------------------------------------------------------------------
% 3 PHENOTYPES | 20170815
% -------------------------------------------------------------------------
A = cell(size(TALL,1),1);
phenotype = {'intermediate','ko'};
for si = 1:size(A,1)
    
    c = TALL.curve_decision(si);
    a = TALL.acceleration_decision(si);
    r = TALL.reversal_decision(si);
    
    ci = ismember(c,phenotype) ==1;
    ai = ismember(a,phenotype) ==1;    
    ri = ismember(r,phenotype) ==1;
    
    i = [ci ri ai];
    clear a
    if i == [1 1 1]
            a = 'all';
    elseif i== [1 0 0]
            a = 'curve';
    elseif i== [0 1 0]
            a = 'rev';
    elseif i== [0 0 1]
            a = 'acc';
    elseif i== [1 1 0]
            a = 'curve & rev';
    elseif i== [1 0 1]
            a = 'curve & acc';   
    elseif i== [0 1 1]
            a = 'rev & acc'; 
    elseif i==[0 0 0]
            a = 'wild-type';
    else
            error('wrong')
    end
    
    if any(ismember([c,a,r],'repeat experiment'))
        a = 'repeat experiment';
    end
    
    A{si} = a;

end
TALL.consolidate_decision = A;
% -------------------------------------------------------------------------
% EXPORT | 20170719
% -------------------------------------------------------------------------
writetable(TALL,fullfile(pM,'Result summary.csv'));
fprintf(' DONE\n');
% -------------------------------------------------------------------------




























