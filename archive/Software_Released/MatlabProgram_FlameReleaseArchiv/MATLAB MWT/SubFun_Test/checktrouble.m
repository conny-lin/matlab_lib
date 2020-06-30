
function [dupMWTfntrouble] = checktrouble(MWTfn,MWTfsn)
%% find duplicate folders
A = tabulate(MWTfn);
k = find(cell2mat(A(:,2)) >1);
dupMWTfna = A(k,1); % find duplicated folder names

dupMWTfntrouble = {};
for x = 1:numel(dupMWTfna); 
    % construct selection interface
    dupMWTf = dupMWTfna{x}; % get duplicated file name of interest
    m = not(cellfun(@isempty,regexp(MWTfn,dupMWTf))); % index to duplicated files
    % get run names
    dupMWTnames = MWTfsn(m);
    
    % check if run names are the same, if so, pass...
    if numel(unique(dupMWTnames)) ==1;
        continue
    else
        dupMWTfntrouble = [dupMWTfntrouble;dupMWTf]; % record trouble folders
    end
end
display(sprintf('Found %d MWT files contains inconsistent run name',numel(dupMWTfntrouble)));
%%
end