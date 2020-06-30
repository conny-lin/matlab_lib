function [pX] = flistperlayer(p1)
% function [pX] = flistperlayer(p1)
%
% p1 = path cell array. each row contains a path

pname = 'p%d'; % set up structure array names
pX = {};
for x1 = 1:size(p1,1);
    structname = sprintf(pname,x1);
    pT = dirlist(p1{x1,1});% get paths for within layer 1 folder
    pSize = size(pT,1); % get number of paths
    pX(end+1:end+pSize,1) = pT(:,2);
end

end
