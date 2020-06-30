function [MWTSet] = Dance_StatsMaster_By_Plates_Worms(MWTSet)

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
X = Graph.X(:,1);
if numel(X) > size(Graph.Y.(M{1}),1)
    X = X(2:end);
end
%%
for m = 1:numel(M);% for each measure

    for g = 1:numel(groupnames);
        A.(M{m}).Y(:,g) = Graph.Y.(M{m})(:,g);
        A.(M{m}).E(:,g) = Graph.E.(M{m})(:,g);
        A.(M{m}).SD(:,g) = Graph.SD.(M{m})(:,g);
        A.(M{m}).X(:,g) = X;
    end
end

MWTSet.Graph = A;
MWTSet.GraphGroup = groupnamesU;



end
