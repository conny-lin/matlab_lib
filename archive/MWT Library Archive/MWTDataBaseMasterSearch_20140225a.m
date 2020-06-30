function [varargout] = MWTDataBaseMasterSearch(pData)
%% STEP3: INTERPRET INPUT AND DEAL OUTPUT
% HomePath = pData;
O = []; % [CODE] Define output O % temperary assign O = nothing
% STEP2: OPTION INTERPRETATION



display ' ';
choice = {'Run condition';
'Experimenter';
'Date'};
disp(makedisplay(choice))
i = input('Narrow search by: ');
SearchBy = choice{i};
%

% STEP4: USER INPUTS - DEFINE EXP OBJECTIVES
% STEP4A: GET BASIC EXP INFO
display 'Checking if MWTExpDataBase is already loaded';
if exist('pExpfD','var')==0||exist('ExpfnD','var')==0||...
        exist('pMWTfD','var')==0|| exist('MWTfnD','var')==0;
    display 'Loading MWTExpDataBase...';
    [A] = MWTDataBaseMaster(pData,'GetStdMWTDataBase');
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
% display 'Select data by...'
% a = {'Experiment name';'MWT name';'Group name'};
% b = {'E'; 'M'; 'G'};
% display(makedisplay(a));
% display ' ';
% i = input('search method: ');
% searchclass = b{i};
% display 'Enter search term for experiment folder name';

display 'Search Experiment folders';
% searchterm = input(': ','s');
% % find matches
% k = regexp(ExpfnT,searchterm,'once');
% searchindex = logical(celltakeout(k,'singlenumber'));
% pExpfS = pExpfT(searchindex);
% ExpfnS = ExpfnT(searchindex);
% disp(ExpfnS);
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
% 
% display 'MWT files [M], Exp files [E], Group name [G] or no search [A]?';
% searchclass = input(': ','s');
% switch searchclass
%     case 'M' % search for MWT
%         display 'option under construction'
%     case 'G' % search for group name
%         display 'option under construction'
%         
%     case 'E' % search for Experiment folders
%         display 'Enter search term:';
%         searchterm = input(': ','s');
%         % find matches
%         k = regexp(ExpfnD,searchterm,'once');
%         searchindex = logical(celltakeout(k,'singlenumber'));
%         pExpfS = pExpfD(searchindex);
%         ExpfnS = ExpfnD(searchindex);
%         disp(ExpfnS);
%         moresearch = input('Narrow down search (y=1,n=0)?: ');
%         while moresearch==1;
%             display 'Enter search term:';
%             searchterm = input(': ','s');
%             % find matches
%             k = regexp(ExpfnS,searchterm,'once');
%             searchindex = logical(celltakeout(k,'singlenumber'));
%             pExpfS = pExpfS(searchindex);
%             ExpfnS = ExpfnS(searchindex);
%             disp(ExpfnS);
%             moresearch = input('Narrow down search (y=1,n=0)?: ');
%         end
%         pExpfT = pExpfS;
%         ExpfnT = ExpfnS;
%         display 'Target experiments:';
%         disp(ExpfnT); 
%         O.ExpfnT = ExpfnT; % export
%     case 'A'
%         pExpfT = pExpfD;
%         ExpfnT = ExpfnD;
% end  
% if isempty(ExpfnT)==1; display 'No target experiments'; return; end
% 


% STEP4B. GET EXP AND GROUP INFO FROM TARGET EXP
[A] = MWTDataBaseMaster(pExpfT,'GetExpTargetInfo');
Gfn = A.GfnT; pGf = A.pGfT; pMWTfT = A.pMWTfT; MWTfnT = A.MWTfnT;



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
    a = celltakeout(regexp(MWTfn,'\<(\d{8})[_](\d{6})\>','match'),'match');
    expcount = numel(unique(a));
    str = 'Got %d MWT files from %d experiments';
    display(sprintf(str,numel(MWTfn),expcount));
    % create output file
    MWTfG.(gnamechose{g})(:,1:2) = [MWTfn,pMWTf];
end


%% output
varargout{1} = MWTfG;
varargout{2} = pMWTf;




end