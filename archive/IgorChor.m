function IgorChor(pExpStd)
% get reversals ignoring tap
display(' ');
display('Runing Choeography analysis...');
[~,pMWTf] = dircontentmwt2(pExpStd);
for x = 1:size(pMWTf,1);
    ptrv = pMWTf{x,1};
    chore_Igor_v1(ptrv);
end
display('done');