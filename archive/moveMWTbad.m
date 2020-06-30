function [D,D1,DS] = moveMWTbad(pD)
[D,D1,DS] = findMWTval_DesignationDrive(pD);

%% move bad D1 to separate folder
% create output folder
p = fileparts(pD);
pN = [p,'/Data Bad'];
if isdir(pN) == 0
    mkdir(pN);
end

p = D1.pMWTbad;
% get paths to new MWT folders
pMWTcopy = p;
p1 = cellfun(@fileparts,pMWTcopy,'UniformOutput',0);
% make new paths
a = cellfun(@strcat,cellfunexpr(p1,pN),p1,'UniformOutput',0);
% make folder
cellfun(@mkdir,a);
% move file
cellfun(@movefile,pMWTcopy,a);

end