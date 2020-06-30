function [expname,pExpter] = findstadexpfoldername(pExp,pFun)
display('Finding standard experiment name...');
[MWTfsn,MWTfail] = draftMWTfname3('*set',pExp); % import a filename for every MWT folder

%% get experiment date
display('validating experiment dates...');
[parse,~] = parseby(MWTfsn(:,1),'_');
A = parse(:,1);
expdate = unique(A); % see if only one entry
structval = isequal(cell2mat(regexp(expdate,'\d\d\d\d\d\d\d\d')),1); % see if is 8 digits
if size(expdate,1) ==1 && structval ==1; % both conditions are met
    edate = cell2mat(expdate);
elseif size(expdate,1) >1
    warning('this folder contains MWT folders from different dates');
    expdate = sortrows(expdate,1); % sort by experiment date
    edate = expdate{1,1}; % pick the lowest date
    display('');
end
    

%% get run condition from name of first file under first MWT folder
display('extracting run condition from first MWT file...');
MWTfname = MWTfsn(1,2); 
under = strfind(MWTfname{1,1},'_'); % find underline
Tracker = MWTfname{1,1}(under(4)+1:under(4)+1); % get tracker name
RC = MWTfname{1,1}(under(3)+1:under(4)-1); % run condition

%% find expter code
display('finding experimenter code...');
[pExpter,~] = fileparts(pExp); % path to expter folder
[~,exptern] = fileparts(pExpter); % get personal folder name
cd(strcat(pFun,'/','MatSetfiles'));
load('expter.mat'); % get expter.mat
a = char(expter(:,1)); % convert to char array for search
r = strmatch(exptern,a); % find expter row id
if isempty(r) ==1; % if r is empty
    display('Experiment may not be stored directly under an Experimenter folder...');
    exptern = input('Type in your full name: ','s');
    char(regexprep(exptern,' ','_'));
    r = strmatch(exptern,a);
    if isempty(r) ==1; % if r is stil empty
        error('Please talk to Conny to get an experimenter code...'); 
    else
        pplcode = expter{r,2}; % get expter code
    end
else
    pplcode = expter{r,2}; % get expter code
end
expname = strcat(edate,Tracker,'_',pplcode,'_',RC); % contruct expname
display 'Standard experiment name found as...';
disp(expname);
end