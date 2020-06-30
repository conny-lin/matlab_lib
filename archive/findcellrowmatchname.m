function [match,failmatch,P] = findcellrowmatchname(cell2match,string)
% match = 1 is correct, 0= not correct
[string] = gencellfunexpr(cell2match,string);
i = cellfun(@regexp,cell2match,string,'UniformOutput',0);
failmatch = cellfun(@isempty,i);
match = logical(failmatch==0);
if sum(match) == size(cell2match,1);
    P = 1;
else
    P = 0;
end
end