function LadyGaGaGraph1(pSave,pSet,pExpO,MWTfgcode,GAA,expname)
end




function old
%% group data
[MWTftrvG] = groupMWTfdata2(MWTftrv,MWTfgcode); % group import

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
    pSet,pExpO,pSave);
[savename] = creatematsavename3(expname,'stats_','.mat');
save(savename);
cd(pSave);
display('done');
end



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



function [GraphVar] = figVprepErrorBarOne(Yn,Xn,mean,SE,pSet,setfilename,pExp,groupname,groupgraphsequence)
%% Graphing: individual
%   setfilename = 'GraphSetting.mat';
%   fname = 'Tap_Dist.dat';
%   Yn = 'Dist';
%   Xn = 'Stim';
%   D = Stats.curve;
%   mi = 4; % c of mean
%   sei = 5; % c of se


%% load graph settings
cd(pSet);
GraphVar = load(setfilename);
GraphVar.legend = groupname;
% load graph data source
GraphVar.Ylabel = Yn; % y axis label
GraphVar.Xlabel = Xn; % x axis label

% put variables into cells
% Gtest = [Yn,Xn,mean,SE,pSet,setfilename,pExp,groupname,groupgraphsequence]
% prepare y variable
if iscell(mean)==1; 
    GraphVar.Y = cell2mat(mean'); 
elseif isnumeric(mean)==1;
    GraphVar.Y = mean';
end

% prepare x variable
if iscell(SE) ==1;
    GraphVar.E = cell2mat(SE'); % errorbar variable
elseif isnumeric(SE)==1;
    GraphVar.E = SE';
end

% validate SE and mean are the same size
if size(GraphVar.E) ~= size(GraphVar.Y);
   error('standard error and mean are not the same size');
end

% validate group number
size(GraphVar.E) =

% group name should be the same size as mean and SE

%% see if group needs to be resorted
if exist('GAA','var') ==0;
    ...
else
    GraphVar.gs = cell2mat((groupgraphsequence(:,1))');
    YA = GraphVar.Y;
    EA = GraphVar.E;
    for x = 1:size(GraphVar.gs,2);
        YA(:,x) = GraphVar.Y(:,GraphVar.gs(1,x));
        EA(:,x) = GraphVar.E(:,GraphVar.gs(1,x));
    end
    GraphVar.Y = YA;
    GraphVar.E = EA;
end
%% fix names
[~,GraphVar.expname] = fileparts(pExp);
GraphVar.expname = strrep(GraphVar.expname,'_','-');
for x = 1:size(GraphVar.legend);
    GraphVar.legend{x,1} = strrep(GraphVar.legend{x,1},'_','-');
end

    end