function [varargout] = MWTDataBaseMaster(homepath,varargin)

switch nargin
    case 2       
        [varargout{1}] = eval([varargin{1},'(homepath)']);
    case 1   
        [varargout] = GetStdMWTDataBase(homepath);
      
end               
    
end



%% Subfunction
function [varargout] = search(homepath,varargin)

pData = homepath;

display ' ';
choice = {'Run condition';'Experimenter';'Date'};
disp(makedisplay(choice))
i = input('Narrow search by: ');
SearchBy = choice{i};


% STEP4: USER INPUTS - DEFINE EXP OBJECTIVES
% STEP4A: GET BASIC EXP INFO
display 'Checking if MWTExpDataBase is already loaded';
if exist('pExpfD','var')==0||exist('ExpfnD','var')==0||...
        exist('pMWTfD','var')==0|| exist('MWTfnD','var')==0;
    display 'Loading MWTExpDataBase...';
    [A] = GetStdMWTDataBase(pData);
    pExpfD = A.pExpfD; ExpfnD = A.ExpfnD; GfnD = A.GfnD;
    pGfD = A.pGfD; pMWTf = A.pMWTf; MWTfn = A.MWTfn;
end

switch SearchBy
    case 'Date'
    case 'Experimenter'
        display([SearchBy,':']);
        a = celltakeout(regexp(ExpfnD,'_','split'),'split');
        RC = a(:,2); 
        r = unique(RC);
        [show] = makedisplay(r,'bracket'); disp(show);
        display(sprintf('Enter %s index,press [ENTER] to abort',SearchBy)); 
        a = input(': ');
        if isempty(a) ==1; 
            return; 
        else
            RCT = r(a);
            i = ismember(r{a},RC);
        end
        % refine exp folder list
        i = ismember(RC,RCT); % index to RC
        ExpfnT = ExpfnD(i); pExpfT = pExpfD(i);
        %display(sprintf('selected RC: %s',RCT{1}));
        display(sprintf('[%d] experiment found',numel(ExpfnT)));
        disp(ExpfnT);

    case 'Run condition'
        % SELECT RUN CONDITION
        % get run condition
        display 'Run conditions:';
        a = celltakeout(regexp(ExpfnD,'_','split'),'split');
        RC = a(:,3); 
        r = unique(RC);
        [show] = makedisplay(r,'bracket'); disp(show);
        display 'Enter run condition number,press [ENTER] to abort'; 
        a = input(': ');
        if isempty(a) ==1; 
            return; 
        else
            RCT = r(a);
            i = ismember(r{a},RC);
        end
        % refine exp folder list
        i = ismember(RC,RCT); % index to RC
        ExpfnT = ExpfnD(i); pExpfT = pExpfD(i);
        display(sprintf('selected RC: %s',RCT{1}));
        display(sprintf('[%d] experiment found',numel(ExpfnT)));
        disp(ExpfnT);
end

% STEP4A: SELECT TARGET EXPERIMENTS
% [release only by experiment search] search for target paths
display ' ';
display 'Search Experiment folders';
pExpfS = pExpfT;
ExpfnS = ExpfnT;
moresearch = input('Narrow down search (y=1,n=0)?: ');
while moresearch==1;
    display 'Enter search term:';
    searchterm = input(': ','s');
    % find matches
    k = regexp(ExpfnS,searchterm,'once');
    searchindex = logical(celltakeout(k,'singlenumber'));
    pExpfS = pExpfS(searchindex);
    ExpfnS = ExpfnS(searchindex);
    disp(ExpfnS);
    moresearch = input('Narrow down search (y=1,n=0)?: ');
end
pExpfT = pExpfS;
ExpfnT = ExpfnS;
display 'Target experiments:';
disp(ExpfnT); 
O.ExpfnT = ExpfnT; % export


% STEP4B. GET EXP AND GROUP INFO FROM TARGET EXP
[A] = GetExpTargetInfo(pExpfT);
Gfn = A.GfnT; pGf = A.pGfT; pMWTfT = A.pMWTfT; MWTfnT = A.MWTfnT;
A.pExp = pExpfT;
A.Expfn = ExpfnT;

% STEP4C: CHOOSE GROUP TO ANALYZE
gnameU = unique(Gfn);
a = num2str((1:numel(gnameU))');
[b] = char(cellfunexpr(gnameU,')'));
c = char(gnameU);
show = [a,b,c];
disp(show);
display 'Choose group(s) to analyze separated by [SPACE]';
display 'enter [ALL] to analyze all groups';
i = input(': ','s');
if strcmp(i,'ALL'); gnamechose = gnameU;
else k = cellfun(@str2num,(regexp(i,'\s','split')'));
    gnamechose = gnameU(k); 
end

% STEP2D: SORT GROUP DISPLAY SEQUENCE
[show] = makedisplay(gnamechose,'bracket');
disp(show);
display 'is this the sequence to be appeared on graphs (y=1 n=0)';
q2 = input(': ');
while q2 ==0;
    display 'Enter the correct sequence separated by [SPACE]';
    s = str2num(input(': ','s'));
    gnamechose = gnamechose(s,1);
    [show] = makedisplay(gnamechose,'bracket');
    disp(show);
    q2 = input('is this correct(y=1 n=0): ');
end

% STEP2B: GET MWT FILES UNDER SELECTED GROUP
% get experiment count for each group
MWTfG = [];
for g = 1:numel(gnamechose);
    str = 'Searching MWT files for group [%s]';
    display(sprintf(str,gnamechose{g}));
    % find MWT files under group folder
    search = ['\<',gnamechose{g},'\>'];
    i = logical(celltakeout(regexp(Gfn,search),'singlenumber'));
    pGfT = pGf(i);
    [MWTfn,pMWTf] = cellfun(@dircontentmwt,pGfT,'UniformOutput',0);
    MWTfn = celltakeout(MWTfn,'multirow');
    pMWTf = celltakeout(pMWTf,'multirow');
%     a = celltakeout(regexp(MWTfn,'\<(\d{8})[_](\d{6})\>','match'),'match');
    i = regexpcellout(MWTfn,'\<(\d{8})[_](\d{6})\>');
%     MWTfn = MWTfn(i)
    expcount = numel(unique(a));
    str = 'Got %d MWT files from %d experiments';
    display(sprintf(str,numel(MWTfn),expcount));
    % create output file
    MWTfG.(gnamechose{g})(:,1:2) = [MWTfn,pMWTf];
end



%% output

varargout{1} = MWTfG;
% varargout{1}{2} = expreport;
end





function [varargout] = FindAllMWT(homepath)
% code based on
    % [b] = getalldir(home); 
    % [Output] = dircontentmwtall(HomePath);
%display 'Searching for MWT in all drives, this will take a while...';         
if ischar(homepath) == 1 && size(homepath,1) == 1
    homepath = {homepath};
end

a = cellfun(@genpath,homepath,'UniformOutput',0);
paths = regexpcellout(a,pathsep,'split');
paths(cellfun(@length,paths)<1) = []; % get rid of cell has zero lengh
paths = paths';
[~,fn] = cellfun(@fileparts,paths, 'UniformOutput',0);
search = '(\<(\d{8})[_](\d{6})\>)';
k = regexpcellout(fn,search);
Output.pMWTf = paths(k);
Output.MWTfn = fn(k);
  varargout{1} = Output;
  
end      
    

function [varargout] = GetSingleExpInfo(homepath)
pExpfD = homepath;
% pGfD and GfnD
display 'Searching for Group folders';
[~,~,fn,p] = dircontent(pExpfD);
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
str = '%d [%d unique] Group folders';
display(sprintf(str,numel(GfnD),numel(unique(GfnD))));
Output.GfnT = GfnD; Output.pGfT = pGfD;

% pMWTfD & MWTfnD
display 'Searching for MWT folders';
fn = celltakeout(fn(not(empty)),'multirow');
p = celltakeout(p(not(empty)),'multirow');
mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
pMWTf = p(mwt); MWTfn = fn(mwt);
str = '%d [%d unique] MWT folders';
display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));
Output.pMWTfT = pMWTf; Output.MWTfnT = MWTfn;

% Zip files?
display 'Searching for zipped files';
zip = logical(celltakeout(regexp(fn,'.zip'),'singlenumber'));
if sum(zip)>1; display 'zipped files found'; 
    pZipf = p(zip); Zipfn = fn(zip);
    disp(Zipfn); 
    str = '%d [%d unique] zip files';
    display(sprintf(str,numel(Zipfn),numel(unique(Zipfn))));
    Output.pZipf = pZipf; Output.Zipfn = Zipfn;
else
    display 'No zip files found.';
end
varargout{1} = Output;
end




function [varargout] = GetExpTargetInfo(homepath)
pExpfD = homepath;
% pGfD and GfnD
display 'Searching for Group folders';
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
    display 'the following folders are empty:';
    disp(Gfn(empty));
end
str = '%d folders found under Exp folders';
display(sprintf(str,numel(Gfn)));
str = '%d [%d unique] Group folders';
display(sprintf(str,numel(GfnD),numel(unique(GfnD))));
Output.GfnT = GfnD; Output.pGfT = pGfD;

% pMWTfD & MWTfnD
display 'Searching for MWT folders';
fn = celltakeout(fn(not(empty)),'multirow');
p = celltakeout(p(not(empty)),'multirow');
mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
pMWTf = p(mwt); MWTfn = fn(mwt);
str = '%d [%d unique] MWT folders';
display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));
Output.pMWTfT = pMWTf; Output.MWTfnT = MWTfn;

% Zip files?
display 'Searching for zipped files';
zip = logical(celltakeout(regexp(fn,'.zip'),'singlenumber'));
if sum(zip)>1; display 'zipped files found'; 
    pZipf = p(zip); Zipfn = fn(zip);
    disp(Zipfn); 
    str = '%d [%d unique] zip files';
    display(sprintf(str,numel(Zipfn),numel(unique(Zipfn))));
    Output.pZipf = pZipf; Output.Zipfn = Zipfn;
else
    display 'No zip files found.';
end
varargout{1} = Output;


end




function [varargout] = GetStdMWTDataBase(homepath)
    
display 'Searching for Experiment folders...';
[~,~,fn,p] = dircontent(homepath);
expnameidentifider = '^\d{8}[A-Z][_]([A-Z]{2})[_](.){1,}';
i = not(cellfun(@isempty,regexp(fn,expnameidentifider,'match')));
pNonExpf = p(not(i)); NonExpfn = fn(not(i));
pExpfD = p(i); ExpfnD = fn(i);
str = '%d [%d standardized] experiment folders';
display(sprintf(str,numel(fn),sum(i)));
Output.pExpfD = pExpfD; Output.ExpfnD = ExpfnD;
Output.NonExpfn = NonExpfn; Output.pNonExpf = pNonExpf;


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
    display '> The following folders are empty:';
    disp(Gfn(empty));
end
str = '> %d folders found under Exp folders';
display(sprintf(str,numel(Gfn)));
str = '> %d [%d unique] Group folders';
display(sprintf(str,numel(GfnD),numel(unique(GfnD))));
Output.GfnD = GfnD; Output.pGfD = pGfD;

% pMWTfD & MWTfnD
display 'Searching for MWT folders...';
fn = celltakeout(fn(not(empty)),'multirow');
p = celltakeout(p(not(empty)),'multirow');
mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
pMWTf = p(mwt); MWTfn = fn(mwt);
str = '> %d [%d unique] MWT folders';
display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));
Output.pMWTf = pMWTf; Output.MWTfn = MWTfn;

% Zip files?
display 'Searching for zipped files...';
zip = logical(celltakeout(regexp(fn,'.zip'),'singlenumber'));
if sum(zip)>1; display 'zipped files found'; 
    pZipf = p(zip); Zipfn = fn(zip);
    disp(Zipfn); 
    str = '> %d [%d unique] zip files';
    display(sprintf(str,numel(Zipfn),numel(unique(Zipfn))));
    Output.pZipf = pZipf; Output.Zipfn = Zipfn;
else
    display '> No zip files found.';
end
varargout{1} = Output;

end