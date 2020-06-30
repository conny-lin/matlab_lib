function [MWTftrv,MWTfdat] = importMWTdattrv2(MWTf,pMWTf,T)
if isequal(sum(T),size(MWTf,1))==1; % if all folders validated as MWT folder
    [MWTftrv] = importmwtdata3('*.trv',MWTf,5,0,pMWTf);
    [MWTfdat] = importmwtdata3('*.dat',MWTf,0,0,pMWTf);
else
    error('[BUG] some folders are not MWT folders...');
end
end