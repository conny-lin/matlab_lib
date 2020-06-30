function [fn,pf] = getallfileMWTfext(pExp,ext)
[~,pMWTf] = dircontentmwt(pExp);
fn = {};
pf = {};
for x = 1:numel(pMWTf);
    [fext,pfext] = dircontentext(pMWTf{x,1},ext);
    fn = cat(1,fn,fext);
    pf = cat(1,pf,pfext); 
end
end