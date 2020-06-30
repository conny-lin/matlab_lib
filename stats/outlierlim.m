function X = outlierlim(d,gname,varargin)
multiplier = 2;
vararginProcessor

T = grpstatsTable(d,gname,{'gname','mean','std'});
X = table;
X.gname = T.gnameu;
X.upperlim = T.mean + (T.sd.*multiplier);
X.lowerlim = T.mean - (T.sd.*multiplier);