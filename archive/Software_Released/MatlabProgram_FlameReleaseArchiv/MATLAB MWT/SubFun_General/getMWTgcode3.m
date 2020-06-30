function [MWTgcode] = getMWTgcode3(MWTfsn)
[split] = regexp(MWTfsn,'_','split');
% take out nameparts
strain = {};
seedcol= {};
growthcond= {};
runcond = {};
tckgp  = {};
for x = 1:numel(split);
    tckgp = [tckgp;split{x}(5)];
end
a = char(tckgp);
MWTgcode = cellstr(a(:,end-1));

