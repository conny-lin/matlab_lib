function [strain,seedcol,growthcond,runcond,tckgp] = parseMWTfsn(MWTfsn)
[split] = regexp(MWTfsn,'_','split');
% take out nameparts
strain = {};
seedcol= {};
growthcond= {};
runcond = {};
tckgp  = {};
for x = 1:numel(split);
    strain = [strain;split{x}(1)];
    seedcol = [seedcol;split{x}(2)];
    growthcond = [growthcond;split{x}(3)];
    runcond = [runcond;split{x}(4)];
    tckgp = [tckgp;split{x}(5)];
end