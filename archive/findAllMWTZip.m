function [varargout] = findAllMWTZip(homepath)
% code based on
    % [b] = getalldir(home); 
    % [Output] = dircontentmwtall(HomePath);
%display 'Searching for MWT in all drives, this will take a while...';         
if ischar(homepath) == 1 && size(homepath,1) == 1
    homepath = {homepath};
end

a = cellfun(@genpath,homepath,'UniformOutput',0);
paths = regexpcellout(a,pathsep,'split');
paths(cellfun(@length,paths)<1) = []; % get rid of cell has zero lengh
paths = paths';
[~,fn] = cellfun(@fileparts,paths, 'UniformOutput',0);

%%

search = '(\<(\d{8})[_](\d{6})[.zip]\>)';
k = regexpcellout(fn,search);

%%
Output.pMWTf = paths(k);
Output.MWTfn = fn(k);
  varargout{1} = Output;
  
end  