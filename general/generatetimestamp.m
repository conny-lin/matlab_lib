function [timestamp] = generatetimestamp
a = clock;
h = num2str(a(4));
if numel(h) == 1; h = ['0',h]; end
m = num2str(a(5));
if numel(m) == 1; m = ['0',m]; end

s = num2str(round(a(6)));
if numel(s) == 1; s = ['0',s]; end


timestamp = [datestr(now,'yyyymmdd'),[h,m,s]];