function [A] = makeindex(S)
A.text = S;
A.legend = unique(S); 
a = A.legend;
for x = 1:numel(a)
    i = ismember(A.text,A.legend(x));
    A.code(i,1)= x;
    A.legendindex{x,1} = find(i); 
end