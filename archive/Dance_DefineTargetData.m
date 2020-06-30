function [MWTindex,RCT] = Dance_DefineTargetData(Target,OPTION)
% GET DATABASE
%Target = pData;
[A] = MWTDataBaseMaster(Target,'GetStdMWTDataBase');
pExpfD = A.pExpfD; ExpfnD = A.ExpfnD; 

% SELECT RUN CONDITION
switch OPTION.ISI 
    case '10sISI'
        RCT = '100s30x10s10s';
        i = regexpcellout(ExpfnD,RCT); 
    case '60sISI'
        RCT = '100s30x60s10s';
        i = regexpcellout(ExpfnD,RCT);  
    otherwise
        % get run condition
        a = celltakeout(regexp(ExpfnD,'_','split'),'split'); RC = a(:,3); 
        display 'please select from the following list:';
        RCU = unique(RC);
        [show] = makedisplay(RCU,'bracket'); disp(show);
        display 'Enter run condition number,press [ENTER] to abort'; 
        a = input(': ');
        if isempty(a) ==1; return; else RCT = RCU{a}; end
        % refine exp folder list
        i = ismember(RC,RCT); % index to RC
end
Target = pExpfD(i);

% SELECT GROUPS 
% Target = pExpfD(i); restricted to run condition
[A] = MWTDataBaseMaster(Target,'GetExpTargetInfo');
Gfn = A.GfnT; pGf = A.pGfT; pMWTfT = A.pMWTfT; MWTfnT = A.MWTfnT;

% select group names
name = fieldnames(OPTION);
if isempty(strcmp(name,'Control')) ==1;
    % if option to analyze only control (1 group)
    GroupNames = OPTION.Control;
else
    % CHOOSE GROUP
    % make instruction
    a = 'Instruction: ';
    b = '-Choose group(s) to analyze separated by [SPACE]';
    c = '-first group will be the control group';
    d = '-graphing will follow the sequence of groups you entered';
    e = '-enter [ALL] to analyze all groups';
    instruction = sprintf('%s\n%s\n%s\n%s\n%s',a,b,c,d,e);

    % get unique group list (gnameU)
    gnameU = unique(Gfn); % find unique group name
    
    % make group list display (gnameUshow)
    gnameUshow = [num2str((1:numel(gnameU))'), ...
        char(cellfunexpr(gnameU,')')),...
        char(gnameU)];
    
    % choose group
    disp(gnameUshow); display ' '; disp(instruction); % dislay groups and instruction
    i = input(': ','s');
    if strcmp(i,'ALL'); 
        GroupNames = gnameU;
    else
        % confirm entry
        q2 = 0;
        while q2 ==0; % re-enter till correct or quit
            GroupNames = gnameU(cellfun(@str2num,(regexp(i,'\s','split')')));
            display ' '; display 'Chosen groups:'; 
            display(makedisplay(GroupNames,')')); % display chosen groups
            display 'Correct [y=1,n=0]? press [Entre] to quit';
            q2 = input(': '); 
            if q2 ==1; break; end % if correct exit while loop
            if isempty(q2) ==1; return; end % quit program
            % re-enter groups
            disp(gnameUshow); display ' '; disp(instruction); % dislay groups and instruction
            i = input(': ','s'); % ask for input           
        end
    end
end


% GET ALL PATHS UNDER SELECTED GROUPS
display 'getting mwt under selected groups...';
MWTgn = {}; MWTfn = []; pMWTf = [];
for g = 1:numel(GroupNames);
    % find MWT files under group folder 
    pGfT = pGf(regexpcellout(Gfn,['\<',GroupNames{g},'\>'])); % path to groups
    % get MWT folders
    [fn,p] = cellfun(@dircontentmwt,pGfT,'UniformOutput',0);
    fn = celltakeout(fn,'multirow');
    p = celltakeout(p,'multirow');
    group = repmat(GroupNames(g),numel(fn),1);
    MWTgn = [MWTgn;group];
    MWTfn = [MWTfn;fn];
    pMWTf = [pMWTf;p];
end


% CHECK REDENDENCY OF MWT FILES
display 'checking for redunent MWT files';
t = tabulate(MWTfn); 
i = find(cell2mat(t(:,2))>1);
if isempty(i) ==0;
    for x = 1:numel(i)
        % move redendent files to different folder
        k = find(ismember(MWTfn,t(i(x),1)));
        p = pMWTf(k);
        % get exp name
        [~,fn] = cellfun(@fileparts,cellfun(@fileparts,cellfun(@fileparts,p,...
            'UniformOutput',0),'UniformOutput',0),'UniformOutput',0);
        % get exp tracker name
        a = regexpcellout(fn,'[A-Z]','match');
        exptracker = a(:,1);
        % get mwt file names
        f = celltakeout(cellfun(@dircontentext,p,cellfunexpr(p,'*.set'),'UniformOutput',0),'multirow');
        [RCpart] = parseRCname3(f); % parse MWT file names
        trackermwt = RCpart(:,6); % get tracker code
        correct = k(strcmp(trackermwt,exptracker));
        repeat = k(~strcmp(trackermwt,exptracker));
        % if a match is found
        pRepeatFiles = [fileparts(pData),'/MWT_RepeatFiles'];
        if isempty(correct)==0
            % leave the match and move the rest to redundent folder
            p = pMWTf(repeat); % % find files with missing MWT files
            a = cellfun(@strrep,p,cellfunexpr(p,pData),...
                cellfunexpr(p,pRepeatFiles),...
                'UniformOutput',0); % replace pData path with pBadFiles paths
            makemisspath(cellfun(@fileparts,a,'UniformOutput',0)); % make folders
            cellfun(@movefile,p,a); % move files
            str = 'moved [%d] repeat MWT files out of Analysis folder';
            display(sprintf(str,numel(a)));
        else
            error 'tracker name in mwt file name vs exp names are inconsistent';
        end
    end
    % update MWTfn and path list
    j = pMWTf(cellfun(@isdir,pMWTf)); % get valid directory
    pMWTf = pMWTf(j);
    MWTfn = MWTfn(j);
    MWTgn = MWTgn(j);
end


% CHOOSE ONLY CONTROLS WITHIN THE SAME EXP GROUP
if strcmp(OPTION.SAMPLING,'Within Exp') && numel(GroupNames)>1;
    display 'Choose only controls ran with experimental groups';
    % get only paths to none-control group
    p = pMWTf(~strcmp(MWTgn,GroupNames{1}));
    % get unique experiment paths
    a = unique(cellfun(@fileparts,cellfun(@fileparts,p,...
            'UniformOutput',0),'UniformOutput',0));
    % look for control group within experiment paths
    pexp = cellfun(@strcat,a,cellfunexpr(a,['/',GroupNames{1}]),'UniformOutput',0);
    pexp = pexp(celltakeout(cellfun(@isdir,pexp,'UniformOutput',0),'logical'));
    % get control group paths within exp group paths
    [A] = MWTDataBaseMaster(pexp,'FindAllMWT');
    pC = A.pMWTf; Cfn = A.MWTfn;
    % get exp groups index
    i = ~strcmp(MWTgn,GroupNames{1});    
    pMWTf = [pC;pMWTf(i)]; % add control groups to the front
    MWTfn = [Cfn;MWTfn(i)];
    MWTgn = [repmat(GroupNames(1),size(Cfn));MWTgn(i)];
end


%% [CODING] STRUCT MWT BY GROUP (MWTfG) 
% MWTfG = [];
% gname = unique(MWTgn);
% for g = 1:numel(gname);
%     i = strcmp(MWTgn,gname{g});
%     MWTfG.(gname{g}) = [MWTfn(i),pMWTf(i)];
%     % reporting
%     display(sprintf('Group[%s]= %d plates',gname{g},sum(i)));
% end
% make MWTindex 
[MWTindex] = makeMWTindex(pMWTf);



% 









