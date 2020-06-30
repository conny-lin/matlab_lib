function u = getuniquegroup(d,nanopt)

%% get unique group including just one NaN
if nargin<=1
   nanopt=true;
end

u = unique(d(~isnan(d)));
if nanopt
    if sum(isnan(d)) > 1
       u = [u;NaN]; 
    end
else
    d(isnan(d)) = [];
end
