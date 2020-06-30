function [uniquenameN,mwtN,P] = detectduplication(MWTfsn)
display('Detecting group code duplication...');
uniquenameN = size(unique(MWTfsn(:,2)),1);
mwtN = size(MWTfsn,1);
P = isequal(uniquenameN,mwtN);

end