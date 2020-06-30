function [varargout] = MATAdminMaster_DataStructure(pData)
[A] = MWTDataBaseMaster(pData,'GetStdMWTDataBase');
Expfn = A.ExpfnD;
pExp = A.pExpfD;

% get run condition
a = celltakeout(regexp(A.ExpfnD,'_','split'),'split');
RC = a(:,3); 
Summary = unique(RC);
for x = 1:size(Summary,1)
    i = ismember(RC,Summary{x});
    Summary{x,2} = Expfn(i);
    Summary{x,3} = pExp(i);
    for y = 1:size(Summary{x,2},1)
        f = dircontent(Summary{x,3}{y,1});
        f = f(~ismember(f,{'MatlabAnalysis'}));
        Summary{x,2}(y,2:numel(f)+1) = f';

    end
end
varargout{1} = Summary;
end