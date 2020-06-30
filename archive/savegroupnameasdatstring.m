function savegroupnameasdatstring(pExp)
load('Groups_1Set','Groups')
[under] = cellfunexpr(Groups,'_');
a = cellfun(@strcat,Groups(:,1),under,Groups(:,2),'UniformOutput',0);
b = a{1};
for x = 2:numel(a)
    b = [b,'_',a{x}];
end
name = ['GroupName_',b,'.gcn'];
cd(pExp)
save(name,'name');