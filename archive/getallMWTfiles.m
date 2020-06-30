function [MWTfull] = getallMWTfiles(pExp)
[MWTf,pMWTf] = dircontentmwt(pExp);
MWTfull = MWTf;
for x = 1:size(pMWTf,1);
    [MWTfull{x,2},MWTfull{x,3},~,~] = dircontent(pMWTf{x,1});
end
end