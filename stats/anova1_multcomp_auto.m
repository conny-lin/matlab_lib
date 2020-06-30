function [txt] = anova1_multcomp_auto(x,g)

    [text,T,p,s,t,ST] = anova1_autoresults(x,g);
    [tt,gnames] = multcompare_convt22016v(s);
    result = multcompare_text2016b(tt);
    
    %%
    txt = sprintf('%s\n%s',text,result);