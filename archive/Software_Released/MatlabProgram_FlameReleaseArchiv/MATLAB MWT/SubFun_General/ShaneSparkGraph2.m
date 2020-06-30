function ShaneSparkGraph2(MWTftrvG,pSave,pFun,pExpO,GAA,expname)
display(' ');
display('Calculating curve descriptive statistics...');
[HabGraph] = statcurvehab1(MWTftrvG);
[HabGraphStd] = statstdcurvehab1(MWTftrvG);
display('done');


%% Graphing
display(' ');
display('Graphing...');
[G] = habgraphindividual2(HabGraph,HabGraphStd,'GraphSetting.mat',GAA,...
    pFun,pExpO,pSave);
[savename] = creatematsavename3(expname,'stats_','.mat');
save(savename);
cd(pSave);
display('done');