function [RCcomp,strain, startcolony,tsfagetemp,runcond,trackercoldategp] = RCcomponent(MWTfsn)
display('Parsing RC components..');
[under] = gencellfunexpr(MWTfsn,'_');
[~,~,~,~,~,~,split] = cellfun(@regexp,MWTfsn(:,2),under,'UniformOutput',0);
for x = 1:size(split,1)
    RCcomp(x,:) = split{x,1};
end
strain = RCcomp(:,1);
startcolony = RCcomp(:,2);
tsfagetemp = RCcomp(:,3);
runcond = RCcomp(:,4);
trackercoldategp = RCcomp(:,5);
display('done');
end