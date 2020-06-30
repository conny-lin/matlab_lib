function [pctscore, reftable] = transform_percentile(d)
a = tabulate(d);
a(a(:,2)==0,:) = [];
pct = cumsum(a(:,3));
score = a(:,1);

[i,j] = ismember(d,score);
pctscore = pct(j);

reftable = [score pct];
end
