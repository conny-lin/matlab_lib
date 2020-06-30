function result = anova_textresult(t)
if iscell(t)
    df = t{2,3};
    er = t{3,3};
    fvalue = t{2,5};
    pvalue = t{2,6};

elseif istable(t)
   df = t.df('Groups');
   er = t.df('Error');
   fvalue = t.F('Groups');
   pvalue = t.p('Groups');
end
    
str = 'F(%d,%d) = %.3f, %s';
pvs = print_pvalue(pvalue);
if pvalue < 0.0001; sign = '<'; pvalue = 0.0001; else sign = '='; end
result = sprintf(str,df,er,fvalue,pvs);
end