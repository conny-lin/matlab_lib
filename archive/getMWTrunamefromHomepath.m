function [pMWTf,MWTfn,MWTfsn,MWTsum,pExp] = getMWTrunamefromHomepath(Home)
display ' ';
if iscell(Home)==1 && size(Home,1)==1; Home = char(Home); end
[pExp,pMWTf,MWTfn] = getunzipMWT(Home); 
[MWTfsn,MWTsum] = getMWTruname(pMWTf,MWTfn);

end