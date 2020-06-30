function [sumimport] = importsprevs(pExp)
% import data
[~,psp] = dircontentext(pExp,'*.sprevs'); % get dir for all .sprevs
sumimport = cellfun(@dlmread,psp,'UniformOutput',0); % import all sprevs
cellfun(@delete,psp);
end
