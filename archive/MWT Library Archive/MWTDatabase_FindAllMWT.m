function [varargout] = MWTDatabase_FindAllMWT(pData, varargin)
%% REVISED 
% - 20140415
    % code based on
        % [b] = getalldir(home); 
        % [Output] = dircontentmwtall(HomePath);
    %display 'Searching for MWT in all drives, this will take a while...';         
% - 20140425
    % added lost and found

%% varargin
A = varargin;

%% get option
if isempty(A) == 0
    if isequal(A{1},'LostAndFound') ==1
        option = A{1}; 
    end
    
else
    option = 'Original';
end    

%% validate input
if ischar(pData) == 1 && size(pData,1) == 1
    pData = {pData};
end
display 'Finding MWT files, this will take a while';
a = cellfun(@genpath,pData,'UniformOutput',0);
paths = regexpcellout(a,pathsep,'split');
paths(cellfun(@length,paths)<1) = []; % get rid of cell has zero lengh
paths = paths';
[~,fn] = cellfun(@fileparts,paths, 'UniformOutput',0);
    

%% OPTION SWITCH
switch option
    case 'Original'
        display 'searching for MWT folders';
        search = '\<(\d{8})[_](\d{6})\>';
        k = regexpcellout(fn,search);
        
        
    case 'LostAndFound'
        display 'searching for MWT-like folders';

        search = '\<\d{8}[_]\d{6}'; % start with
        k = regexpcellout(fn,search);

  
end  

%% OUTPUT
pMWTf = paths(k);
MWTfn = fn(k);
Output2.pMWTf = pMWTf;
Output2.MWTfn = MWTfn;
Output = [MWTfn,pMWTf];

%% VARARGOUT
varargout{1} = Output2;
varargout{2} = Output;