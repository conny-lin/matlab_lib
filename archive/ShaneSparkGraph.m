function ShaneSparkGraph(MWTftrvG,pExpStd,pExpStdSave,pFun,pExp,GAA)
display(' ');
display('Calculating curve descriptive statistics...');
[HabGraph] = statcurvehab1(MWTftrvG);
[HabGraphStd] = statstdcurvehab1(MWTftrvG);
cd(pExpStdSave);
display('done');


%% Graphing
display(' ');
display('Graphing...');
[G] = habgraphindividual2(HabGraph,HabGraphStd,'GraphSetting.mat',GAA,...
    pFun,pExp,pExpStdSave);
[savename] = creatematsavename3(expname,'stats_','.mat');
save(savename);
cd(pExpStdSave);
display('done');