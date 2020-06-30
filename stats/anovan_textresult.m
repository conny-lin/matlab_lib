function [result,T] = anovan_textresult(tbl,displayopt,varargin)
%% display results of multiway anova
% updated 20160630

%% default
pvlimit = 0.001;
Fdigit = 2;
pvspace = true;
alpha = 0.05;
%% varargin processor
vararginProcessor
if nargin == 1
    displayopt = 0;
end

result= '';

%% transform t into table (2016b)
if istable(tbl)
    T = tbl; % do nothing, table ready to write
    % clean up factor texts
    factors = tbl.Properties.RowNames(1:end-1);
    factors = regexprep(factors,'[(]Intercept[)][:]','');
    factors = regexprep(factors,':','*');
    

    % create factor texts
    for x = 1:numel(factors)
        f = tbl.F(x);
        p = print_pvalue(tbl.pValue(x),pvlimit,alpha,pvspace);
        fn = factors{x};
        df1 = tbl.DF(x);
        df2 = tbl.DF(end);
        if x ==1
            if pvspace
                str = sprintf('F(%%d,%%d)%%s = %%.%df, %%s',Fdigit);
            else
                str = sprintf('F(%%d,%%d)%%s=%%.%df, %%s',Fdigit);
            end
            result = sprintf(str,df1,df2,fn,f,p);
        else
            if pvspace
                str = sprintf('%%s\nF(%%d,%%d)%%s = %%.%df, %%s',Fdigit);
            else
                str = sprintf('%%s\nF(%%d,%%d)%%s=%%.%df, %%s',Fdigit);
            end
            result = sprintf(str,result,df1,df2,fn,f,p);
        end
    end
    
else

    %% transform t into table (2013b)
    colnames = tbl(1,2:end);
    colnames = regexprep(colnames,'[.]','');
    colnames = regexprep(colnames,' ','');
    colnames = regexprep(colnames,'?','');
    colnames = regexprep(colnames,'Prob>F','Prob');
    rownames = tbl(2:end,1);
    d = tbl(2:end,2:end);
    d(cellfun(@isempty,d)) = {NaN};
    d = cell2mat(d);
    T1 = array2table(d,'RowNames',rownames,'VariableNames',colnames);
    T = table;
    T.v = rownames;
    T = [T T1];

    factors = 1:find(ismember(rownames,'Error'))-1;
    result = cell(numel(factors),1);
    error = T.df('Error');
    fx = 1;
    for x = factors
        % get string components
        factorname = rownames{x,1};
        df = T.df(factorname); 
        fvalue = T.F(factorname);
        pvalue = print_pvalue(T.Prob(factorname),pvlimit,alpha,pvspace);
        % creat string 
        str = sprintf('%%s, F(%%d,%%d) = %%.%df, %%s',Fdigit);
        a = sprintf(str,factorname,df,error,fvalue,pvalue);
        result{fx,1} = a;
        % if request to display
        if displayopt == 1
            fprintf([str,'\n'],factorname,df,error,fvalue,pvalue);
        end
        fx = fx +1; % go to next row
    end



end