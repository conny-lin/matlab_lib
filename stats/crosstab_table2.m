function T = crosstab_table2(A,B)

[T,~,~,legend] = crosstab(A, B);

%%
legend = regexprep(legend,' ','_');
legend = regexprep(legend,'-','_');

a = legend(:,2);
a(cellfun(@isempty,a)) = [];
if sum(regexpcellout(a,'^\d{1,}')) > 0
   a = strjoinrows([cellfunexpr(a,'c'),a],'');
end


b = legend(:,1);
b(cellfun(@isempty,b)) = [];
if sum(regexpcellout(b,'^\d{1,}')) > 0
   b = strjoinrows([cellfunexpr(b,'r'),b],'');
end

T = array2table(T);
T.Properties.VariableNames = a;
T.Properties.RowNames = b;