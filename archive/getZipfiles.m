function [pExpf,pzipf] = getZipfiles(f)
%% f = list of folders paths in cell array
% get you paths to zip files (pzipf) and path to folders containing zip
% files
pzipf = {};
pExpf = {};
for x = 1:numel(f)
   if isdir(f{x}) ==1;
       [~,p] = dircontentext(f{x},'*.zip');
       if isempty(p) ~=1;
           pExpf = [pExpf;f(x)]; % record as it is exp folder
           pzipf = [pzipf;p];
       end
   end
end
end