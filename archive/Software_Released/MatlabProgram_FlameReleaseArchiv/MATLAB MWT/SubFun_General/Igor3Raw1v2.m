function [Time] = Igor3Raw1v2(pExp,pFun)
[ExpfdatGR,MWTfGrecord,MWTf,pMWTf,I] = importgroupedExpfdatnremovegroupfolder(pExp);
[MWTf,pMWTf,P,T] = getungroupedMWTfolders2(pExp);
[MWTfsn] = getMWTfdatsamplename('*.dat',MWTf,pMWTf);
correctMWTnamingswitchboard2(MWTfsn,pMWTf,pExp);
[MWTftrv,MWTfdat] = importMWTdattrv2(MWTf,pMWTf,T);
[GA,GAA,MWTfgcode] = setgroup2(MWTfdat,pFun,pExp,0);
[MWTftrv,MWTfdat,MWTfdatG,MWTftrvG] = groupMWTimport3(MWTfdat,MWTftrv,MWTfgcode);        
[savename] = creatematsavename(pExp,'import_','.mat'); % create save name
cd(pExp);
save(savename);
end



