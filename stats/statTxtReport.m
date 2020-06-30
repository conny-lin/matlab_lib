function str = statTxtReport(statName,df,tstat,p,varargin)

%% default
alpha = 0.05;
vararginProcessor


%% cal
if p<0.001
    pvalue = 'p<0.001';
elseif p > alpha
    pvalue = 'p=n.s.';
else
    pvalue = sprintf('p=%.3f',p);
end
str = sprintf('%s(%d)=%.3f, %s',statName,df,tstat,pvalue);

