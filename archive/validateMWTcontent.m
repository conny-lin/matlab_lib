%% prepare pMWTf input for validation
function [pMWTval,pMWTbad,MWTfnval,MWTfnbad,S] = validateMWTcontent(pMWT)
display 'Validating MWT folder contents...';
% check for number of .blob files > 0
fname = '*.blobs';
a = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
    cellfunexpr(pMWT,fname),'UniformOutput',0))) > 0; 
% check existance of .summary
fname = '*.summary';
b = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
    cellfunexpr(pMWT,fname),'UniformOutput',0))) > 0; 
% check existance of .set
fname = '*.set';
c = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
    cellfunexpr(pMWT,fname),'UniformOutput',0))) > 0; 

% create output array
val = false(size(pMWT));
% get validated MWT paths
val(a == true & b == true & c == true) = true;
pMWTval = pMWT(val);
% get invalid MWT paths
pMWTbad = pMWT(~val);

% get validated MWT names
[~,MWTfnval] = cellfun(@fileparts,pMWTval,'UniformOutput',0);
% get invalid MWT names
[~,MWTfnbad] = cellfun(@fileparts,pMWTbad,'UniformOutput',0);

% summary structural array
S.pMWTval = pMWTval;
S.MWTfnval = MWTfnval;
S.pMWTbad = pMWTbad;
S.MWTfnbad = MWTfnbad;

end