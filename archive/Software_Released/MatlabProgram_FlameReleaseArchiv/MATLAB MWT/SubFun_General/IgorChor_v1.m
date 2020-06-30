function IgorChor_v1(pExp)
% get reversals ignoring tap
display(' ');
display('Runing Choeography analysis...');
[~,pMWTf] = dircontentmwt(pExp);
for x = 1:size(pMWTf,1);
    pMWT = pMWTf{x,1};
    chorb3(pMWT);
end
display('done');

end