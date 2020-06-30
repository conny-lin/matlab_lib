function [Graph] = figvprep2(D,pFun,pExp,setfilename,Groups,fn,Yn,Xn,GAA)
%% Graphing: individual
% [G] = figvprep(D,Dmeani,Dsei,pFun,pExp,setfilename,Groups,fname,Yn,Xn,GAA)
% D-stats data (produced by stats* function 
%   with graph means at D{f,3} and SE at D{f,4}
% pFun - path to funciton
% pExp - path to experiment
% setfilename - name of the graph settings
% Groups - .mat files containing group name and index
% fn -name of the imported file (i.e. *.dat)
% Yn - Y axis name
% Xn - X axis name
% GAA - group sorting files
%
% Example:
%setfilename = 'GraphSetting.mat';
%fn = 'Tap_Dist.dat';
%Yn = 'Dist';
%Xn = 'Stim';
%D = Stats.curve;
%mi = 4; % c of mean
%sei = 5; % c of se


% load graph settings
cd(pFun);
Graph = load(setfilename);
Graph.legend = Groups;
%% load graph data source
Graph.Ylabel = Yn;
Graph.Xlabel = Xn;
[~,f] = ismember(fn,D(:,1)); % find row for fname
t1 = isequal(f,0); % if fn exists
switch t1
    case 1; % doesn't exist
        error('imported data %s does not exist...',fn);
    case 0
        Graph.Y = D{f,3};
        Graph.E = D{f,4};
end

%% see if group needs to be resorted
if exist('GAA','var') ==0;
    ...
else
    Graph.gs = cell2mat((GAA(:,1))');
    YA = Graph.Y;
    EA = Graph.E;
    for x = 1:size(Graph.gs,2);
        YA(:,x) = Graph.Y(:,Graph.gs(1,x));
        EA(:,x) = Graph.E(:,Graph.gs(1,x));
    end
    Graph.Y = YA;
    Graph.E = EA;
end
%% fix names
[~,Graph.expname] = fileparts(pExp);
Graph.expname = strrep(Graph.expname,'_','-');
for x = 1:size(Graph.legend);
    Graph.legend{x,1} = strrep(Graph.legend{x,1},'_','-');
end

end