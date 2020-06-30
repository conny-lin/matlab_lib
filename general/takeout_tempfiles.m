function [p2,names] = takeout_tempfiles(p)

%%
[~,names] = cellfun(@fileparts,p,'UniformOutput',0);
i = cellfun(@isempty,names) | regexpcellout(names,'^[.]');
names = names(~i);
p2 = p(~i);

cellfun(@delete,p(i)); % delete temp file

