
%% README.
% this function provide a summary of experiment done by an experimenter


%% PATHS:
pSaveA = MWTSet.PATHS.pSaveA;


%% SURVEY DATABASE  % [updated 20150412]
pData = MWTSet.PATHS.pData;
% [MWTSet] = MWTAnalysisSetUpMaster(pList);

% search data base for exp folders + valid folder names
display 'Searching for Experiment folders...';
[~,~,fn,p] = dircontent(pData); 
str = '^\d{8}[A-Z][_]([A-Z]{2})[_](.){1,}';
i = not(cellfun(@isempty,regexp(fn,str,'match')));
pNonExpf = p(not(i)); 
NonExpfn = fn(not(i));
pExpfD = p(i); 
ExpfnD = fn(i);
Database.pExpfD = pExpfD; 
Database.ExpfnD = ExpfnD;
Database.NonExpfn = NonExpfn; 
Database.pNonExpf = pNonExpf;

% reporting
str = 'Found: %d/%d standardized experiment folders';
display(sprintf(str,sum(i),numel(fn)));

% display unstandardized expfolders + prompt for correction
if sum(~i) ~=0; 
    display 'unstandardized exp folder names:';
    disp(NonExpfn)
    error('please correct exp folder name then rerun Dance...');
end

% pGfD and GfnD
display 'Searching for Group folders...';
[~,~,fn,p] = cellfun(@dircontent,pExpfD,'UniformOutput',0);
fn = celltakeout(fn,'multirow');
i = not(celltakeout(regexp(fn,'MatlabAnalysis'),'singlenumber'));
Gfn = fn(i);
p = celltakeout(p,'multirow');
pGf = p(i);
[fn,p,~,~] = cellfun(@dircontent,pGf,'UniformOutput',0);
empty = cellfun(@isempty,fn); % see which group folder is empty
pGfD = pGf(not(empty));
GfnD = Gfn(not(empty));
if sum(empty)>1; 
    pGfproblem = pGf(empty); 
    display ' ';
    warning('The following folders are empty:');
    disp(Gfn(empty));
    [~,a] = cellfun(@fileparts,...
        cellfun(@fileparts,pGfproblem,'UniformOutput',0),...
        'UniformOutput',0);
    display('From the following exp folders:');
    disp(unique(a))
    error('please correct before running Dance again');
end
str = '> %d group folders found under Exp folders';
display(sprintf(str,numel(Gfn)));
str = '> %d/%d unique Group folders';
display(sprintf(str,numel(unique(GfnD)),numel(GfnD)));
Database.GfnD = GfnD; Database.pGfD = pGfD;


% pMWTfD & MWTfnD
display 'Searching for MWT folders...';
fn = celltakeout(fn(not(empty)),'multirow');
p = celltakeout(p(not(empty)),'multirow');

mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
pMWTf = p(mwt); 
MWTfn = fn(mwt);
Database.pMWTf = pMWTf; 
Database.MWTfn = MWTfn;

% Zip files?
zip = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>.zip'),'singlenumber'));
pZipf = p(zip); 
Zipfn = fn(zip);
Database.pZipf = pZipf; 
Database.Zipfn = Zipfn;

% reporting
str = '> %d/%d unique MWT folders';
display(sprintf(str,numel(unique(MWTfn)),numel(MWTfn)));
if sum(zip)>1; 
    str = '> %d/%d unique zip files';
    display(sprintf(str,numel(unique(Zipfn)),numel(Zipfn)));

else
    display '> No zip files found.';
end

% zip unzipped files
pMWTfnotZip = pMWTf(~ismember(pMWTf, pZipf));
[~,unzipNames] = cellfun(@fileparts,pMWTfnotZip,'UniformOutput',0);
if isempty(unzipNames) == 0
    display('Found unzipped files: ')
    disp(unzipNames);
    [~,a] = cellfun(@fileparts,...
        cellfun(@fileparts,...
        cellfun(@fileparts,pMWTfnotZip,'UniformOutput',0),...
        'UniformOutput',0),...
        'UniformOutput',0);
    display('From the following exp folders:');
    disp(unique(a))
    error('Please fix unzip files then rerun analysis');
end


%% USER INPUT: SELECT EXPERIMENTER CODE THAT REQUIRES A SUMMARY
% BUG: need to fix unable to repeated narrowing down searches

% option list
display ' '; display 'Filtering files to analyze:';
choice = { 'Run condition';'Experimenter';'After a Date';'Key words'};       
% Search--
display ' '; display 'Search Experiment folders...';
% get database
ExpfnT = Database.ExpfnD;
pExpfT = Database.pExpfD;

display('Experimenter codes:');
a = regexpcellout(ExpfnD,'_','split');
RC = a(:,2); 
r = unique(RC);
[show] = makedisplay(r,'bracket'); disp(show);
display('Enter Experimenter index,press [ENTER] to abort'); 
a = input(': ');
if isempty(a) ==1; 
    return; 
else
    RCT = r(a);
    i = ismember(r{a},RC);
end
i = ismember(RC,RCT); % index to RC
ExpfnT = ExpfnD(i); pExpfT = pExpfD(i);
display(sprintf('[%d] experiment found',numel(ExpfnT)));
disp(ExpfnT);
            

%% GET EXP AND GROUP INFO FROM TARGET EXP
% pGfD and GfnD
display 'Searching for Group folders';
[~,~,fn,p] = cellfun(@dircontent,pExpfT,'UniformOutput',0);
fn = celltakeout(fn,'multirow');
i = not(celltakeout(regexp(fn,'MatlabAnalysis'),'singlenumber'));
Gfn = fn(i);
p = celltakeout(p,'multirow');
pGf = p(i);
[fn,p,~,~] = cellfun(@dircontent,pGf,'UniformOutput',0);
empty = cellfun(@isempty,fn); % see which group folder is empty
pGfD = pGf(not(empty));
GfnD = Gfn(not(empty));
if sum(empty)>1; 
    pGfproblem = pGf(empty); 
    display 'the following folders are empty:';
    disp(Gfn(empty));
end
str = '%d folders found under Exp folders';
display(sprintf(str,numel(Gfn)));
str = '%d/%d unique Group folders';
display(sprintf(str,numel(unique(GfnD)),numel(GfnD)));
Database.GfnT = GfnD; Database.pGfT = pGfD;
% pMWTfD & MWTfnD
display 'Searching for MWT folders';
fn = celltakeout(fn(not(empty)),'multirow');
p = celltakeout(p(not(empty)),'multirow');
mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
pMWTf = p(mwt); MWTfn = fn(mwt);
str = '%d [%d unique] MWT folders';
display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));


%% summarize pMWT
[pG,MWTn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
[pE,Gn] = cellfun(@fileparts,pG,'UniformOutput',0);
[~,En] = cellfun(@fileparts,pE,'UniformOutput',0);
MWTSet.MWTInfo.pMWT_Zip = pMWTf; 
MWTSet.MWTInfo.pMWT = regexprep(pMWTf,'.zip',''); 
MWTSet.MWTInfo.MWTfn = regexprep(MWTfn,'.zip','');
MWTSet.MWTInfo.MWTfn = regexprep(MWTfn,'.zip','');
MWTSet.MWTInfo.GroupName = Gn;
MWTSet.MWTInfo.pGroup = pG;
MWTSet.MWTInfo.ExpName = En;
MWTSet.MWTInfo.pE = pE;

%% summary of experiments
T = table;

% list of experiments
ExpName = MWTSet.MWTInfo.ExpName;
T.ExpName = ExpName;

% split exp name
ExpParts = regexpcellout(ExpName, '_','split');

% expdate
b = ExpParts(:,1);
T.ExpDate = regexpcellout(b,'^\d{8}','match');

% tracker
b = ExpParts(:,1);
T.Tracker = regexpcellout(b,'[A-Z]','match');

% expter
b = ExpParts(:,2);
T.Expter = regexpcellout(b,'[A-Z]{2,}','match');

% run condition
b = ExpParts(:,3);
T.RunCondition = b;


% save list in .txt
T.ExpName = En;
T.GroupName = Gn;

% strain name
a = regexpcellout(Gn,'_','split');
T.Strain = a(:,1);


% group condition
A = {};
for x = 1:numel(Gn)
    a = regexp(Gn{x},'_');
    if isempty(a) ==1
        A{x,1} = {};
    else
        b = Gn{x};
        A{x,1} = b(a+1:end);
    end
end
T.GroupCond = A;


T.MWTName = MWTSet.MWTInfo.MWTfn;
cd(pSaveA); 
writetable(T,'Experiment Summary.txt','Delimiter','\t')


%% Text reports
display 'Unique run conditions:'
RCL = T.RunCondition;
RCU = unique(RCL);
disp(char(RCU))

%% within each run condition what group names:
GN = T.GroupName;
for x = 1:numel(RCU)
    i = ismember(RCL,RCU{x});
    GNL = GN(i);
    display ' ';
    display(sprintf('These groups belongs to RC[%s]: ',RCU{x}));
    a = tabulate(GNL);
    disp(a)
    T = cell2table(a);
    cd(pSaveA);
    writetable(T,[RCU{x},'.txt'],'Delimiter','\t');
% char(unique(T.GroupName))
    
end







