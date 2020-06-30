function [MWTSet] = Dance_StatsMaster_By_Experiments_Plates(MWTSet)
%%


%% STATS: N = EXPERIMENTS


%% GET INPUTS
Graph = MWTSet.Raw;
MWTfG = MWTSet.MWTfG;

% GET pMWT from MWTfG
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWT = A(:,2); 


%% get group names
[p,fn] = cellfun(@fileparts,pMWT,'UniformOutput',0);
[p,gfn] = cellfun(@fileparts,p,'UniformOutput',0);
[~,expfn] = cellfun(@fileparts,p,'UniformOutput',0);
a = regexpcellout(expfn,'_','split');
expfn = cellfun(@horzcat,a(:,1),cellfunexpr(a(:,2),'_'),a(:,2),...
    'UniformOutput',0);
groupnames = cellfun(@horzcat,gfn,cellfunexpr(gfn,'_'),expfn,...
    'UniformOutput',0);
groupnamesU = unique(groupnames);

% get experiment index
GroupInd = nan(numel(pMWT),1);
for x = 1:numel(groupnamesU)
    i = ismember(groupnames,groupnamesU{x});
    GroupInd(i,1) = x;

end


%% calculate stats
M = fieldnames(Graph.Y);
A = [];
gname = {};

% get X
X = Graph.X;
if size(X,1) > size(Graph.Y.(M{1}),1)
    X = X(2:end,1);
else
    X = X(:,1);
end

if strcmp(MWTSet.AnalysisName,'ShaneSpark') ==1
    X = 1:numel(X);
end
   
%%

for g = 1:numel(groupnamesU)
    gname{g} = groupnamesU{g};
    for m = 1:numel(M)

        % get exp index
        i = GroupInd(:,1)==g; 
        
        % get data
        d = Graph.Y.(M{m})(:,i);
        
        % get mean
        A.(M{m}).Y(:,g) = nanmean(d,2);
        % get se
        A.(M{m}).E(:,g) = standarderror(d);
        % SD
        A.(M{m}).SD(:,g) = nanstd(d')';

        % get x

        A.(M{m}).X(:,g) = X';
    end
end

%% output
MWTSet.Graph = A;
MWTSet.GraphGroup = gname;

end
