function [MWTindex] = makeMWTindex(pMWTf)
MWTindex = [];

[~,fn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
MWTfList = [fn,pMWTf];

% make a comprehensive index (MWTfGind)
% MWTfList = celltakeout(struct2cell(MWTfG),'multirow');
% %MWTindex.text = MWTfList;
MWTfListL = {'plate','platepath'};

%% legends
% MWTindex.textL = {'plate','plate_path','exp','group','tracker','groupNexp'};
% MWTindex.codeL = {'exp','group','tracker','groupNexp','plate'};
% MWTindex.LL = {'text';'code'};

% get plate 
task = 'plate';
[MWTindex.(task)] = makeindex(MWTfList(:,strcmp(MWTfListL,task)));


% code paths
task = 'platepath';
[MWTindex.(task)] = makeindex(MWTfList(:,strcmp(MWTfListL,task)));

% index exp
task = 'exp';
A = MWTfList(:,strcmp(MWTfListL,'platepath'));
[~,fn] = cellfun(@fileparts,cellfun(@fileparts,cellfun(@fileparts,A,...
    'UniformOutput',0),'UniformOutput',0),'UniformOutput',0);
[MWTindex.(task)] = makeindex(fn);


% index group
task = 'group';
A = MWTfList(:,strcmp(MWTfListL,'platepath'));
[~,fn] = cellfun(@fileparts,cellfun(@fileparts,A,...
    'UniformOutput',0),'UniformOutput',0);
[MWTindex.(task)] = makeindex(fn);


%% code experiment & group
task = 'exp_group';
A = cellfun(@strcat,MWTindex.group.text,...
    cellfunexpr(MWTindex.group.text,'*'),MWTindex.exp.text,...
    'UniformOutput',0);
[MWTindex.(task)] = makeindex(A);

% code experiment & group
task = 'groupbyexp';
A = regexpcellout(MWTindex.exp_group.legend,'*','split');
[MWTindex.(task)] = makeindex(A(:,1));


% get tracker code
task = 'tracker';
a = regexpcellout(MWTindex.exp.text,'[A-Z]','match');
[MWTindex.(task)] = makeindex(a(:,1));

% get tracker code
task = 'tracker_group';
A = cellfun(@strcat,MWTindex.group.text,...
    cellfunexpr(MWTindex.group.text,'*'),MWTindex.tracker.text,...
    'UniformOutput',0);
%a = regexpcellout(MWTindex.exp.text,'[A-Z]','match');
[MWTindex.(task)] = makeindex(A);


%% archive
% % make a comprehensive index (MWTfGind)
% MWTfList = celltakeout(struct2cell(MWTfG),'multirow');
% MWTindex = []; MWTindex.text = MWTfList;
% MWTfListL = {'plate','platepath','exp','group'};
% 
% % legends
% MWTindex.textL = {'plate','plate_path','exp','group','tracker','groupNexp'};
% MWTindex.codeL = {'exp','group','tracker','groupNexp','plate'};
% MWTindex.LL = {'text';'code'};
% 
% % get plate 
% task = 'plate';
% MWTindex.text(:,strcmp(MWTindex.textL,task)) = ...
%     MWTfList(:,strcmp(MWTfListL,task));
% MWTindex.code(:,strcmp(MWTindex.codeL,'plate')) = ...
%     (1:numel(MWTfList(:,strcmp(MWTfListL,task))))';
% 
% % code paths
% i = strcmp(MWTindex.textL,'plate_path');
% MWTindex.text(:,i) = MWTfList(:,2);
% 
% 
% % index exp
% task = 'exp';
% MWTindex.text(:,strcmp(MWTindex.textL,task)) = ...
%     MWTfList(:,strcmp(MWTindex.textL,task)); 
% a = unique(MWTfList(:,strcmp(MWTindex.textL,task))); 
% MWTindex.([task,'L'])(:,strcmp(MWTindex.LL,'text')) = a;
% MWTindex.([task,'L'])(:,strcmp(MWTindex.LL,'code')) = ...
%     num2cell(1:1:numel(a))'; % code legend
% % index
% for x = 1:numel(a)
%     MWTindex.code(ismember(MWTindex.text(:,strcmp(MWTindex.textL,task)),...
%         MWTindex.([task,'L']){x,strcmp(MWTindex.LL,'text')}),...
%         strcmp(MWTindex.codeL,task)) = x;
% end
% 
% % index group
% task = 'group';
% MWTindex.text(:,strcmp(MWTindex.textL,task)) = ...
%     MWTfList(:,strcmp(MWTindex.textL,task)); 
% a = unique(MWTfList(:,strcmp(MWTindex.textL,task))); 
% MWTindex.([task,'L'])(:,strcmp(MWTindex.LL,'text')) = a;
% MWTindex.([task,'L'])(:,strcmp(MWTindex.LL,'code')) = ...
%     num2cell(1:1:numel(a))'; % code legend
% % index
% for x = 1:numel(a)
%     MWTindex.code(ismember(MWTindex.text(:,strcmp(MWTindex.textL,task)),...
%         MWTindex.([task,'L']){x,strcmp(MWTindex.LL,'text')}),...
%         strcmp(MWTindex.codeL,task)) = x;
% end
% 
% %% code experiment & group
% task = 'groupNexp';
% exp = MWTindex.text(:,strcmp(MWTindex.textL,'exp'));
% group = MWTindex.text(:,strcmp(MWTindex.textL,'group'));
% MWTindex.text(:,strcmp(MWTindex.textL,task)) = ...
%     cellfun(@strcat,group,cellfunexpr(group,'*'),exp,...
%     'UniformOutput',0);
% u = unique(a);
% MWTindex.([task,'L']) = {};
% MWTindex.([task,'L'])(:,strcmp(MWTindex.LL,'text')) = u;
% MWTindex.([task,'L'])(:,strcmp(MWTindex.LL,'code')) = num2cell([1:numel(u)])';
% for x = 1:numel(u)
%     MWTindex.code(ismember(MWTindex.text(:,strcmp(MWTindex.textL,task)),...
%         MWTindex.([task,'L']){x,strcmp(MWTindex.LL,'text')}),...
%         strcmp(MWTindex.codeL,task)) = x;
% end
% A = MWTindex.([task,'L']);
% for x = 1:numel(u)
%     k = strcmp(MWTindex.text(:,strcmp(MWTindex.textL,'group')),group{x})& ...
%         strcmp(MWTindex.text(:,strcmp(MWTindex.textL,'exp')),exp{x});
%     MWTindex.text(k,strcmp(MWTindex.textL,task)) = u(x);
%     MWTindex.code(k,strcmp(MWTindex.codeL,task)) = x;
% end
% 

% %%
% % get tracker code
% task = 'tracker';
% name = MWTindex.text(:,strcmp(MWTindex.textL,'exp')); 
% a = celltakeout(regexp(name,'_','split'),'split');
% a = celltakeout(regexp(a(:,1),'[A-Z]','match'),'multirow');
% MWTindex.text(:,strcmp(MWTindex.textL,task)) = a;
% g = unique(a);
% MWTindex.([task,'L'])(:,strcmp(MWTindex.LL,'text')) = g;
% MWTindex.([task,'L'])(:,strcmp(MWTindex.LL,'code')) = num2cell(1:numel(g))';
% b = [];
% for x = 1:numel(g)
%     b(strcmp(a,g(x)),1) = x;
% end
% MWTindex.code(:,strcmp(MWTindex.codeL,task)) = b;
% 
% 
% % DETERMINE EXPERIMENT OVERLAP BETWEEN GROUPS (ExpGOverlap)
% expind = MWTindex.code(:,strcmp(MWTindex.codeL,'exp')); 
% groupind= MWTindex.code(:,strcmp(MWTindex.codeL,'group')); % get index
% expcode = unique(expind); 
% groupcode = unique(groupind);
% % get exp within group
% ExpGOverlap = {};
% for group = 1:numel(groupcode)
%     ExpGOverlap{group,1} = unique(expind(groupind == groupcode(group),:)); 
% end
% % get overlap exp with control (groupind = 1)
% GroupNames = unique(MWTfList(:,4));
% for group = 1:numel(GroupNames)
% ExpGOverlap{group,2} = intersect(ExpGOverlap{group},ExpGOverlap{1,1});
% end