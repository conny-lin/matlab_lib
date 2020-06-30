function movezip2Raw(home,pRaw)
[~,p] = dircontentext(home,'*.zip');
[pRawc] = cellfunexpr(p,pRaw);
cellfun(@movefile,p,pRawc);