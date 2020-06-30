function [MWTf,pMWTf,T,P] = dircontentmwt(pExp)
[~,~,MWTf,pMWTf] = dircontent(pExp);
[T,P] = validateMWTfn2(MWTf,pMWTf);
end