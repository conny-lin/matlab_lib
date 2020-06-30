function result = multcompare_text2016b(T,varargin)

%% setting
grpnames = {''};
pvlimit = 0.001;
alpha = 0.05;
sigOnly = false;
prefix = '';
vararginProcessor;

%% get variable names
if istable(T)
    a = T.Properties.VariableNames;
    a(ismember(a,{'Difference','StdErr','pValue','Upper','Lower'})) = [];
    varnames = a;
    % if significant results only
    if sigOnly
        T(T.pValue >= alpha,:) = [];
    end
    
    % if any left
    if ~isempty(T)
        var = T(:,varnames);
        % convert numeric to char
        for vi = 1:numel(varnames)
            a = var.(varnames{vi});
            if ~iscellstr(a)
                 a = num2cellstr(a);
                 v = varnames(vi);
                 v = regexprep(v,'_\d{1,}','');
                 v = cellfunexpr(a,char(v));
                 a = strjoinrows([v a],'');
                 var.(varnames{vi}) = a;
            end
        end
        var = strjoinrows(var,'*');

        % report restuls
        pvalues = T.pValue;
        for ri = 1:numel(pvalues)
            ptxt = print_pvalue(pvalues(ri),pvlimit,alpha);
            if ri==1
                result = sprintf('%s%s, %s',prefix,var{ri},ptxt);
            else
                result = sprintf('%s\n%s%s, %s',result,prefix,var{ri},ptxt);
            end
        end
    else
        result = 'all, p=n.s.';
    end
end

%% if numeric input
if isnumeric(T)
   var = strjoinrows(grpnames(T(:,1:2)),' x ');
   pvalues = T(:,6);

    for ri = 1:numel(pvalues)
        ptxt = print_pvalue(pvalues(ri),pvlimit,alpha);
        if ri==1
            result = sprintf('%s%s, %s',prefix,var{ri},ptxt);
        else
            result = sprintf('%s\n%s%s, %s',result,prefix,var{ri},ptxt);
        end
    end
    
end











