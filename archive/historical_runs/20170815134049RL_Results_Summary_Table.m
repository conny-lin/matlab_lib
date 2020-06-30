%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170810
pDataBase = '/Volumes/COBOLT/MWT';
pData = fullfile(fileparts(pM),'Data');
% add sub function folder
addpath(fullfile(pM,'_Functions'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170810


%% GET STRAIN INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%


%% MAKE OVER ALL TABLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170810
T = table;
T.group = groupnames;
T.gene = genenames;
T.strain = strainnames;
TALL = T;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170810


%% MAKE INFO TABLE: REV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815
fprintf('\n\n** reversals **\n');
% make empty table
T = table;
T.strain = strainnames;
colnames = {'rev_file_source','resp_c_N','rev_c_manova_g','rev_c_manova_e','rev_c_manova_int',...
                'rev_c_ph_w0w4','rev_c_ph_w0m0','rev_c_ph_w0m4',...
                'rev_c_ph_w4m0','rev_c_ph_w4m4','rev_c_ph_m0m4',...
                'rev_c_spw_w0w4','rev_c_spw_w0m0','rev_c_spw_w0m4',...
                'rev_c_spw_w4w0','rev_c_spw_w4m4','rev_c_spw_m0m4',...
                'rev_hablevel_w0w4'};
coltype = cellfunexpr(colnames','double');
coltype([1:2 12:17]) = {'cell'};
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
    HabLevel = sortN2first(HabLevel.group,HabLevel.mean);
    
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
            case 'rev_hablevel_w0w4'
                a = HabLevel.mean(ismember(HabLevel.group,'N2_400mM')) ...
                    - HabLevel.mean(ismember(HabLevel.group,'N2'));
                a
                return
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815


%% MAKE INFO TABLE: CURVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815
fprintf('\n\n** curve **\n');
% make empty table
T = table;
T.strain = strainnames;
colnames = {'curve_file_source','curve_N',...
            'curve_wt','curve_wt400',...
            'curve_wt_pct','curve_mt_pct',...
            'curve_wt_pct_ttest','curve_m_pct_ttest',...
            'curve_pct_anova'};
coltype = cellfunexpr(colnames','double');
coltype([1:2 12:end]) = {'cell'};
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
%     RM = MWTSet.Stats.RevFreq.Curve.rmanova;
%     PHC = MWTSet.Stats.RevFreq.Curve.posthoc.factors;
%     PHCbytap = MWTSet.Stats.RevFreq.Curve.posthoc.factors_by_tap;

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815




%% MAKE INFO TABLE: ACC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815
fprintf('\n\n** acceleration **\n');
% make empty table
T = table;
T.strain = strainnames;
colnames = {'acc_file_source','acc_c_N','acc_c_manova_g','rev_c_manova_e','rev_c_manova_int',...
                'rev_c_ph_w0w4','rev_c_ph_w0m0','rev_c_ph_w0m4',...
                'rev_c_ph_w4m0','rev_c_ph_w4m4',...
                'rev_c_ph_m0m4',...
                'rev_c_spw_w0w4','rev_c_spw_w0m0','rev_c_spw_w0m4',...
                'rev_c_spw_w4w0','rev_c_spw_w4m4',...
                'rev_c_spw_m0m4'};
colnames = regexprep(colnames,'rev','acc');
coltype = cellfunexpr(colnames','double');
coltype([1:2 12:end]) = {'cell'};
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

    
    % get shared data ---------------------------------------------20170815
    load(pData); % load data
    N = MWTSet.Graph.AccProb.N(1,:)';
    G = MWTSet.Graph.AccProb.groupname; 
    % patch for strains without rtype analysis
    if ~ismember(fieldnames(MWTSet.Stats.AccProb),'rmanova')
        cnlist = 1:2; % only go through the first two
    else
        RM = MWTSet.Stats.AccProb.rmanova;
        PHC = MWTSet.Stats.AccProb.posthoc.factors;
        PHCbytap = MWTSet.Stats.AccProb.posthoc.factors_by_tap;
        cnlist = 1:numel(colnames); % go through all data
    end
    %--------------------------------------------------------------20170815
    
    % treatment by colname ----------------------------------------20170815
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
    %--------------------------------------------------------------20170815
end
TALL = outerjoin(TALL,T,'Key','strain','MergeKey',1); % put in overall table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815


%% INTERPRET RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815
psig = 0.05;
% curve -----------------------------------------------------------20170815
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
    if mut== true && wt == true && wmc==true % mutant wildtype: mut yes, wt yes, m=w
        decision = 'wild-type';
    elseif mut==true && wt==true && wmc==false % intermediate: mutant yes, wt yes, m~w
        decision = 'intermediate';
    elseif mut==false && wt==true && wmc~=false % ko: mut no, wt yes, m~w
        decision = 'ko';
    else % repeat exp: wt no
        decision = 'repeat experiment'; 
    end
    
    % record
    TALL.(colname){si} = decision;
end
%------------------------------------------------------------------20170815

% reversal --------------------------------------------------------20170815
colname = 'reversal_decision';
TALL.(colname) = cell(size(TALL,1),1);
for si = 1:size(TALL,1)
    clear wt mut wmc decision     % reset
    % - wildtype effect
    wtc = TALL.rev_c_ph_w0w4(si);
    wth = TALL.rev_c_spw_w0w4{si};
    regexp(wth,'all|(28|29|30)')
    % -- wt yes = 0 vs 400 < 0.05 & 400 hab level < 0 hab level
    % = has alcohol effect
    % -- wt no = otherwise 
    % = no alcohol effect
    % 
    % - mutant effect
    % -- mut yes = 0 vs 400 < 0.05 & 400 hab level < 0 hab level
    % -- m=w
    % - m0 = w0  & m4 = w4
    %  = has an wildtype effect
    % -- m~w
    % = has in between alcohol effect
    % -- mut no = otherwise
    % = no alcohol effect
    % 
    % - decision
    % mutant wildtype: mut yes, wt yes, m=w
    % intermediate: mutant yes, wt yes, m~w
    % ko: mut no, wt yes, m~w
    % repeat exp: wt no
    % record
    TALL.(colname){si} = decision;
end
%------------------------------------------------------------------20170815


% acceleration
% - wildtype effect
%     -- wt yes = 0 vs 400 < 0.05 & 400 hab level < 0 hab level
%                 = has alcohol effect
%     -- wt no = otherwise 
%                 = no alcohol effect
%     
% - mutant effect
%     -- mut yes = 0 vs 400 < 0.05 & 400 hab level < 0 hab level
%         -- m=w
%             - m0 = w0  & m4 = w4
%                  = has an wildtype effect
%         -- m~w
%                 = has in between alcohol effect
%     -- mut no = otherwise
%                 = no alcohol effect
%                 
% - decision
%    mutant wildtype: mut yes, wt yes, m=w
%    intermediate: mutant yes, wt yes, m~w
%    ko: mut no, wt yes, m~w
%    repeat exp: wt no
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170815

%% qualifier -----------------------------------------------------20170725-
% T = table;
% T.strain = TALL.strain;
% colnames = {'revq_wt_area_c','revq_mut_area_c'};
% % make empty table
% for ci = 1:numel(colnames)
%     cn = colnames{ci};
%     switch cn
%         case 'revq_wt_area_c'
%             A = cell(size(T,1),1);
%             a = TALL.rev_wt_area_ttest < 0.05;
%             c = TALL.rev_c_ph_w0w4 < 0.05;
%             i = all([a c],2);
%             A(i) = cellfunexpr(A(i),'both');
%             i = all([~a c],2);
%             A(i) = cellfunexpr(A(i),'curve');
%             i = all([a ~c],2);
%             A(i) = cellfunexpr(A(i),'area');
%             i = all([~a ~c],2);
%             A(i) = cellfunexpr(A(i),'none');
%             T.(cn) = A;
%             
%         case 'revq_mut_area_c'
%             A = cell(size(T,1),1);
%             a = TALL.rev_mut_area_ttest < 0.05;
%             c = TALL.rev_c_ph_m0m4 < 0.05;
%             i = all([a c],2);
%             A(i) = cellfunexpr(A(i),'both');
%             i = all([~a c],2);
%             A(i) = cellfunexpr(A(i),'curve');
%             i = all([a ~c],2);
%             A(i) = cellfunexpr(A(i),'area');
%             i = all([~a ~c],2);
%             A(i) = cellfunexpr(A(i),'none');
%             T.(cn) = A;
%     end
% end
% TALL = outerjoin(TALL,T,'Key','strain','MergeKey',1); % put in overall table
% ----------------------------------------------------------------20170725-

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170725%








%% MAKE INFO TABLE: ACC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%XXXXXXXX%
% T = table;
% T.group = groupnames;
% T.gene = genenames;
% T.strain = strainnames;
% colnames = {'curve_N','curve_wt_sig','curve_mut_ko','curve_mut_reduced',...
%             'resp_N',...
%                 'rev_wt_area_ttest','rev_mut_area_ttest','rev_wt_sig','rev_mut_ko',...
%                 'acc_wt_sig','acc_mut_ko'};
% 
% for ci = 1:numel(colnames)
%     cn = colnames{ci}; % get column name
%     % treatment by colname
%     switch cn
%         case 'rev_wt_area_ttest'
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 pdata = fullfile(pstrains{si},'TWR_Area','TWR.mat');
%                 if ~exist(pdata,'file'); error('missing file'); end                
%                 if exist(pdata,'file')   
%                     % load data
%                     load(pdata);
%                     % get relevant number
%                     pvalue = MWTSet.area_pctctrl.RevFreq.ttest_against0.N2_400mM.p;
%                     % get stats matching measure name
%                     p = pvalues(i);
%                     A{si} = p;
%                 end
%             end
%             
%         case 'rev_mut_area_ttest'
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 pdata = fullfile(pstrains{si},'TWR_Area','TWR.mat');
%                 if ~exist(pdata,'file'); error('missing file'); end                
%                 if exist(pdata,'file')   
%                     % load data
%                     load(pdata);
%                     % get strain field name
%                     a = strainname{si};
%                     a = regexprep(a,' New','');
%                     a = sprintf('%s_400mM',a);
%                     % get relevant number
%                     pvalue = MWTSet.area_pctctrl.RevFreq.ttest_against0.(a).p;
%                     % get stats matching measure name
%                     p = pvalues(i);
%                     A{si} = p;
%                 end
%             end
% 
%         case 'rev_wt_sig' 
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 dancename = 'Dance_ShaneSpark4';
%                 pdata = fullfile(pstrains{si},'TWR',dancename,'RMANOVA.txt');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_ShaneSpark5';
%                     pdata = fullfile(pstrains{si},dancename,'RMANOVA.txt');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     % find stats
%                     a = D(regexpcellout(D,'^N2(*)N2_400mM, p'));
%                     pvalues = regexpcellout(a,'(?<=^N2(*)N2_400mM, )p(<|=).+','match');
%                     % find measure name
%                     a = D(regexpcellout(D,'(?<=(-{5}.Rev))\w+'));
%                     msrs = regexpcellout(a,'(?<=(-{5}.Rev))\w+','match');
%                     i = ismember(msrs,'Freq'); 
%                     % get stats matching measure name
%                     p = pvalues(i);
%                     % if p is n.s.
%                     if strcmp(p,'p=n.s.')
%                         A{si} = 'no'; % mark not ok
%                     else
%                         % if p is significant
%                         % mark ok
%                         A{si} = 'yes';
%                     end
%                 end
%             end
%             
%         case 'resp_N' % reversal plate number
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 % get files
%                 dancename = 'Dance_ShaneSpark4';
%                 pdata = fullfile(pstrains{si},'TWR',dancename,'Dance_ShaneSpark4.mat');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_ShaneSpark5';
%                     pdata = fullfile(pstrains{si},dancename,'Dance_ShaneSpark5.mat');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 D = load(pdata);
%                 D = D.MWTSet.MWTDB.groupname;
%                 % tabulate
%                 D = tabulate(D);
%                 % sort N2 first
%                 D = sortN2first(D(:,1),D(:,2));
%                 % get number
%                 a = cellfun(@num2str,D,'UniformOutput',0)';
%                 % transform into text strin
%                 a = strjoin(a',', ');
%                 % put in output array
%                 A{si} = a;
%             end
%             
%         case 'rev_mut_ko' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 dancename = 'Dance_ShaneSpark4';
%                 pdata = fullfile(pstrains{si},'TWR',dancename,'RMANOVA.txt');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_ShaneSpark5';
%                     pdata = fullfile(pstrains{si},dancename,'RMANOVA.txt');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     % find stats
%                     s = strainnames{si};
%                     s = regexprep(s,' New','');
%                     str = sprintf('^%s[*]%s_400mM, p',s,s);
%                     a = D(regexpcellout(D,str));
%                     str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
%                     pvalues = regexpcellout(a,str,'match');
%                     % find measure name
%                     a = D(regexpcellout(D,'(?<=(-{5}.Rev))\w+'));
%                     msrs = regexpcellout(a,'(?<=(-{5}.Rev))\w+','match');
%                     i = ismember(msrs,'Freq'); 
%                     % get stats matching measure name
%                     p = pvalues(i);
%                     if strcmp(p,'p=n.s.')   % if p is n.s.
%                         A{si} = 'yes'; % mark ko
%                     else % if p is significant
%                         A{si} = 'no'; % mark no ko
%                     end
%                 end
%             end
%             
%         case 'acc_wt_sig' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 dancename = 'Dance_rType';
%                 pdata = fullfile(pstrains{si},'TAR',dancename,'AccProb RMANOVA.txt');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_rType2';
%                     pdata = fullfile(pstrains{si},dancename,'AccProb RMANOVA.txt');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     % find stats
%                     s = 'N2';
%                     str = sprintf('^%s[*]%s_400mM, p',s,s);
%                     a = D(regexpcellout(D,str));
%                     str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
%                     pvalues = regexpcellout(a,str,'match');
%                     p = pvalues;
%                     % if p is n.s.
%                     if strcmp(p,'p=n.s.')
%                         A{si} = 'no'; % mark not ok
%                     else
%                         % if p is significant
%                         % mark ok
%                         A{si} = 'yes';
%                     end
%                 end
%             end
% 
%         case 'acc_mut_ko' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 dancename = 'Dance_rType';
%                 pdata = fullfile(pstrains{si},'TAR',dancename,'AccProb RMANOVA.txt');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_rType2';
%                     pdata = fullfile(pstrains{si},dancename,'AccProb RMANOVA.txt');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     % find stats
%                     s = strainnames{si};
%                     s = regexprep(s,' New','');
%                     str = sprintf('^%s[*]%s_400mM, p',s,s);
%                     a = D(regexpcellout(D,str));
%                     str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
%                     pvalues = regexpcellout(a,str,'match');
%                     p = pvalues;
%                     if strcmp(p,'p=n.s.') % if p is n.s.
%                         A{si} = 'yes'; % marked ko
%                     else % if p is significant
%                         A{si} = 'no'; % mark not ko
%                     end
%                 end
%             end
%         
%         case 'curve_N'
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 s = strainnames{si};
%                 s = regexprep(s,' New','');
%                 pdata = fullfile(pstrains{si},'Dance_InitialEtohSensitivityPct','curve MANOVA.txt');
%                 if ~exist(pdata,'file')
%                    pdata = fullfile(pstrains{si},'Etoh sensitivity','InitialEtohSensitivityPct','curve MANOVA.txt');
%                    if ~exist(pdata,'file')
%                         error('no file');
%                    end
%                 end
%                
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     a = D(regexpcellout(D,'^n = '));
%                     a = regexpcellout(a,'\d+','match');
%                     b = D(regexpcellout(D,'^gname = '));
%                     b = regexprep(b,'gname = ','');
%                     b = regexpcellout(b,', ','split');
%                     a = sortN2first(b',a')';
%                     A{si} = strjoin(a,', ');
%                 end
%             end
%             
%         case 'curve_wt_sig' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 s = strainnames{si};
%                 s = regexprep(s,' New','');
%                 pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
%                 if ~exist(pdata,'file')
%                    error('no file');
%                 end
%                
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     r = D{1}; % first paragraph = body curve
%                     % find stats
%                     a = regexp(r,',','split')';
%                     a = regexprep(a,' ','');
%                     a = regexpcellout(a,'^p((=)|(<))0[.]\d+','match');
%                     a(cellfun(@isempty,a)) = [];
%                     p = a{1}; % the first p value is wildtype
%                     % if p is n.s.
%                     if strcmp(p,'p=n.s.')
%                         A{si} = 'no'; % mark not ok
%                     else
%                         % if p is significant
%                         % mark ok
%                         A{si} = 'yes';
%                     end
%                 end
%             end
% 
%         case 'curve_mut_ko' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 s = strainnames{si};
%                 s = regexprep(s,' New','');
%                 pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
%                 if ~exist(pdata,'file')
%                    error('no file');
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     r = D{1}; % first paragraph = body curve
%                     % find stats
%                     a = regexp(r,',','split')';
%                     a = regexprep(a,' ','');
%                     a = regexpcellout(a,'^p((=)|(<))0[.]\d+','match');
%                     a(cellfun(@isempty,a)) = [];
%                     p = a{2}; % the 2nd p value is mutant
%                     if strcmp(p,'p=n.s.') % if p is n.s.
%                         A{si} = 'yes'; % mark ko
%                     else % if p is significant
%                         A{si} = 'no'; % mark not ko
%                     end
%                 end
%             end
% 
%         case 'curve_mut_reduced' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 s = strainnames{si};
%                 s = regexprep(s,' New','');
%                 pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
%                 if ~exist(pdata,'file')
%                    error('no file');
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     r = D{1}; % first paragraph = body curve
%                     % find stats
%                     a = regexp(r,',','split')';
%                     a = regexprep(a,' ','');
%                     a = a(regexpcellout(a,'^p'));
%                     a = regexprep(a,'([)][.]$)|([)])','');
%                     p = a{3}; % the 3rd p value is comparison 
%                     if strcmp(p,'p=n.s.') % if p is n.s.
%                         A{si} = 'no';
%                     else % if p is significant
%                         A{si} = 'yes'; 
%                     end
%                 end
%             end
%   
%     end
%     T.(cn) = A;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%


%% MAKE INFO TABLE: CURVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%XXXXXXXX%
% T = table;
% T.group = groupnames;
% T.gene = genenames;
% T.strain = strainnames;
% colnames = {'curve_N','curve_wt_sig','curve_mut_ko','curve_mut_reduced',...
%             'resp_N',...
%                 'rev_wt_area_ttest','rev_mut_area_ttest','rev_wt_sig','rev_mut_ko',...
%                 'acc_wt_sig','acc_mut_ko'};
% 
% for ci = 1:numel(colnames)
%     cn = colnames{ci}; % get column name
%     % treatment by colname
%     switch cn
%         case 'rev_wt_area_ttest'
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 pdata = fullfile(pstrains{si},'TWR_Area','TWR.mat');
%                 if ~exist(pdata,'file'); error('missing file'); end                
%                 if exist(pdata,'file')   
%                     % load data
%                     load(pdata);
%                     % get relevant number
%                     pvalue = MWTSet.area_pctctrl.RevFreq.ttest_against0.N2_400mM.p;
%                     % get stats matching measure name
%                     p = pvalues(i);
%                     A{si} = p;
%                 end
%             end
%             
%         case 'rev_mut_area_ttest'
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 pdata = fullfile(pstrains{si},'TWR_Area','TWR.mat');
%                 if ~exist(pdata,'file'); error('missing file'); end                
%                 if exist(pdata,'file')   
%                     % load data
%                     load(pdata);
%                     % get strain field name
%                     a = strainname{si};
%                     a = regexprep(a,' New','');
%                     a = sprintf('%s_400mM',a);
%                     % get relevant number
%                     pvalue = MWTSet.area_pctctrl.RevFreq.ttest_against0.(a).p;
%                     % get stats matching measure name
%                     p = pvalues(i);
%                     A{si} = p;
%                 end
%             end
% 
%         case 'rev_wt_sig' 
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 dancename = 'Dance_ShaneSpark4';
%                 pdata = fullfile(pstrains{si},'TWR',dancename,'RMANOVA.txt');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_ShaneSpark5';
%                     pdata = fullfile(pstrains{si},dancename,'RMANOVA.txt');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     % find stats
%                     a = D(regexpcellout(D,'^N2(*)N2_400mM, p'));
%                     pvalues = regexpcellout(a,'(?<=^N2(*)N2_400mM, )p(<|=).+','match');
%                     % find measure name
%                     a = D(regexpcellout(D,'(?<=(-{5}.Rev))\w+'));
%                     msrs = regexpcellout(a,'(?<=(-{5}.Rev))\w+','match');
%                     i = ismember(msrs,'Freq'); 
%                     % get stats matching measure name
%                     p = pvalues(i);
%                     % if p is n.s.
%                     if strcmp(p,'p=n.s.')
%                         A{si} = 'no'; % mark not ok
%                     else
%                         % if p is significant
%                         % mark ok
%                         A{si} = 'yes';
%                     end
%                 end
%             end
%             
%         case 'resp_N' % reversal plate number
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 % get files
%                 dancename = 'Dance_ShaneSpark4';
%                 pdata = fullfile(pstrains{si},'TWR',dancename,'Dance_ShaneSpark4.mat');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_ShaneSpark5';
%                     pdata = fullfile(pstrains{si},dancename,'Dance_ShaneSpark5.mat');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 D = load(pdata);
%                 D = D.MWTSet.MWTDB.groupname;
%                 % tabulate
%                 D = tabulate(D);
%                 % sort N2 first
%                 D = sortN2first(D(:,1),D(:,2));
%                 % get number
%                 a = cellfun(@num2str,D,'UniformOutput',0)';
%                 % transform into text strin
%                 a = strjoin(a',', ');
%                 % put in output array
%                 A{si} = a;
%             end
%             
%         case 'rev_mut_ko' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 dancename = 'Dance_ShaneSpark4';
%                 pdata = fullfile(pstrains{si},'TWR',dancename,'RMANOVA.txt');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_ShaneSpark5';
%                     pdata = fullfile(pstrains{si},dancename,'RMANOVA.txt');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     % find stats
%                     s = strainnames{si};
%                     s = regexprep(s,' New','');
%                     str = sprintf('^%s[*]%s_400mM, p',s,s);
%                     a = D(regexpcellout(D,str));
%                     str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
%                     pvalues = regexpcellout(a,str,'match');
%                     % find measure name
%                     a = D(regexpcellout(D,'(?<=(-{5}.Rev))\w+'));
%                     msrs = regexpcellout(a,'(?<=(-{5}.Rev))\w+','match');
%                     i = ismember(msrs,'Freq'); 
%                     % get stats matching measure name
%                     p = pvalues(i);
%                     if strcmp(p,'p=n.s.')   % if p is n.s.
%                         A{si} = 'yes'; % mark ko
%                     else % if p is significant
%                         A{si} = 'no'; % mark no ko
%                     end
%                 end
%             end
%             
%         case 'acc_wt_sig' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 dancename = 'Dance_rType';
%                 pdata = fullfile(pstrains{si},'TAR',dancename,'AccProb RMANOVA.txt');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_rType2';
%                     pdata = fullfile(pstrains{si},dancename,'AccProb RMANOVA.txt');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     % find stats
%                     s = 'N2';
%                     str = sprintf('^%s[*]%s_400mM, p',s,s);
%                     a = D(regexpcellout(D,str));
%                     str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
%                     pvalues = regexpcellout(a,str,'match');
%                     p = pvalues;
%                     % if p is n.s.
%                     if strcmp(p,'p=n.s.')
%                         A{si} = 'no'; % mark not ok
%                     else
%                         % if p is significant
%                         % mark ok
%                         A{si} = 'yes';
%                     end
%                 end
%             end
% 
%         case 'acc_mut_ko' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 dancename = 'Dance_rType';
%                 pdata = fullfile(pstrains{si},'TAR',dancename,'AccProb RMANOVA.txt');
%                 if ~exist(pdata,'file')
%                     dancename = 'Dance_rType2';
%                     pdata = fullfile(pstrains{si},dancename,'AccProb RMANOVA.txt');
%                     if ~exist(pdata,'file')
%                         error('missing file');
%                     end
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     % find stats
%                     s = strainnames{si};
%                     s = regexprep(s,' New','');
%                     str = sprintf('^%s[*]%s_400mM, p',s,s);
%                     a = D(regexpcellout(D,str));
%                     str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
%                     pvalues = regexpcellout(a,str,'match');
%                     p = pvalues;
%                     if strcmp(p,'p=n.s.') % if p is n.s.
%                         A{si} = 'yes'; % marked ko
%                     else % if p is significant
%                         A{si} = 'no'; % mark not ko
%                     end
%                 end
%             end
%         
%         case 'curve_N'
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 s = strainnames{si};
%                 s = regexprep(s,' New','');
%                 pdata = fullfile(pstrains{si},'Dance_InitialEtohSensitivityPct','curve MANOVA.txt');
%                 if ~exist(pdata,'file')
%                    pdata = fullfile(pstrains{si},'Etoh sensitivity','InitialEtohSensitivityPct','curve MANOVA.txt');
%                    if ~exist(pdata,'file')
%                         error('no file');
%                    end
%                 end
%                
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     a = D(regexpcellout(D,'^n = '));
%                     a = regexpcellout(a,'\d+','match');
%                     b = D(regexpcellout(D,'^gname = '));
%                     b = regexprep(b,'gname = ','');
%                     b = regexpcellout(b,', ','split');
%                     a = sortN2first(b',a')';
%                     A{si} = strjoin(a,', ');
%                 end
%             end
%             
%         case 'curve_wt_sig' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 s = strainnames{si};
%                 s = regexprep(s,' New','');
%                 pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
%                 if ~exist(pdata,'file')
%                    error('no file');
%                 end
%                
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     r = D{1}; % first paragraph = body curve
%                     % find stats
%                     a = regexp(r,',','split')';
%                     a = regexprep(a,' ','');
%                     a = regexpcellout(a,'^p((=)|(<))0[.]\d+','match');
%                     a(cellfun(@isempty,a)) = [];
%                     p = a{1}; % the first p value is wildtype
%                     % if p is n.s.
%                     if strcmp(p,'p=n.s.')
%                         A{si} = 'no'; % mark not ok
%                     else
%                         % if p is significant
%                         % mark ok
%                         A{si} = 'yes';
%                     end
%                 end
%             end
% 
%         case 'curve_mut_ko' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 s = strainnames{si};
%                 s = regexprep(s,' New','');
%                 pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
%                 if ~exist(pdata,'file')
%                    error('no file');
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     r = D{1}; % first paragraph = body curve
%                     % find stats
%                     a = regexp(r,',','split')';
%                     a = regexprep(a,' ','');
%                     a = regexpcellout(a,'^p((=)|(<))0[.]\d+','match');
%                     a(cellfun(@isempty,a)) = [];
%                     p = a{2}; % the 2nd p value is mutant
%                     if strcmp(p,'p=n.s.') % if p is n.s.
%                         A{si} = 'yes'; % mark ko
%                     else % if p is significant
%                         A{si} = 'no'; % mark not ko
%                     end
%                 end
%             end
% 
%         case 'curve_mut_reduced' % effect of mutant, if not sig that means ko
%             % set up output array
%             A = cell(numel(strainnames),1);
%             for si = 1:numel(strainnames)
%                 s = strainnames{si};
%                 s = regexprep(s,' New','');
%                 pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
%                 if ~exist(pdata,'file')
%                    error('no file');
%                 end
%                 if exist(pdata,'file')   
%                     fid = fopen(pdata,'r');
%                     D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
%                     fclose(fid);
%                     D = [D{1:end-1}];
%                     r = D{1}; % first paragraph = body curve
%                     % find stats
%                     a = regexp(r,',','split')';
%                     a = regexprep(a,' ','');
%                     a = a(regexpcellout(a,'^p'));
%                     a = regexprep(a,'([)][.]$)|([)])','');
%                     p = a{3}; % the 3rd p value is comparison 
%                     if strcmp(p,'p=n.s.') % if p is n.s.
%                         A{si} = 'no';
%                     else % if p is significant
%                         A{si} = 'yes'; 
%                     end
%                 end
%             end
%   
%     end
%     T.(cn) = A;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%


%% QUALIFIER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%XXXXXXXX
% Q = T(:,{'curve_mut_reduced','rev_mut_ko','acc_mut_ko'});
% A = table2cell(Q);
% Q.type = cell(size(Q,1),1);
% 
% i = regexpcellout(Q.curve_mut_reduced,'yes') & regexpcellout(Q.rev_mut_ko,'yes') & regexpcellout(Q.acc_mut_ko,'yes');
% Q.type(i) = {'all'};
% i = regexpcellout(Q.curve_mut_reduced,'yes') & regexpcellout(Q.rev_mut_ko,'no') & regexpcellout(Q.acc_mut_ko,'yes');
% Q.type(i) = {'curve & acc'};
% i = regexpcellout(Q.curve_mut_reduced,'yes') & regexpcellout(Q.rev_mut_ko,'no') & regexpcellout(Q.acc_mut_ko,'no');
% Q.type(i) = {'curve'};
% i = regexpcellout(Q.curve_mut_reduced,'yes') & regexpcellout(Q.rev_mut_ko,'yes') & regexpcellout(Q.acc_mut_ko,'no');
% Q.type(i) = {'curve & rev'};
% i = regexpcellout(Q.curve_mut_reduced,'no') & regexpcellout(Q.rev_mut_ko,'yes') & regexpcellout(Q.acc_mut_ko,'no');
% Q.type(i) = {'rev'};
% i = regexpcellout(Q.curve_mut_reduced,'no') & regexpcellout(Q.rev_mut_ko,'no') & regexpcellout(Q.acc_mut_ko,'no');
% Q.type(i) = {'none'};
% i = regexpcellout(Q.curve_mut_reduced,'no') & regexpcellout(Q.rev_mut_ko,'yes') & regexpcellout(Q.acc_mut_ko,'yes');
% Q.type(i) = {'rev & acc'};
% T.type = Q.type;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%


%% CONCLUSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%XXXXXXXX%
% T.conclusion = cell(size(T,1),1);
% % clist = {'
% i = regexpcellout(T.curve_mut_reduced,'yes') & regexpcellout(T.rev_mut_ko,'yes') & regexpcellout(T.acc_mut_ko,'yes');
% T.conclusion(i) = {'all'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%


%% EXPORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%
writetable(TALL,fullfile(pM,'Result summary.csv'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%



























