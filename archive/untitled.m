groupinfosum = {'ExpName','GroupCode','GroupName'};
for x = 1:numel(pExpV);
    [~,~,fn,pf] = dircontent(pExpV{x});
    [nonmwtf] = cellfun(@isempty,regexp(fn,'(\d{8})[_](\d{6})','match'));
    maybegroup = fn(nonmwtf);
    [groupcode,groupname] = regexp(maybegroup,'[a-z][_]','match','split');
    A = {};
    for x = 1:numel(groupcode)
        A(x,:) = groupcode{x,1}(1);
    end
    a = celltakeout(groupname,'split');
    groupinfo = {};
    expname = cellfunexpr(a,Expfn{x});
    groupinfo = [expname,regexprep(A,'_',''),a(:,2)];
    groupinfosum = [groupinfosum;groupinfo];
end
groupinfosum