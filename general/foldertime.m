function [DBtime,DBDir] = foldertime(pDataBase,option)

%% GET DATABASE TIME STAMP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808
if numel(pDataBase)== 1 && ischar(pDataBase)
    DBDir = dir(pDataBase);
    % get rid of . ..
    a = {DBDir.name};
    i = ismember(a,{'.','..','.DS_Store'});
    DBDir(i) = [];
    if nargin == 1
        option = 'folder';
    end
else
    D = cellfun(@dir,pDataBase,'UniformOutput',0);
    % combine
    DBDir = D{1};
    for i = 2:numel(D)
        DBDir = [DBDir; D{i}];
    end
    
end

if nargin == 1
    option = 'file';
end

switch option
    case 'folder'
        % get rid of non folders
        d = ~cell2mat({DBDir(:).isdir});
        % delete non folder
        DBDir(d) = [];

    case 'file'
        
end

% get time from database folders
DBtime = cell2mat({DBDir(:).datenum}');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170808

