function [Groups] = importGroupsMat(pExp)
[groupmatname,p] = dircontentext(pExp,'Groups_*');
if numel(groupmatname)>=1 && iscell(groupmatname)==1;
    cd(pExp);
    load(groupmatname{1});
    Groups = Groups;
else
    Groups = [];
    display 'No Groups_*.mat imported';
   
end