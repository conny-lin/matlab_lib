function [a] = SE(A)
a = std(A,1,2)/sqrt(size(A,2));
end
