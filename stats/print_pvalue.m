function str = print_pvalue(pvalue,pvlimit,alpha,spacey)

if nargin <3
    alpha = 0.05;
end

if nargin < 2
    pvlimit = 0.001;
end

if nargin <4
   spacey = true; 
end

if pvlimit > alpha
    error('lower bound pvalue can not be bigger than alpha');
end

a = num2str(pvlimit);
pvdigit = numel(regexprep(a,'\<0[.]',''));

if pvalue >= pvlimit && pvalue < alpha
    if ~spacey
        str = sprintf(sprintf('p=%%.%df',pvdigit),pvalue);
    else
        str = sprintf(sprintf('p = %%.%df',pvdigit),pvalue);
    end

    
elseif pvalue >= alpha
    if ~spacey
        str = 'p=n.s.';
    else
        str = 'p = n.s.';
    end
else
    if ~spacey
        str = sprintf(sprintf('p<%%.%df',pvdigit),pvlimit);
    else
        str = sprintf(sprintf('p < %%.%df',pvdigit),pvlimit);
    end
end



%% remove zero
str = regexprep(str,'0(?=[.]{1})','');

end