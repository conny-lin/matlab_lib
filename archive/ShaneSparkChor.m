function ShaneSparkChor(pExpStd)
display(' ');
display('Runing Choeography analysis...');
[~,pMWTf] = dircontentmwt(pExpStd);
for x = 1:size(pMWTf,1);
    ptrv = pMWTf{x,1};
    choretapreversal(ptrv);
end
display('done');