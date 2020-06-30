function [MWTfgcode] = makeMWTfgcode(pExp)
% import Groups_.mat
[groupmatname,p] = dircontentext(pExp,'Groups_*');
if numel(groupmatname)>=1 && iscell(groupmatname)==1;
    cd(pExp);
    load(groupmatname{1},'Groups');
    if exist('Groups','var')==0; 
        error 'Missing MWTfgcode var from Groups_*.mat import';
    end
else
    error 'No Groups_*.mat imported';
end
groupcode = Groups(:,1);
[MWTfn,pMWTf] = dircontentmwt(pExp);
[MWTfsn,MWTsum] = getMWTruname(pMWTf,MWTfn);
[~,~,~,~,trackergroup] = parseMWTfnbyunder(MWTfsn);
a = char(trackergroup);
mwtgcode = cellstr(a(:,end-1));
MWTfgcode = Groups;
for xg = 1:numel(groupcode); % for each group
    i = find(not(cellfun(@isempty,regexp(mwtgcode,groupcode{xg}))));
    MWTfgcode(xg,3) = {num2cell(i)'};
end
cd(pExp);
save(groupmatname{1});