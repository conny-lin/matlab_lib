function igoreGraphing3(pFun,pExp,Xn,rawfilename,intmin,int,intmax,m)
%% set paths and load .mat set files
addpath(genpath(pFun)); 
cd(pFun);
cd(pExp);
a = dir(rawfilename);
a = {a.name};
load(char(a));
% analysis
%[titlename,~,m,intmin,int,intmax,Yn] = selectmeasure2(pFun,...
%    'analysisetting.mat',0);
[Data,Time,Xaxis,Yn,titlename] = getmeanresponse2(MWTfdatG,intmin,int,intmax,m,pFun);
% descriptive and graph
[Stats.curve] = statcurve2(Data,2); 
[Stats.curvestd] = statstdcurve2(Data,2); 
[Graph] = figvprep4(Stats.curve,'MWTfdata',GAA,'time',Yn,Time,...
            pFun,pExp,'GraphSetting.mat');
makefig2(Graph);
savefig(titlename,pExp);
%% combineed speed graphs of 6 groups 
% day4 - 0mM, 400mM
% day5 - 0mM, 400mM, 0mM(repeated), 400mM(repeated)

%% [code later] create analysis dat reference
%% individual and combined graphs of any parameters
% [code later] create analysis dat reference
%% flexibility in selecting X axis
%% bar graphs to compare selected time points

end