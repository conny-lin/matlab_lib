function [MWTfsn] = MWTnamecheckSwitchBoard(pExp)
%%
display('Checking MWT run names...');
[MWTfsn,~] = draftMWTfname3('*set',pExp); % get names

%% Checking underscore =4 ---------------------------------------------
[underNwrong,underposition] = validateunderscoreis4(MWTfsn);

%% auto correct for common mistakes re underscore --------------------------
if underNwrong ==1;
display 'Correcting commmon underscore mistakes...';
[A] = MWTnameAutoCorrUnderafterhour(MWTfsn); % "96h_20C" correct to 96h20C
[MWTfsn] = MWTfnCorrect(MWTfsn,A,pExp); % correct file name
end


%% correct strain vs group names
A = MWTfsn(:,2); % pull out names from MWTfsn
displayoldgroupcode(pExp); % look at Groups mat

% get strain, group plate
nameparts = regexp(A,'_','split'); %get name parts
for x = 1:numel(nameparts);
strain(x,1) = nameparts{x}(1,1); % get strain
group{x,1} = nameparts{x}{1,5}(end-1:end-1); % get last part
plate(x,1) = nameparts{x}{1,5}(end); % get last part
end

% create selection display
b1(1:numel(group),1) = '[';
b2(1:numel(group),1) = ']';
show = unique(strcat(b1,group,b2,strain));
show = [(num2cell(1:numel(show)))' show];

% ask if correct
disp(show);
correct = input('Above correct (y=1,n=0): ');
while correct ==0;
choice = cell(1,2);
select = input('Select index to incorrectly assigned group code: ');
n = 0;  
while select ~=0;
n = n+1;
choice(n,1)= show(select,2); % pull out the choice and ask
disp(choice); 
choice{n,2} = input('Enter correct group code: ','s'); % delete or change code
show(select,:) = []; % delete selectin from show
show = [(num2cell(1:size(show,1)))' show(:,2)] % restructure index
select = input('Select index to incorrectly assigned group code,\n press 0 if all correct: ');
end

% reasemble correct name
for x = 1:numel(choice(:,1)) % for each that needs to be changed
    % find ones with oldgroup code and the strain name of interest
    strainname = choice{x,1}(4:end); % get strain name
    i = not(cellfun(@isempty,(regexp(A,strainname)))); % pull out ones with the right strainname
    oldgroupcode = choice{x,1}(2); % get old group code
    j = not(cellfun(@isempty,strfind(group,oldgroupcode))); % get index 
    k = (i+j)==2; % get index to name needs to be changed
    oldgp = [cell2mat(group(k)) plate(k)]; % construct old group plate cod
    newgroupcode(1:numel(group(k)),1) = choice{x,2}(1);
    newgp = [newgroupcode plate(k)]; % construct new group plate code
    A(k) = regexprep(A(k),cellstr(oldgp),cellstr(newgp)); % change group code
end


% get new strain, group plate
nameparts = regexp(A,'_','split'); %get name parts
for x = 1:numel(nameparts);
strain(x,1) = nameparts{x}(1,1); % get strain
group{x,1} = nameparts{x}{1,5}(end-1:end-1); % get last part
end

% re-create display
b1(1:numel(group),1) = '[';
b2(1:numel(group),1) = ']';
show = [char(group) b1 char(strain) b2 char(MWTfsn(:,1)) ] % file, 
show2 = sortrows(cellstr(show));

% checking correction
display 'Double checking group names before changing file names...';
display 'group code sorted by MWT time:'
disp(show);
display 'group code sorted by group/plate code: ';
disp(show2);
correct = input('Correct (y=1,n=0)? ');
end

% correct file name
if correct ==1;
changeMWTname(pExp,MWTfsn,[MWTfsn(:,1) A]); % correct file names
[MWTfsn] = draftMWTfname3('*set',pExp); % reload MWTfsn
end




%% [BUG] duplicated names ------------------------------------------------
display('Checking for duplicated MWT run names...');
while numel(A) ~= numel(unique(A)); % unique name is not equal to number of names
B = tabulate(A); % find incidences of each name
dupInd = cell2mat(B(:,2)) ~=1; % find index that has more than one inciences
dupnames = B(dupInd,1); % get duplicated names

% correct duplicated name
for x = 1:numel(dupnames)
    a = cellfun(@isempty,strfind(A(:),dupnames{x})) ==0;% find index to duplicated files  
    % change duplicated name 
    while numel(A(a)) ~= numel(unique(A(a))); % if still duplication
    display '  ';
    display 'MWT file below ';
    file = MWTfsn(a,1); 
    disp([num2cell((1:sum(a))') file]);
    disp(['has the same name: ' dupnames{x}]);
    i = input('Choose the MWT file index for which name needs to be changed:\n');
    newname = input('Enter the correct name: ','s');
    A(not(cellfun(@isempty,strfind(MWTfsn(:,1),file{i,1})))) = {newname}; % replace name
    a = cellfun(@isempty,strfind(A(:),dupnames{x})) ==0;% find index to duplicated files  
    end
end
end
% correct names
changeMWTname(pExp,MWTfsn,A); % correct files
[MWTfsn] = draftMWTfname2('*set',pExp); % reload MWTfsn

%% Manual check --------------------------------------------------------
A = MWTfsn;
disp('');
[show] = displayallMWTfrunname2(A);
displayoldgroupcode(pExp);
q1 = input('Are all MWTf named correctly? (y=1,n=0) ');
while q1==0;
B = A;
correct = input('Which one is not correct? ');
q0 = 0;
while q0 == 0;      
    disp('');
    disp(sprintf('for MWT experiment: %s',A{correct,1}));
    disp(sprintf('MWT current run name: %s',A{x,2}));
    B{correct,2} = input('Enter the correct name: ','s');
    q0 = input('is this name correct? (y=1,n=0) ');  
end

% double check
[show] = displayallMWTfrunname2(B);
q1 = input('Are all MWTf named correctly now? (y=1,n=0) ');
end
A = B;

% correct names
changeMWTname(pExp,MWTfsn,A); % correct files
[MWTfsn] = draftMWTfname2('*set',pExp); % reload MWTfsn


%% [CODE] 
t = 0; % turn off this part for now
switch t
    case 0
    case 1
        displayoldgroupcode(pExp); % show old group code to gi to give an idea
        % strain name incorrect, correct it automatically
        % validate name parts
        [A] = validateMWTfnameparts(MWTfsn);
        %% manually change names part by part (16 parts)
        correctMWTnamebyparts(MWTfsn,pExp);
end

%% Reload current MWTfsn
[MWTfsn,~] = draftMWTfname3('*set',pExp); % get names

end

