function [MWTSet] = Dance_StatsMaster_ByGroupByTracker_NPlates(MWTSet)

%% OBJECITVE - ANALYZE BY EXPERIMENTER OR BY TRACKER
MWTSet.StatsOption = {'Group_Tracker_NPlates'};

%% get pMWT
pMWT = MWTSet.pMWTchorpass;

[pG,MWTfn] = cellfun(@fileparts,pMWT,'UniformOutput',0);


% match raw with MWTfn
display 'checking equality of MWTSet.Raw and MWTSet.pMWTchorpass';
if isequal(MWTfn,MWTSet.Raw.MWTfn) == 0    
    [i,j] = ismember(MWTfn,MWTSet.Raw.MWTfn);
    pMWT = pMWT(i);
    j = j(i);
    pMWT = pMWT(j);
    [pG,MWTfn] = cellfun(@fileparts,pMWT,'UniformOutput',0);
end


[pExp,Gn] = cellfun(@fileparts,pG,'UniformOutput',0);
[~,Expn] = cellfun(@fileparts,pExp,'UniformOutput',0);

%% group index

groupid = zeros(size(Gn));
groupname = unique(Gn);
for x = 1:numel(groupname)
    gi = ismember(Gn,groupname(x));
    groupid(gi,1) = x;
end
groupidname = Gn;

%% tracker index
a = regexpcellout(Expn,'_','split');
b = char(a(:,1));
b = cellstr(b(:,end));
A = zeros(size(Gn));
g = unique(b);
for x = 1:numel(g)
    i = ismember(b,g(x));
    A(i,1) = x;
end
trackerid = A;
trackeridname = b;

%% experimenterid
a = regexpcellout(Expn,'_','split');
b = a(:,2);
b = b(:,end);
A = zeros(size(Gn));
g = unique(b);
for x = 1:numel(g)
    i = ismember(b,g(x));
    A(i,1) = x;
end
expterid = A;
expteridname = b;

%% BY GROUP-TRACKER
Y = MWTSet.Raw.Y;
measure = fieldnames(Y);

groupbyid = trackerid;
newgroupid = (groupid.*10)+groupbyid;
newgroupname = cellfun(@strcat,groupidname,...
    cellfunexpr(groupidname,'_'),trackeridname,...
    'UniformOutput',0);

newgroupnameU = unique(newgroupname);

% MWTSet.GraphGroup
% re-organize seq of groups
display('sort new group  names:');
newgroupnameU = chooseoption(newgroupnameU,2);
MWTSet.GraphGroup = newgroupnameU;

% get ind for groups
ii = [];
for g = 1:numel(newgroupnameU)
    [i,j] = ismember(newgroupname,newgroupnameU{g});
    ii = [ii;find(i)];
end

% get X
a = floor(MWTSet.Raw.X); 
X = a(:,1);

% get Y, E, SD
Graph = [];
for m = 1:numel(measure)
    A = Y.(measure{m});
    % for each time points
    a = [];
    for t = 1:size(A,1)
        [gn,n,mn,s,se] = grpstats(A(t,ii),newgroupname(ii),...
            {'gname','numel','mean','std','sem'});
        
        Graph.(measure{m}).Y(t,1:numel(mn)) = mn';
        Graph.(measure{m}).E(t,1:numel(mn)) = se';
        Graph.(measure{m}).SD(t,1:numel(mn)) = s';
        Graph.(measure{m}).groupname(t,1:numel(mn)) = gn';

    end
    Graph.(measure{m}).X = repmat(X,1,numel(mn));

end

MWTSet.Graph = Graph;


%% CHANGE PSAVEA
MWTSet.pSaveA = [MWTSet.pSaveA,'_byTrackerNPlate'];
if isdir(MWTSet.pSaveA) == 0
   cd(MWTSet.pSave);
   [~,n] = fileparts(MWTSet.pSaveA);
   mkdir(n);
end
