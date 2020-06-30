function [trouble] = checktrouble2(MWTfsn,MWTfn)
%% find duplicate folders
% duplicate folders should have same run names
% find duplicated folder names
A = tabulate(MWTfn);
k = find(cell2mat(A(:,2)) >1);
dupMWTfna = A(k,1); 
% select just one index with correct run name
exclude = zeros(numel(MWTfn),1);
for x = 1:numel(dupMWTfna); 
    % construct selection interface
    % get duplicated file name of interest
    m = find(not(cellfun(@isempty,regexp(MWTfn,dupMWTfna{x,1})))); % index to duplicated files
    % get run names
    dupMWTfnames = MWTfsn(m);
    
    % check if run names are the same, if so, pass...
    if numel(unique(dupMWTfnames)) ==1;

    else % if not, record as fail
        error 'Same MWT folders have different run name, please correct that first';
    end
    a = zeros(numel(MWTfn),1);
    a(m(2:end),1) = 1;
    exclude = exclude + a;     
end
sample = not(exclude);

% get duplicated names only from unique folders
A = tabulate(MWTfsn(sample));
k = cell2mat(A(:,2)) >1; % find MWTfn/MWTfsn combination
sum(k);
trouble = A(k); % get duplicated run names
display(sprintf('>> Found %d duplicated MWT run names',numel(trouble)));
% same name with the same folder doesn't count

end
