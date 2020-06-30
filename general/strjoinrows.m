function Refg = strjoinrows(a,sep)
%% transform table into cell
if istable(a)
   a = table2cell(a);
end
%%
if nargin ==1
    sep = ' ';
end
Refg = cell(size(a,1),1);
for x = 1:size(a,1)
   Refg{x} = strjoin(a(x,:),sep);
end