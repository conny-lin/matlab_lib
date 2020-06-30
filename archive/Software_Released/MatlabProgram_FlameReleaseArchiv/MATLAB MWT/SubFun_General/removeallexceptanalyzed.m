function removeallexceptanalyzed(pExpO)
% delete .blobs, .set .summary .png
display(' ');
display('Cleaning up data and backing up...');
[~,pMWTf] = dircontentmwt2(pExpO);
for x = 1:size(pMWTf);
    [~,blobs] = dircontentext(pMWTf{x,1},'*.blobs');
    [~,png] = dircontentext(pMWTf{x,1},'*.png');
    [~,set] = dircontentext(pMWTf{x,1},'*.set');
    [~,summary] = dircontentext(pMWTf{x,1},'*.summary');
    rawfiles = cat(1,blobs,png,set,summary);
    cellfun(@delete,rawfiles);
end