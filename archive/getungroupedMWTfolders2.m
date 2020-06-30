function [MWTf,pMWTf,P,T] = getungroupedMWTfolders2(pExp) 
%% import only MWT folders and paths 
[~,~,MWTf,pMWTf] = dircontent(pExp); % get path to MWTf
[T,P] = validateMWTfn3(MWTf,pMWTf); % check if all folders are MWTf
% import only passed folder
pMWTf(ismember(T,0)) = [];
MWTf(ismember(T,0)) = [];
end
