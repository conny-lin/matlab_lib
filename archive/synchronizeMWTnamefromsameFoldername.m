function [MWTrunameCorr] = synchronizeMWTnamefromsameFoldername(MWTsum)
%% synchronize names for the same MWT folders
% declare action
display ' ';
display 'Checking if the same MWT file contains the same run names...';

%% get basic informaiton
MWTfn = MWTsum(:,2);
MWTfsn = MWTsum(:,3);
pMWTf = MWTsum(:,1);
MWTrunameCorr = MWTfsn;

%% for each duplicated folder name, check if run names are the same
[dupMWTfntrouble] = checktrouble(MWTfn,MWTfsn);

%% correction
while isempty(dupMWTfntrouble) ==0;
% correct trouble folders
for x = 1:numel(dupMWTfntrouble);
    % construct selection interface
    dupMWTf = dupMWTfntrouble{x}; % get duplicated file name of interest
    m = not(cellfun(@isempty,regexp(MWTfn,dupMWTf))); % index to duplicated files
    dupMWTnames = MWTfsn(m); % get run names
    % get experiment folder name
    dupMWTpaths = pMWTf(m);
    [p,~] = cellfun(@fileparts,dupMWTpaths,'UniformOutput',0);
    [~,expname] = cellfun(@fileparts,p,'UniformOutput',0);
    % construct show names
    [dash] = char(cellfunexpr(dupMWTnames,')'));
    showruname = [num2str((1:numel(dupMWTnames))') dash char(dupMWTnames)];
    showexpname = [num2str((1:numel(dupMWTnames))') dash char(expname)];
    
    % user selection: correct name to unify
    display ' ';
    display(sprintf('The same MWT folder [%s]',dupMWTf));
    display 'is found in experiment folders...';
    disp(showexpname);% show names
    display 'but contains different run names';
    disp(showruname);% show names
    display ' ';
    j = input('Select the correct run name to unify: ');
    
    % make changes 
    expnamecorr = dupMWTnames(j); % get the correct name
    [a] = cellfunexpr(dupMWTnames,expnamecorr); % construct cellfun
    % get location of the files
    m = not(cellfun(@isempty,regexp(MWTfn,dupMWTf))); % index to duplicated folders
    MWTrunameCorr(m) = expnamecorr; % correct name
end
% recheck 
display 'Re-checking user entry...';
[dupMWTfntrouble] = checktrouble(MWTfn,MWTrunameCorr);
if isempty(dupMWTfntrouble) ==1;
    display 'Success.';
else
    display 'Problem persists, re-run name changes...';
end
end
end


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
display(sprintf('>> Found %d MWT files contains inconsistent run name',numel(dupMWTfntrouble)));
%%
end
