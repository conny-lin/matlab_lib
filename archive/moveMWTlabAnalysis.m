function moveMWTlabAnalysis(pExpfT)
%% [Tool] move none MWT files under MatlabAnalysis folder
% PREPARE SAVE PATHS
pExpfS = {};
for e = 1:numel(pExpfT)
    pExp = pExpfT{e};
   [fn,p] = dircontentext(pExp,'MatlabAnalysis*');
   if isempty(p)==1;
       display 'making MatlabAnalysis folder...';
        mkdir(pExp,'MatlabAnalysis');
        pExpfS{e,1} = [pExp,'/','MatlabAnalysis'];
   elseif isdir(char(p))==1; pExpfS(e,1) = p;
   end
end


for e = 1:numel(pExpfS)
    pExpS = pExpfS{e};
    pExp = pExpfT{e};
    [fn,p,fon,po] = dircontent(pExp);
    [fna,i] = setdiff(fn,fon);
    [pExpSc] = cellfunexpr(p(i),pExpS);
    cellfun(@movefile,p(i),pExpSc);
end