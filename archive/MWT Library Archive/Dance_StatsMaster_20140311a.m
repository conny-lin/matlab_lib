function [Graph,GraphGroup] = Dance_StatsMaster(varargin)

%% instruction
% require Graph, MWTfG for output
% [A] = Dance_AnalysisMaster('setup')
% [A] = Dance_AnalysisMaster(Graph,MWTfG)
% [A] = Dance_AnalysisMaster(Graph,MWTfG,'option')



%% analysis list
optionlist = {'By_Plates';'By_Experiments';'By_GroupPlates'};



%% varargin interpretation
switch nargin        
    case 1 % no option input, ask for options
        MWTSum = varargin{1};
        option = chooseoption(optionlist);
        [Graph,GraphGroup] = eval([char(option),'(MWTSum)']);
        
    
    case 2 % option input go directly to options
        MWTSum = varargin{1};
        option = varargin{2};
        i = strcmp(option,optionlist);
        if sum(i) ==1;
            option = a;
        else
            option = chooseoption(optionlist);
        end
        [Graph,GraphGroup] = eval([char(option),'(MWTSum)']);
end



end




%% SUBFUNCTION


function [option] = chooseoption(optionlist)
disp(makedisplay(optionlist));
i = input('choose analysis grouping option: ');
option = optionlist(i);



end


function [Graph,GraphGroup] = By_Experiments(MWTSet)



%% STATS: N = EXPERIMENTS
Graph = MWTSet.Raw;
MWTfG = MWTSet.MWTfG;
pMWT = MWTSet.pMWTchorpass;

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

%% get experiment index
GroupInd = nan(numel(pMWT),numel(groupnamesU));
for x = 1:numel(groupnamesU)
    i = ismember(groupnames,groupnamesU{x});
    
%     e = regexpcellout(pMWT,expfn{x});
%     search = ['\<',gfn{x},'\>'];
%     g = regexpcellout(gfn,search);
%     i = e+g ==2;
    GroupInd(1:numel(pMWT),x) = i;
end



% for g = 1:numel(groupnames)
%    % get experiment names
%    [p,fn] = cellfun(@fileparts,MWTfG.(groupnames{g})(:,2),'UniformOutput',0);
%    [p,fn] = cellfun(@fileparts,p,'UniformOutput',0);
%    [~,expfn] = cellfun(@fileparts,p,'UniformOutput',0);
%    explist = unique(expfn);
%    for e = 1:numel(explist)
%        i = ismember(expfn,explist{e});
%        % record exp name
%        Graph.Expfn.(groupnames{g}){e} = explist{e};
%        % record index
%        Graph.Expind.(groupnames{g}){e} = i; 
%        
%    end
% end



%% calculate stats
M = fieldnames(Graph.Y);
A = [];
gname = {};
X = Graph.X;
if numel(X) > size(Graph.Y.(M{1}),1)
    X = X(2:end);
end

for g = 1:numel(groupnamesU)
        % code graphing grouping legend
% 
%         a = regexpcellout(Graph.Expfn.(groupnames{g}){e},'_','split');
%         a = char(a(1));
%         name = [groupnames{g},'-',a];
%         gN = gN+1; % get current n
    gname{g} = groupnamesU{g};
    for m = 1:numel(M)

        % get exp index
        i = find(GroupInd(:,g)); 
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

%% output
Graph = A;
GraphGroup = gname;




end

function [Graph,GraphGroup] = By_GroupPlates(MWTSet)

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

function [Graph,GraphGroup] = By_Plates(MWTSum)

%% input
Graph = MWTSum.Raw;
MWTfG = MWTSum.MWTfG;
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
        A.(M{m}).X(:,g) = Graph.X(2:end);
    end
end

Graph = A;
GraphGroup = gnameL;



end