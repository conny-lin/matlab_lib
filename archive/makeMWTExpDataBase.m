function makeMWTExpDataBase(HomePath,pSet)
[pExpfD,ExpfnD,~,~,pMWTfD,MWTfnD,MWTfsnD] = getMWTpathsNname(HomePath,'noshow');
dateupdated = datestr(date,'yyyymmdd'); % record date
a = regexp(HomePath,'/Volumes/','split');
b = regexp(a{2},'/','split');
hardrivename = b{1};
cd(pSet);
savename = ['MWTExpDataBase_' hardrivename, '.mat'];
save(savename,'pExpfD','ExpfnD','pMWTfD','MWTfnD','MWTfsnD',...
    'dateupdated','HomePath');

