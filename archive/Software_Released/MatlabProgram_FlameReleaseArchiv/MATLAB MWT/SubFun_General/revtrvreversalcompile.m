function [MWTftrv] = revtrvreversalcompile(pExp)
%% compile reversals
% get reversals data from all plates
[~,pMWTf] = dircontentmwt(pExp);
MWTftrv = {};
for x = 1:size(pMWTf,1);
    ptrv = pMWTf{x,1};
    [MWTftrv1] = getreversalsingleMWTftrv(ptrv);
    i = size(MWTftrv1,2);
    MWTftrv(x,1:i) = MWTftrv1;
end

