function [gp] = findgroupcodefromRCcomp(trackercoldategp)
[gp] = gencellfunexpr(trackercoldategp,'[a-z][a-z]');
[~,~,~,match,~,~,~] = cellfun(@regexp,trackercoldategp,gp,'UniformOutput',0);
for x = 1:size(match,1);
    gp(x,:) = match{x,1};
end
end