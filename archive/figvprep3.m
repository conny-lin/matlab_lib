function [Graph] = figvprep3(D,fn,GAA,Yn,Xn,pFun,pExp,setfilename)
%% Graphing: individual
% [Graph] = figvprep3(D,fn,GAA,Yn,Xn,pFun,pExp,setfilename)% D-stats data (produced by stats* function 
%   with graph means at D{f,3} and SE at D{f,4}
% pFun - path to funciton
% pExp - path to experiment
% setfilename - name of the graph settings
% Groups - .mat files containing group name and index
% fn -name of the imported file (i.e. *.dat), 
%   type in 'MWTfdata' for MWTfdat and MWTftrv analysis
% Yn - Y axis name
% Xn - X axis name
% GAA - group sorting files
% Example:
%setfilename = 'GraphSetting.mat';

%% load graph settings
cd(pFun);
Graph = load(setfilename);
Graph.legend = GAA(:,3);
Graph.Ylabel = Yn;
Graph.Xlabel = Xn;

%% load graph data source
% if filename is a variable, or imported Expfdata
if (isequal(fn,'MWTfdata')==1)||ismember(fn,D(:,1))==1; 
    Graph.Y = cell2mat(D(:,3)');
    Graph.E = cell2mat(D(:,4)');
else
    error('imported data %s does not exist...',fn);
    
end

%% see if group needs to be resorted
Graph.gs = cell2mat((GAA(:,1))');
YA = Graph.Y;
EA = Graph.E;
for x = 1:size(Graph.gs,2);
    YA(:,x) = Graph.Y(:,Graph.gs(1,x));
    EA(:,x) = Graph.E(:,Graph.gs(1,x));
end
Graph.Y = YA;
Graph.E = EA;

%% fix names
[~,Graph.expname] = fileparts(pExp);
Graph.expname = strrep(Graph.expname,'_','-');
for x = 1:size(Graph.legend);
    Graph.legend{x,1} = strrep(Graph.legend{x,1},'_','-');
end

end