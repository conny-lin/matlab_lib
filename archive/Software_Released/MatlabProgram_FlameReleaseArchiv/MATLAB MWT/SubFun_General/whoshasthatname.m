function [exp,mwt,mwtfilename] = whoshasthatname(MWTsum,expr)
i = find(not(cellfun(@isempty,regexp(MWTsum(:,3),expr))));
a = MWTsum(i,1); % list MWT experiment names that have this 
[a,~] = cellfun(@fileparts,a,'UniformOutput',0);
mwt = unique(a);
[~,a] = cellfun(@fileparts,a,'UniformOutput',0);
exp = unique(a);
expcount = numel(a);
mwtfilename = MWTsum(i,3);
% reporting
display(sprintf('The target name [%s] is...',expr));
display(sprintf('found in %d experiments',numel(exp)));
disp(exp);
display(sprintf('and %d MWT files below',numel(mwtfilename)));
disp(mwtfilename);

