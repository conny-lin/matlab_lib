function [anovatext,phtext,T] = anova1_std(X,G,varargin)


%% default
posthocname = 'bonferroni';
pv = 0.05;

vararginProcessor
%%
[anovatext,T,p,s,t,ST] = anova1_autoresults(X, G);
[c,~,~,gnames] = multcompare(s,'ctype',posthocname,'display','off','alpha',pv);
[~,phtext,TC,~] = multcompare_pairinterpretation(c,gnames,'nsshow',1,'pvalue',pv);
phtext = char(phtext);