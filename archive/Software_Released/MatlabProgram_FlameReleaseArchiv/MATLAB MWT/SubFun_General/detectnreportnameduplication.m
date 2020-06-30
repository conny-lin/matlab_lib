function [duplicatename,P] = detectnreportnameduplication(MWTfsn)
display('Detecting group code duplication...');
T = tabulate(MWTfsn(:,2));
i = find(cell2mat(T(:,2))>1);
if isempty(i) ==0;
    duplicateN = size(i,1); % number of duplicated files
    display(sprintf('Found %d names used more than once',duplicateN));
    duplicatename = sortrows(T([i],1));
    disp(duplicatename); % display duplicated file
    corrind = setdiff((1:size(T,1)'),i); % get number 
    %corrN = sortrows(T([corrind],1)); % file not duplicated
    P = 0;
else
    P = 1;
end

end