function backup2Connyfolder(pFun,analyzedname,pAExp)
[~,~,pBetC] = definepath4diffcomputers(pFun);
pBetCAExp = strcat(pBetC,'/',analyzedname);
copyfile(pAExp,pBetCAExp);
display('done');