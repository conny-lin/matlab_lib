function [G] = habgraphindividual(DRaw,DStd,Xn,setfilename,GL,GAA,pFun,pExp,pSave)
%% Graphing: individual
% works with [Stats.curve] = statcurve(Expfdat); % Curve data
% and [Stats.curvestd] = statstdcurve(Expfdat);
% GL = group name legend
% GL = GAA(:,3);
%
% universal settings
% Xn = 'Stim';
% setfilename = 'GraphSetting.mat';

% non-standardized data
% graph Dist
fname = 'Tap_Dist.dat';
Yn = 'Dist';
%%
[G] = figvprep(DRaw,4,5,pFun,pExp,setfilename,GL,fname,Yn,Xn,GAA);
%%
makefig(G);
savefig(Yn,pSave);

% graph Freq
fname = 'Tap_Freq.dat';
Yn = 'Freq';
[G] = figvprep(DRaw,4,5,pFun,pExp,setfilename,GL,fname,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);

% standardized data
% graph DisStd
fname = 'Tap_Dist.dat';
Yn = 'DistStd';
[G] = figvprep(DStd,4,5,pFun,pExp,setfilename,GL,fname,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);

% graph FreqStd
fname = 'Tap_Freq.dat';
Yn = 'FreqStd';
[G] = figvprep(DStd,4,5,pFun,pExp,setfilename,GL,fname,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);
end