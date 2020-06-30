function T = crosstab_table(v1,v2,legend1,legend2,varargin)


%% setting

%% downstream processing -----------------
% translate user factors into anova input
v1t = translate_legend(legend1.id, legend1.abv, v1);
v2t = translate_legend(legend2.id, legend2.abv, v2);

%% =========== DEMOGRAPHIC DESCRIPTIVE ===========

[ST,~,~,vn] = crosstab(v1t,v2t);
%% columns
colnames = vn(:,1);
colnames(cellfun(@isempty,colnames))= [];
[i,j] = ismember(legend1.abv,colnames);
colnames = colnames(j(i));
ST = ST(j(i),:);

%% row names
rownames = vn(:,2);
rownames(cellfun(@isempty,rownames)) = [];
[i,j] = ismember(legend2.abv,rownames);
rownames = rownames(j(i));
ST = ST(:,j(i));


%% table
T = table;
T.var = colnames;
A = array2table(ST,'VariableNames',rownames);
T = [T A];
