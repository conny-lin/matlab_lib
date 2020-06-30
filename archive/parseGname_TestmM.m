function B = parseGname_TestmM(G,varargin)

%% 
fn = 'dose_test';
vararginProcessor;
%% input can be rx or MWTDB
%%
if istable(G)
   gn = G.groupname;
elseif iscell(G) && width(G)==1
   gn = G;
end

%%
B = cell(size(gn));
b = regexpcellout(gn,'(?<=[_])\d{1,}(?=mM)','match');
i = ~cellfun(@isempty,b);
B(i) = b(i);
B(~i) = {'0'};

%%

if istable(G)
   G.(fn) = B;
   B = G;
end