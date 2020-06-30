function [MWTSet] = Dance_StatsMaster_By_Group_N_Plates(MWTSet)

%% INPUT REQUIREMENT
names = {'MWTfG','Raw','MWTfn'};


MWTfG = MWTSet.MWTfG;
Graph = MWTSet.Raw;
MWTfn = Graph.MWTfn;

%% process
M = fieldnames(Graph.Y);
gnameL = fieldnames(MWTfG);  
A = [];
for m = 1:numel(M);% for each measure
    
    tapN = size(Graph.Y.(M{m}),1);
    
    for g = 1:numel(gnameL);
        gname = gnameL{g};
        pMWTf = MWTfG.(gname)(:,2); 
        MWTfn1 = MWTfG.(gname)(:,1);
        [~,i,~] = intersect(MWTfn',MWTfn1);
        A.(M{m}).Y(1:tapN,g) = nanmean(Graph.Y.(M{m})(:,i),2);
        A.(M{m}).E(1:tapN,g) = nanstd(Graph.Y.(M{m})(:,i)')'./sqrt(numel(i));
        A.(M{m}).SD(1:tapN,g) = nanstd(Graph.Y.(M{m})(:,i)')';
        A.(M{m}).X(1:tapN,g) = Graph.X(1:end,1);
    end
end

MWTSet.Graph = A;
MWTSet.GraphGroup = gnameL;



