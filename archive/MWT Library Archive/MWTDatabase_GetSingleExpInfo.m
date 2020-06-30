function [varargout] = MWTDatabase_GetSingleExpInfo(homepath)
pExpfD = homepath;
% pGfD and GfnD
display 'Searching for Group folders';
[~,~,fn,p] = dircontent(pExpfD);
fn = celltakeout(fn,'multirow');
i = not(celltakeout(regexp(fn,'MatlabAnalysis'),'singlenumber'));
Gfn = fn(i);
p = celltakeout(p,'multirow');
pGf = p(i);
[fn,p,~,~] = cellfun(@dircontent,pGf,'UniformOutput',0);
empty = cellfun(@isempty,fn); % see which group folder is empty
pGfD = pGf(not(empty));
GfnD = Gfn(not(empty));
if sum(empty)>1; 
    pGfproblem = pGf(empty); 
    display 'the following folders are empty:';
    disp(Gfn(empty));
end
str = '%d folders found under Exp folders';
display(sprintf(str,numel(Gfn)));
str = '%d [%d unique] Group folders';
display(sprintf(str,numel(GfnD),numel(unique(GfnD))));
Output.GfnT = GfnD; Output.pGfT = pGfD;

% pMWTfD & MWTfnD
display 'Searching for MWT folders';
fn = celltakeout(fn(not(empty)),'multirow');
p = celltakeout(p(not(empty)),'multirow');
mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
pMWTf = p(mwt); MWTfn = fn(mwt);
str = '%d [%d unique] MWT folders';
display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));
Output.pMWTfT = pMWTf; Output.MWTfnT = MWTfn;

% Zip files?
display 'Searching for zipped files';
zip = logical(celltakeout(regexp(fn,'.zip'),'singlenumber'));
if sum(zip)>1; display 'zipped files found'; 
    pZipf = p(zip); Zipfn = fn(zip);
    disp(Zipfn); 
    str = '%d [%d unique] zip files';
    display(sprintf(str,numel(Zipfn),numel(unique(Zipfn))));
    Output.pZipf = pZipf; Output.Zipfn = Zipfn;
else
    display 'No zip files found.';
end
varargout{1} = Output;
end
