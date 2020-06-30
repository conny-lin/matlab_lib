function [G] = figvprep5(D,mi,sei,pFun,pExp,setfilename,Gname,Yn,Xn,GAA)
    %% Graphing: individual
%   setfilename = 'GraphSetting.mat';
%   fname = 'Tap_Dist.dat';
%   Yn = 'Dist';
%   Xn = 'Stim';
%   D = Stats.curve;
%   mi = 4; % c of mean
%   sei = 5; % c of se

% load graph settings
cd(pFun);
G = load(setfilename);
G.legend = Gname;
% load graph data source
G.Ylabel = Yn;
G.Xlabel = Xn;
G.Y = cell2mat(D(:,mi)');
G.E = cell2mat(D(:,sei)');

%% see if group needs to be resorted
if exist('GAA','var') ==0;
    ...
else
    G.gs = cell2mat((GAA(:,1))');
    YA = G.Y;
    EA = G.E;
    for x = 1:size(G.gs,2);
        YA(:,x) = G.Y(:,G.gs(1,x));
        EA(:,x) = G.E(:,G.gs(1,x));
    end
    G.Y = YA;
    G.E = EA;
end
%% fix names
[~,G.expname] = fileparts(pExp);
G.expname = strrep(G.expname,'_','-');
for x = 1:size(G.legend);
    G.legend{x,1} = strrep(G.legend{x,1},'_','-');
end

    end