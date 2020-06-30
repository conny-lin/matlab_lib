function d= effectsize_cohend(x1,x2)

%%
% x1 = raw data for group 1
% x2 = raw data for group 2

%% calculate effect size
% cohen's d

%% take out nan
x1(isnan(x1))=[];
x2(isnan(x2))=[];
n1 = numel(x1);
n2 = numel(x2);
s1 = var(x1);
s2 = var(x2);
sd1 = (n1-1)*(s1^2);
sd2 = (n2-1)*(s2^2);
s = sqrt((sd1+sd2)/(n1+n2-2));
m1 = mean(x1);
m2 = mean(x2);
d = (m1-m2)/s;