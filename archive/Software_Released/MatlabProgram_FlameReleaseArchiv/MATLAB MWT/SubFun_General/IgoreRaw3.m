function IgoreRaw3(pExp,pFun)
[Expfdat] = importungroupedExpraw('*.dat',pExp);
[MWTf,pMWTf,T] = getungroupedMWTfolders(pExp);
[MWTftrv,MWTfdat] = importMWTdattrv(MWTf,pMWTf,T); % Import ungrouped data
[MWTftrv,MWTfdat,MWTfgcode,GAA,MWTfdatG,MWTftrvG] = groupMWTimport(pExp,pFun,MWTfdat,MWTftrv);        
[savename] = creatematsavename(pExp,'import_','.mat'); % create save name
cd(pExp);
save(savename);
IgoreGraph2(pExp,pFun,'import*.mat');
end

