function [G] = habgraphindividual2(HabGraph,HabGraphStd,setfilename,GAA,pFun,pExp,pSave)
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
Xn = 'time';
GL = GAA(:,3);
%%
[G] = figvprep5(HabGraph,2,3,pFun,pExp,setfilename,GL,Yn,Xn,GAA);
%%
makefig(G);
savefig(Yn,pSave);

% graph Freq
fname = 'Tap_Freq.dat';
Yn = 'Freq';
[G] = figvprep5(HabGraph,4,5,pFun,pExp,setfilename,GL,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);

% standardized data
% graph DisStd
fname = 'Tap_Dist.dat';
Yn = 'DistStd';
[G] = figvprep5(HabGraphStd,2,3,pFun,pExp,setfilename,GL,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);

% graph FreqStd
fname = 'Tap_Freq.dat';
Yn = 'FreqStd';
[G] = figvprep5(HabGraphStd,4,5,pFun,pExp,setfilename,GL,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);
end