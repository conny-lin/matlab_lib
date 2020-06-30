function ShaneSparkGraph3(pSave,pFun,pExpO,MWTfgcode,GAA,expname,diarysavename)
%% group data
[MWTftrvG] = groupMWTfdata2(MWTftrv,MWTfgcode); % group import
cd(pExpO);
diary(diarysavename);

%% stats
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