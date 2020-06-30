function CompArray = pairwisecomp_getpairs(dv)

ncomp = (numel(dv)*(numel(dv)-1))/2;
if iscell(dv)==1
    CompArray = cell(ncomp,2);
elseif isnumeric(dv)
    CompArray = nan(ncomp,2);
end
dvpair = dv;
n = 1;
for dvi = 1:numel(dv)
    dvpair = dvpair(2:end);
    for i = 1:numel(dvpair)
        CompArray(n,:) = [dv(dvi) dvpair(i)];
        n = n+1;
    end
end