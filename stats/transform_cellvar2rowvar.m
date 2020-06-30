function [v,group] = transform_cellvar2rowvar(colvar)

%%
if size(colvar,1)==1
   colvar =  colvar';
end
ncol = numel(colvar);
[nrow,~] = cellfun(@size,colvar,'UniformOutput',0);
nrow = cell2mat(nrow);

group = nan(sum(nrow),1);
n = 1;
for i = 1:ncol
    n1 = nrow(i)+n-1;
    group(n:n1) = i;
    n = n1+1;
end

v = cell2mat(colvar);


if numel(v)~=numel(group)
   error('conversion failed'); 
end

