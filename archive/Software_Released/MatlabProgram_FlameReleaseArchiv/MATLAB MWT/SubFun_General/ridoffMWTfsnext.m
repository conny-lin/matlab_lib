function [MWTfsn] = ridoffMWTfsnext(MWTfsn)
display('Removing ext from drafted file names...');
a(1:size(MWTfsn,1),1) = {'.set'}; % create cell array
b(1:size(MWTfsn,1),1) = {''};
MWTfsn(:,2) = cellfun(@strrep,MWTfsn(:,2),a,b,'UniformOutput',0); % remove extension
display('done.');
end