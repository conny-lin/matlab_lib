function [text,p,ci,s] = ttest_auto(X,Y,varargin)

pvlimit = 0.001;
alpha = 0.05;
spacey = true;
Fdigit = 2;
vararginProcessor

%%
[h,p,ci,s] = ttest(X,Y);
pvs = print_pvalue(p,pvlimit,alpha,spacey);

if ~spacey
    str = sprintf('t(%%d)=%%.%df, %%s',Fdigit);
else
    str = sprintf('t(%%d) = %%.%df, %%s',Fdigit);

end
text = sprintf(str,s.df,s.tstat,pvs);
