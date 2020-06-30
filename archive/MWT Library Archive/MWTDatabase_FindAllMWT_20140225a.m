function [varargout] = MWTDatabase_FindAllMWT(pData)
%% REVISED - 20140415
% code based on
    % [b] = getalldir(home); 
    % [Output] = dircontentmwtall(HomePath);
%display 'Searching for MWT in all drives, this will take a while...';         

%% validate input
if ischar(pData) == 1 && size(pData,1) == 1
    pData = {pData};
end

%%
a = cellfun(@genpath,pData,'UniformOutput',0);
paths = regexpcellout(a,pathsep,'split');
paths(cellfun(@length,paths)<1) = []; % get rid of cell has zero lengh
paths = paths';
[~,fn] = cellfun(@fileparts,paths, 'UniformOutput',0);
search = '(\<(\d{8})[_](\d{6})\>)';
k = regexpcellout(fn,search);
Output.pMWTf = paths(k);
Output.MWTfn = fn(k);
  varargout{1} = Output;
  
end  