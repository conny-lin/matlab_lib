function T = statsBasicG(x,gn,gnamename,varargin)
vararginProcessor
if nargin <3
    gnamename = 'gname';
end

[n,m,sem,gn2] = grpstats(x,gn,{'numel','mean','sem','gname'});


T = table;

if isnumeric(gn)
   gn2 = cellfun(@str2num,gn2) ;
end
T.(gnamename) = gn2;
T.n = n;
T.mean = m;
T.se = sem;
