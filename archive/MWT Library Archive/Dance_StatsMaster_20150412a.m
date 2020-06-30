function [varargout] = Dance_StatsMaster(varargin)

%% instruction
% require Graph, MWTfG for output
% [A] = Dance_AnalysisMaster('setup')
% [A] = Dance_AnalysisMaster(Graph,MWTfG)
% [A] = Dance_AnalysisMaster(Graph,MWTfG,'option')

%% load varargin
A = varargin;


%% analysis list
% option name, function name
optionlist = {
'By groups, N=plates',              'Group_NPlates';
'By experiments, N=plates',         'Experiments_NPlates';
'By plates, N=worms',               'Plates_NWorms';
'By groups & tracker, N=plates',    'Group_Trakcer_NPlates';

};


%% SETTING
setname = 'StatsOption'; % setting name in MWTSet

if sum(strcmp(A,'Setting')) == 1  
    display ' ';
    display 'Statistics options...';
    option = chooseoption(optionlist,2);
    A{1}.(setname) = option;
    varargout{1} = A{1};
    return
else
    
    MWTSet = A{1};
end



%% run function
option = MWTSet.(setname);

for x = 1:1%numel(option)
    
    switch option{x}
        case 'Group_NPlates';
            [MWTSet] = ...
                Dance_StatsMaster_By_Group_N_Plates(MWTSet);
        case 'Experiments_NPlates'
            [MWTSet] = Dance_StatsMaster_By_Experiments_Plates(MWTSet);
        case 'Plates_NWorms'
            [MWTSet] = Dance_StatsMaster_By_Plates_Worms(MWTSet);
        case 'Group_Trakcer_NPlates'
            [MWTSet] = Dance_StatsMaster_ByGroupByTracker_NPlates(MWTSet);

    end

end



%% varify Graph X, Y, E are the same length
Graph = MWTSet.Graph;
M = fieldnames(Graph);

for m = 1:numel(M)
    x = size(Graph.(M{m}).X);
    y = size(Graph.(M{m}).Y);
    e = size(Graph.(M{m}).E);
    sd = size(Graph.(M{m}).SD);
    if sum(x == y) == 2 && sum(e == y) == 2
%         display('X,Y,E the same size');
    else
        warning('X,Y,E different size');
    end
end


%% VArargout

varargout{1} = MWTSet;

end




%% SUBFUNCTION




function [Graph,GraphGroup] = By_Plates_Worms(MWTSet)

%% input
Graph = MWTSet.Raw;
% MWTfG = MWTSet.MWTfG;
pMWT = MWTSet.pMWTchorpass;

%% get group names
[p,fn] = cellfun(@fileparts,pMWT,'UniformOutput',0);
[p,gfn] = cellfun(@fileparts,p,'UniformOutput',0);
groupnames = cellfun(@horzcat,gfn,cellfunexpr(gfn,'_'),fn,...
    'UniformOutput',0);
groupnamesU = unique(groupnames);


%% process
M = fieldnames(Graph.Y);
 
A = [];
X = Graph.X;
if numel(X) > size(Graph.Y.(M{1}),1)
    X = X(2:end);
end

for m = 1:numel(M);% for each measure

    for g = 1:numel(groupnames);
        A.(M{m}).Y(:,g) = Graph.Y.(M{m})(:,g);
        A.(M{m}).E(:,g) = Graph.E.(M{m})(:,g);
        A.(M{m}).X(:,g) = X;
    end
end

Graph = A;
GraphGroup = groupnamesU;



end

