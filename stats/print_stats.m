function stext = print_stats(type,df,er,pvalue)

p = print_pvalue(pvalue);
stext = sprintf('%s(%d) = %.3f, %s',type,df,er,p);

end