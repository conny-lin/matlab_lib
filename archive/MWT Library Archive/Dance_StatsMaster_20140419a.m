function [varargout] = Dance_StatsMaster(varargin)

%% instruction
% require Graph, MWTfG for output
% [A] = Dance_AnalysisMaster('setup')
% [A] = Dance_AnalysisMaster(Graph,MWTfG)
% [A] = Dance_AnalysisMaster(Graph,MWTfG,'option')



%% analysis list
% option name, function name
optionlist = {'By groups, N = plates','By_Group_Plates';
            'By experiments, N = plates','By_Experiments_Plates';
            'By plates, N = worms','By_Plates_Worms'};


%% load varargin
A = varargin;


%% get option
switch nargin        
    case 1 % no option input, ask for options
        if strcmp(inputname(1),'MWTSet') == 1
            MWTSet = varargin{1};
            
            % check for stats options
            names = fieldnames(MWTSet);
            i = ismember(names,'StatsOption');
            if sum(i) ==1 % if stats option is set
                option = MWTSet.StatsOption;
                
            else % if stats option is not set, ask
                option = chooseoption(optionlist);

            end
        
        elseif strcmp(varargin{1},'GetOption') ==1
            option = chooseoption(optionlist);
            varargout{1} = option;
            return
        end
    
    case 2 % option input go directly to options
        MWTSet = varargin{1};
        option = varargin{2};
        i = strcmp(option,optionlist);
        if sum(i) ==1;
            option = a;
        else
            option = chooseoption(optionlist);
        end      
end


%% run function
MWTSet.StatsOption = option;
[Graph,GraphGroup] = eval([char(option),'(MWTSet)']);


%% varify Graph X, Y, E are the same length
M = fieldnames(Graph);

for m = 1:numel(M)
    x = size(Graph.(M{m}).X);
    y = size(Graph.(M{m}).Y);
    e = size(Graph.(M{m}).E);
    if sum(x == y) == 2 && sum(e == y) == 2
    else
        warning('X,Y,E different size');
    end
end


%% VArargout
MWTSet.Graph = Graph;
MWTSet.GraphGroup = GraphGroup;
varargout{1} = MWTSet;

end




%% SUBFUNCTION




function [Graph,GraphGroup] = By_Experiments_Plates(MWTSet)

% STATS: N = EXPERIMENTS
Graph = MWTSet.Raw;
MWTfG = MWTSet.MWTfG;

% GET pMWT from MWTfG
if isstruct(MWTfG) ==1
    A = celltakeout(struct2cell(MWTfG),'multirow');
    pMWT = A(:,2); 
end


% get group names
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


% calculate stats
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
        % get x

        A.(M{m}).X(:,g) = X';
    end
end

% output
Graph = A;
GraphGroup = gname;

end




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

function [Graph,GraphGroup] = By_Group_Plates(MWTSet)

%% input
MWTfG = MWTSet.MWTfG;
Graph = MWTSet.Raw;
MWTfn = Graph.MWTfn;

%% process
M = fieldnames(Graph.Y);
gnameL = fieldnames(MWTfG);  
A = [];
for m = 1:numel(M);% for each measure

    for g = 1:numel(gnameL);
        gname = gnameL{g};
        pMWTf = MWTfG.(gname)(:,2); 
        MWTfn1 = MWTfG.(gname)(:,1);
        [~,i,~] = intersect(MWTfn',MWTfn1);
        A.(M{m}).Y(:,g) = nanmean(Graph.Y.(M{m})(:,i),2);
        A.(M{m}).E(:,g) = nanstd(Graph.Y.(M{m})(:,i)')'./sqrt(sum(i));
        A.(M{m}).X(:,g) = Graph.X(1:end,1);
    end
end

Graph = A;
GraphGroup = gnameL;



end