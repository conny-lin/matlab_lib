function postanalysis = posthoc_result(c,gnames)
nRow = size(c,1);
val = false(nRow,1);
for x = 1:nRow
    a(x,1:3) = c(x,3:5) < 0;
    b(x,1:3) = c(x,3:5) > 0;
end
val(sum(a,2) == 3) = true;
val(sum(b,2) == 3) = true;

% generate significant pairs
gref = c(val,1:2);
postanalysis = gnames(gref);
