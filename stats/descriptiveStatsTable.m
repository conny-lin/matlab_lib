function T = descriptiveStatsTable(X,G)

[n,m,s,se,gn] = grpstats(X,G,{'numel','mean','std','sem','gname'});
T = table;
T.groupname = gn;
T.mean = m;
T.SE = se;
T.SD = s;
T.N = n;
