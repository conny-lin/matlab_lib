function [varargout] = MWTDatabase_search(homepath,varargin)

pData = homepath;

%% STEP4A: GET BASIC EXP INFO
display 'Loading info from MWT database...';
% if exist('pExpfD','var')==0||exist('ExpfnD','var')==0||...
%         exist('pMWTfD','var')==0|| exist('MWTfnD','var')==0;
%     display 'Loading MWTExpDataBase...';
[A] = GetStdMWTDataBase(pData);
pExpfD = A.pExpfD; 
ExpfnD = A.ExpfnD; 
GfnD = A.GfnD; 
pGfD = A.pGfD; 
pMWTf = A.pMWTf; 
MWTfn = A.MWTfn;
% end


%% OPTION LIST
display ' ';
choice = {
% 'Group';    
'Run condition';
'Experimenter';
'Date';
'Key words'};

        
%% Search
display ' ';
display 'Search Experiment folders...';
moresearch = 1;

ExpfnT = ExpfnD;
pExpfT = pExpfD;

while moresearch==1;
    
    disp(makedisplay(choice))
    i = input('Search database by: ');
    
    SearchBy = choice{i};
    
    switch SearchBy
        case 'Date'
            [pExpfT,ExpfnT] = MWTDatabase_searchbyDate(ExpfnT,pExpfT);


        case 'Experimenter'
            [pExpfT,ExpfnT] = MWTDatabase_searchbyExpter(ExpfnT,pExpfT);
            % query TARGET EXPERIMENTS
    %         [pExpfT,ExpfnT] = MWTDatabase_queryExpname(pExpfT,ExpfnT);

        case 'Run condition'
            [pExpfT,ExpfnT] = MWTDatabase_searchbyRC(ExpfnT,pExpfT);
            % query TARGET EXPERIMENTS
    %         [pExpfT,ExpfnT] = MWTDatabase_queryExpname(pExpfT,ExpfnT);

        case 'Key words'
            [pExpfT,ExpfnT] = MWTDatabase_queryExpname(pExpfT,ExpfnT);
            
    end
%     display ' ';
%     display 'Experiment folders';
%     disp(ExpfnT);
    moresearch = input('Narrow down search (y=1,n=0)?: ');
    
    
end



%% STEP4B. GET EXP AND GROUP INFO FROM TARGET EXP
[A] = GetExpTargetInfo(pExpfT);
Gfn = A.GfnT; pGf = A.pGfT; pMWTfT = A.pMWTfT; MWTfnT = A.MWTfnT;
A.pExp = pExpfT;
A.Expfn = ExpfnT;


%% STEP4C: CHOOSE GROUP TO ANALYZE
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
% [show] = makedisplay(gnamechose,'bracket');
% disp(show);
% display 'is this the sequence to be appeared on graphs (y=1 n=0)';
% q2 = input(': ');
% while q2 ==0;
%     display 'Enter the correct sequence separated by [SPACE]';
%     s = str2num(input(': ','s'));
%     gnamechose = gnamechose(s,1);
%     [show] = makedisplay(gnamechose,'bracket');
%     disp(show);
%     q2 = input('is this correct(y=1 n=0): ');
% end

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
