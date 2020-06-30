function [MWTf,pMWTf,P,T] = getungroupedMWTfolders(pExp)% import MWT files
[~,~,MWTf,pMWTf] = dircontent(pExp); % get path to MWTf
[T,P] = validateMWTfn3(MWTf,pMWTf); % check if all folders are MWTf
end
