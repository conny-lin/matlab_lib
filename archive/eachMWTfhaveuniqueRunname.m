function [MWTrunameCorr] = eachMWTfhaveuniqueRunname(MWTsum)
%% synchronize names for the same MWT folders
% declare action
display 'Checking if the same MWT file contains the same run names...';

%% get basic informaiton
MWTfn = MWTsum(:,2);
MWTfsn = MWTsum(:,3);
pMWTf = MWTsum(:,1);
MWTrunameCorr = MWTfsn;


%% for each duplicated folder name, check if run names are the same
[trouble,~,sample] = checktrouble2(MWTfsn,MWTfn);

%% while there are duplicated run names, correct
while isempty(trouble) ==0;
    
% correct trouble run names
for x = 1:numel(trouble);
    %% clear out non-sample from MWTfsn
    MWTfnE = MWTfn; 
    MWTfnE(not(sample),1) = {' '};
    MWTfsnE = MWTfsn; 
    MWTfsnE(not(sample),1) = {' '};

    %% construct selection interface
    dupname = trouble{x}; % get duplicated file name of interest
    i = not(cellfun(@isempty,regexp(MWTfsnE,dupname))); % index to duplicated files
    m =find(i);
    dupMWTf = MWTfn(m); % get folder names  
    % get experiment folder name
    dupMWTpaths = pMWTf(m);
    [p,~] = cellfun(@fileparts,dupMWTpaths,'UniformOutput',0);
    [~,expname] = cellfun(@fileparts,p,'UniformOutput',0);
    
    % construct show names
    [dash] = char(cellfunexpr(dupMWTf,')'));
    showfolderame = [num2str((1:numel(dupMWTf))') dash char(dupMWTf)];
    showexpname = [num2str((1:numel(dupMWTf))') dash char(expname)];
    
    %% user selection: correct name to unify
    display ' ';
    display(sprintf('The same run name [%s]',dupname));
    display 'is found in different MWT folders...';
    disp(showfolderame);% show names
    display 'from these experiment folders...';
    disp(showexpname);% show names
    display ' ';
    display 'For each of the above, enter the correct run name as prompt...';
    % repeat for each folders
    for y = 1:numel(m);
        display ' ';
        display(sprintf('For MWT folder [%s]',MWTfn{m(y),1}));
        display(sprintf('The old name is [%s]',dupname));
        MWTrunameCorr{m(y)} = input('Enter the new name: ','s');
    end
    
end
% recheck 
[trouble,~,sample] = checktrouble2(MWTrunameCorr,MWTfn);
end
display 'done.';
end



function [trouble,exclude,sample] = checktrouble2(MWTfsn,MWTfn)
%% find duplicate folders
% duplicate folders should have same run names
% find duplicated folder names
A = tabulate(MWTfn);
k = find(cell2mat(A(:,2)) >1);
dupMWTfna = A(k,1); 
% select just one index with correct run name
exclude = cell(numel(MWTfn),1);

for x = 1:numel(dupMWTfna); 
    % construct selection interface
    % get duplicated file name of interest
    m = find(not(cellfun(@isempty,regexp(MWTfn,dupMWTfna{x,1})))); % index to duplicated files
    % check if run names are the same, if so, pass...
    dupMWTfnames = MWTfsn(m);
    exclude(m(2:end),1)= {'exclude'};     
end
sample = cellfun(@isempty,regexp(exclude,'exclude'));
%% sample = not(exclude);

% get duplicated names only from unique folders
A = tabulate(MWTfsn(sample));
k = cell2mat(A(:,2)) >1; % find MWTfn/MWTfsn combination
trouble = A(k); % get duplicated run names
display(sprintf('>> Found %d duplicated MWT run names',numel(trouble)));
% same name with the same folder doesn't count
%%
end



