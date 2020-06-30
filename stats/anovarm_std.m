function [textout,DS] = anovarm_std(DataTable,rmName,factors,idname,dvname,varargin)
% -------------------------------------------------------------------------
% HELP | 20170816
% -------------------------------------------------------------------------
% DataTable = data table with col names corresponds to rmName, compName, factorName
% rmName = repeated measures column name
% factors = independent factors variable name in DataTable
% idname = variable name on the DataTable denoted individual samples
% dvname = dependent variable name on the DataTable
% -------------------------------------------------------------------------
%                           SETTINGS | 20170816
% -------------------------------------------------------------------------
alpha = 0.05;
pvlimit = 0.001;
% prefix = '';
% suffix = '';
vararginProcessor
% -------------------------------------------------------------------------
% decalre output arrays | 20170816
% -------------------------------------------------------------------------
textout = '';
DS = struct;
% -------------------------------------------------------------------------
% create rmanova input structural array | 20170814
% -------------------------------------------------------------------------
DS = anovarm_transformData(DataTable,rmName,factors,idname,dvname);
% -------------------------------------------------------------------------
%                       DATA VALIDATION | 20170816
%           (data can be lost after rmanova data transformation)
% -------------------------------------------------------------------------
% must have all groups 
% -------------------------------------------------------------------------
ga = unique(DS.Data_all.factors); 
gc = unique(DS.Data.factors);
if numel(gc) < numel(ga)
    warning('after rmanova transformation, not all groups have data, \ncan not continue');
    textout = '';
    disp(ga);
    tabulate(DS.Data.factors)
    return
end
% -------------------------------------------------------------------------
% each group must have more than 1 sample | 20170816
% -------------------------------------------------------------------------
D = DS.Data; % get data
a = tabulate(D.factors); % count groups
n = cell2mat(a(:,2)); % get number per groups
% if any is less than 2, can not continue
if any(n<2)
    warning('after rmanova transformation, some groups only have N ==1,\ncan not continue');
    return
end
% -------------------------------------------------------------------------
%                   EXTRACT INPUT COMPONENTS | 20170816
% -------------------------------------------------------------------------
% extract variable list | 20170814
% -------------------------------------------------------------------------
rmvartable = DS.rmtable;
rmlist = DS.rmu;
factorcombo = DS.factors;
D = DS.Data;
gpairs = DS.gpairs;
% -------------------------------------------------------------------------
% rmanova multi-factor  | 20170815
% -------------------------------------------------------------------------
rmTerms = sprintf('%s%d-%s%d~%s',rmName,rmlist(1),rmName,rmlist(end),factorcombo);
rmF = fitrm(D,rmTerms,'WithinDesign',rmvartable);
d = ranova(rmF);
DS.rmanova = d;
t = anovan_textresult(d, 0, 'pvlimit',pvlimit);
txt_rmanova = sprintf('*** RMANOVA(%s:%s) ***\n%s',rmName,factorcombo,t);
% -------------------------------------------------------------------------
% rmanova effect size | 20170816
% -------------------------------------------------------------------------
a = DS.rmanova;
d = effectsize_rmanova(a,factors,rmName);
DS.effectsize = d;
% -------------------------------------------------------------------------
% rmanova pairwise by each factor 
% -------------------------------------------------------------------------
txt_pw = '';
for i = 1:numel(factors)
    compName = factors{i};
    rmTerms = sprintf('%s%d-%s%d~%s',rmName,rmlist(1),rmName,rmlist(end),compName);
    rm = fitrm(D,rmTerms,'WithinDesign',rmvartable);
    t = multcompare(rm,compName);
    DS.posthoc.(compName) = t;
    % text output
    txt_pw = sprintf('%s\n*** Posthoc(Tukey) by %s ***',txt_pw,compName);
    if isempty(t)
        txt_pw = sprintf('%s\nAll comparison = n.s.\n',txt_pw);
    else
        t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alpha);
        txt_pw = sprintf('%s\n%s\n',txt_pw,t);
    end
end
% -------------------------------------------------------------------------
% comparison by factor 
% -------------------------------------------------------------------------
compName = 'factors';
rmTerms = sprintf('%s%d-%s%d~%s',rmName,rmlist(1),rmName,rmlist(end),compName);
rm = fitrm(D,rmTerms,'WithinDesign',rmvartable);
% between groups
t = multcompare(rm,compName);
t(~ismember(strjoinrows([t.([compName,'_1']) t.([compName,'_2'])],' x '),gpairs),:) =[];
DS.posthoc.(compName) = t; % put in toutput

% record
txt_fac = sprintf('*** Posthoc(Tukey)%s by %s ***',factorcombo,rmName); 
if isempty(t)
    txt_fac = sprintf('%s\nAll comparison = n.s.\n',txt_fac);
else
    t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alpha);
    txt_fac = sprintf('%s\n%s\n',txt_fac,t);
end
% -------------------------------------------------------------------------
% comparison by taps 
% -------------------------------------------------------------------------
compName = 'factors';
rmTerms = sprintf('%s%d-%s%d~%s',rmName,rmlist(1),rmName,rmlist(end),compName);
rm = fitrm(D,rmTerms,'WithinDesign',rmvartable);
t = multcompare(rm,compName,'By',rmName);
%  keep only unique comparisons
t(~ismember(strjoinrows([t.([compName,'_1']) t.([compName,'_2'])],' x '),gpairs),:) =[]; 
DS.posthoc.([compName,'_by_tap']) = t; % put in toutput
% record
txt_rm = sprintf('*** Posthoc(Tukey)%s by %s ***',factorcombo,rmName); 
if isempty(t)
    txt_rm = sprintf('%s\nAll comparison = n.s.\n',txt_rm);
else
    t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alpha);
    txt_rm = sprintf('%s\n%s\n',txt_rm,t);
end
% -------------------------------------------------------------------------
%                       TEXT DATA EXPORT
% -------------------------------------------------------------------------
textout = sprintf('%s\n%s\n%s\n%s',txt_rmanova,txt_pw,txt_fac,txt_rm);
% -------------------------------------------------------------------------



















