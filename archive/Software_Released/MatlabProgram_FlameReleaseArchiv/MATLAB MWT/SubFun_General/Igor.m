function Igor(pExp,pFun) %% find out posture of the worm
addpath(genpath(pFun));

%% choreography
%nNeslwamMk
legend = {'time';'number';'goodnumber';'area';'speed';'length';...
    'width';'aspect';'midline';'morphwidth';'kink'};
n = num2cell((1:numel(legend))');
outputlegend = [n,legend];
%% run chor
display(' ');
display('Runing Choeography analysis...');
[~,pMWTf] = dircontentmwt(pExp);
for x = 1:size(pMWTf,1);
    pMWT = pMWTf{x,1};
    chorb3(pMWT);
end
display('done');

%% access chor data
[MWTfdata] = importchordata(pExp,'*.dat',0,0);
[~,GAA,MWTfgcode] = setgroup(MWTfdata,pFun,pExp,0);
[MWTfdatG] = groupMWTfdata(MWTfdata,MWTfgcode);
%% analysis
[titlename,set,m,intmin,int,intmax,Yn] = selectmeasure3...
        (outputlegend);

[Data,Time,Xaxis] = getmeanresponse(MWTfdatG,intmin,int,intmax,m);
% descriptive and graph
[Stats.curve] = statcurve2(Data,2); 
[Stats.curvestd] = statstdcurve2(Data,2); 
[Graph] = figvprep4(Stats.curve,'MWTfdata',GAA,Yn,'Time',Time,...
            pFun,pExp,'GraphSetting.mat');
makefig2(Graph);
savefig(titlename,pExp);
% width

% length

% aspect ratio
% angular

