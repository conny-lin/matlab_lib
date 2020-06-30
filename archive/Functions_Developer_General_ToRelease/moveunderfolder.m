function moveunderfolder(p,pData,pBad)

%% move to bad folder
% [r,c] = find([a,b,c]==0);
% if isempty(r)==0;
%     p = paths(r); % % find files with missing MWT files
a = cellfun(@strrep,p,cellfunexpr(p,pData),cellfunexpr(p,pBad),...
    'UniformOutput',0); % replace pData path with pBadFiles paths

makemisspath(cellfun(@fileparts,a,'UniformOutput',0)); % make folders
cellfun(@movefile,p,a); % move files
% str = '[%d] bad MWT files moved out of Analysis folder';
% display(sprintf(str,numel(a)));
% paths = paths(~r); % update path
% else
%     display 'All MWT files contain .blob, .summary & .set';
% end