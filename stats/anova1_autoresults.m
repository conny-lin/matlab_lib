function [text,T,p,s,t,ST] = anova1_autoresults(x,group,varargin)

%% setting
displayopt = 'off';

%% process varargin
vararginProcessor

%% means
[gn,sd,se]= grpstats(x,group,{'gname','std','sem'});

%% anova
[p,t,s] = anova1(x,group,displayopt);
text = anova_textresult(t);

%%
a = t(2:end,2:end);
a(cellfun(@isempty,a)) = {NaN};
a = cell2mat(a);
rownames = t(2:end,1);
colnames = t(1,2:end);
colnames = regexprep(colnames,'Prob>F','p');
ST = array2table(a,'VariableNames',colnames,'RowNames',rownames);

%%
%% output table
if cellfun(@strcmp,gn,s.gnames) ~= numel(gn)
    [~,i,j]=  intersect(gn,s.gnames);
    sd = sd(i);
    se = se(i);
end

T = table;
T.gnames = s.gnames;
T.mean = s.means';
T.SE = se;
T.SD = sd;
T.N = s.n';


