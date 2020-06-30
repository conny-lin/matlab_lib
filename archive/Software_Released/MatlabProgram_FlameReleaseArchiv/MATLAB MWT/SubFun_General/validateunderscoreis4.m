function [underNwrong,underposition] = validateunderscoreis4(MWTfsn)
A = MWTfsn(:,2); % pull out names from MWTfsn

% underscore number = 4
display 'Checking name contains only 4 underscores...';
underposition = regexp(A,'_'); % get underscore positions
undernumber = cellfun(@numel,underposition) ~= 4; % index to not 4 underscore
if sum(undernumber) ~=0; % if any name contains other than 4 underscore
    display('Some file names contains wrong number of underscore...');
    underNwrong = 1; % record wrongunder
else
    underNwrong =0; % record under number correct
end
