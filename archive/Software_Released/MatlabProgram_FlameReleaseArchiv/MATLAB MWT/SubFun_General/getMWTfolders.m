function [MWTf,pMWTf,T] = getMWTfolders(pExp)% import MWT files
[~,~,MWTf,pMWTf] = dircontent(pExp); % get path to MWTf
[T] = validateMWTfn(MWTf,pMWTf); % check if all folders are MWTf
end