function moveRaw2Analysis(Home)
[~,~,~,pExpf] = dircontent(Home);
[pPortal,~] = fileparts(Home);
d = datestr(date,'yyyymmdd'); 
mkdir(pPortal,['MWT_Analysis_' d]);
pAna = [pPortal,'/',['MWT_Analysis_' d]];
[pAnaD] = cellfunexpr(pExpf,pAna);
cellfun(@movefile,pExpf,pAnaD);