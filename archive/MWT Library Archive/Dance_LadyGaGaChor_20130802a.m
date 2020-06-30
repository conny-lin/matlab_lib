function LadyGaGaChor_v1(pExp)
% get reversals ignoring tap
display(' ');
display('Runing Choeography analysis...');
[~,pMWTf] = dircontentmwt(pExp);
for x = 1:size(pMWTf,1);
    pMWT = pMWTf{x,1};
    chorreversalignortap(pMWT);
end
display('done');

end