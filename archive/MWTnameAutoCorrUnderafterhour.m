function [A] = MWTnameAutoCorrUnderafterhour(MWTfsn)
% "96h_20C" correct to 96h20C
A = MWTfsn(:,2);
ind = not(cellfun(@isempty,regexp(A,'h_'))); % index to those with mistake
if sum(ind) ~= 0; % if there are mistakes
display('Found [h_] mistakes, removing [_]...');
A = regexprep(A,'h_','h'); % remove underscore after hour
end