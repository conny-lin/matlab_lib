function [tt,gnames] = multcompare_convt22016v(s)

%%
    [t,m,~,gnames] = multcompare(s,'Display','off');
    tt = array2table(t,'VariableNames',{'gname_1','gname_2','Lower','Difference','Upper','pValue'});
%     ismember(tt.gname1,gnames)
    tt.gname_1 = gnames(tt.gname_1);
    tt.gname_2 = gnames(tt.gname_2);
    