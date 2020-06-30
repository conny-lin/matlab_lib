function [MWTf,pMWTf] = dirgroupedMWTf(pExp,except)
%% get directory content
% a = full dir, can be folder or files, b = path to all files, 
% c = only folders, d = paths to only folders
% except = cell array, column list of names to exclude example,
% {'MatLabAnalysis','Analysis'}
MWTf = {};
pMWTf = {};
[~,pExpf,~,~] = dircontentexcept(pExp,except);
for x = 1:size(pExpf,1);
   [~,~,f,pf] = dircontent(pExpf{x,1}); % get MWTf 
   MWTf = cat(1,MWTf,f);
   pMWTf = cat(1,pMWTf,pf); 
end
end
