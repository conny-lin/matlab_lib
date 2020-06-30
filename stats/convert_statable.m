function ST = convert_statable(t)

%% get numeric values
a = t(2:end,2:end);
a(cellfun(@isempty,a)) = {NaN};
a = cell2mat(a);
%% deal with colnames
colnames = t(1,2:end);
colnames = regexprep(colnames,'Prob>F','p');
colnames = regexprep(colnames,'[.]','');
colnames = regexprep(colnames,' ','_');
colnames = regexprep(colnames,'[?]','');
%% get row names
rownames = t(2:end,1);



%%
ST = table;
ST.Source = rownames;
ST = [ST array2table(a,'VariableNames',colnames)];