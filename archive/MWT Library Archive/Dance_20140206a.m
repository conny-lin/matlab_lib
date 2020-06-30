function [varargout] = MWT008_Dance_20140206(varargin)
%% INSTRUCTION
% modified from Dance to suit Flame

%% TESTING SWITCH
coding = 'Rose';
% coding = 'DataTest';
%coding = 'Flame';
zip = 'off'; 

%% STEP1: GET PATHS 
restoredefaultpath;

% add program path (Mac only)
pProgram = cd;
p = pProgram;
a = {}; % create cell array for output
a = dir(cd); % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = []; 
for x = 1:size(a,1); % for all files 
    p1 = [p,'/',a{x,1}]; % make path for files
    if isdir(p1) ==1; % if a path is a folder
        addpath(p1);
    end
end

% output
varargout{1} = pProgram;

% Get experiment home folders
switch coding
    case 'DataTest'
        p = fileparts(pProgram);
        pData = [p,'/DataTest'];
        pSave = '/Users/connylinlin/Documents/Lab/Lab Project & Data/Lab Data Matlab';
    case 'Rose'
        pData = '/Volumes/Rose 3/MWT_Analysis_20131020';
        pSave = '/Users/connylinlin/Documents/Lab/Lab Project & Data/Lab Data Matlab';
    case 'Flame'
        display ' ';
        display 'Choose experiment home folder';
        [fn,p] = dircontent(fileparts(p));
        % get rid of .xxx folders
        i = cellfun(@isempty,regexp(fn,'[.]|(AnalysisProgram)'));
        fn = fn(i); p = p(i);
        display(makedisplay(fn));
        display ' ';
        i = input('folder: ');
        pData = p{i};

        % get save folder path
        savefoldername = 'AnalysisResults';
        pSave = [pData,'/',savefoldername ];
        if exist(pSave,'dir') ~=7
            mkdir(pData,savefoldername);
            display 'made analysis folder';
        end
end



%% STEP2: NAMING, FILE ORG, BACK UP
% STEP2A: CHECK EXPERIMENT FOLDER NAMES
[fn,p] = dircontent(pData);

fn1 = fn;
i = ~regexpcellout(fn1,...
    '\<\d{8}[A-Z][_][A-Z]{2}[_]\d{1,}[s]\d{1,}[x]\d{1,}[s]\d{1,}[s]');
while sum(i)~=0
    k = find(i);
    display 'Some experiments were not named correctly';
    display 'rename to this format: 20131008B_SJ_100s30x10s10s';

    for x = 1:numel(k)
        display(sprintf('change [ %s ] to',fn1{k(x)}));
        fn1{k(x)} = input(': ','s');
    end
    i = ~regexpcellout(fn1,...
    '\<\d{8}[A-Z][_][A-Z]{2}[_]\d{1,}[s]\d{1,}[x]\d{1,}[s]\d{1,}[s]');
end


i = find(~strcmp(fn,fn1));
p1 = p;
for x = 1:numel(i)
   fn2 = fn1{i(x)};
   p2 = p1{i(x)};
   newpath = [fileparts(p2),'/',fn2];
   movefile(p2,newpath);
end



% STEP2B: CHECK EXPERIMENT GROUPS
display 'checking if MWT folders are grouped...';
[A] = MWTDataBaseMaster(pData,'GetStdMWTDataBase');
Gfn = A.GfnD; pGf = A.pGfD;
% check if MWT folder is below
i = regexpcellout(Gfn,'\<\d{8}[_]\d{6}\>');
[p,~] = cellfun(@fileparts,pGf,'UniformOutput',0);
[~,fn] = cellfun(@fileparts,p,'UniformOutput',0);
fn = unique(fn(i));
p = unique(p(i));
if isempty(p)==0
   display ' ';
   display(sprintf('[%d] experiments not grouped',numel(fn))); 
   disp(fn);
   error 'please group MWT folders under group folders';
end



% STEP2C: CHECK ZIP BACKUP
switch zip
    case 'on'
        p = fileparts(pProgram);
        filename = 'MWT_ZipBackUp';
        zipdir = [p,'/',filename];
        if exist(zipdir,'dir') ~= 7
            mkdir(p,filename);
        end

        % check dir in zip
        [fnzip,pzip] = dircontent(zipdir);
        [fne,pe] = dircontent(pData);
        % find experiment without backup
        i = ~ismember(fne,fnzip);
        fne = fne(i);
        pe = pe(i);
        if isempty(fne)==0
            display ' ';
            display(sprintf('Backing up [%d] exp folders to [%s]',...
                numel(fne),filename));
            display 'DO NOT stop this process';

            % create group folders
            % find MWT folders
            [fmwt,pmwt] = cellfun(@dircontent,pe,cellfunexpr(pe,'Option'),...
                cellfunexpr(pe,'MWT'),'UniformOutput',0);
            pmwt = celltakeout(pmwt); fmwt = celltakeout(fmwt);

            % find group folders
            [pg,~] = cellfun(@fileparts,pmwt,'UniformOutput',0);
            pg = unique(pg);
            p = strrep(pg,pData,zipdir);
            i = ~cellfun(@exist,p,cellfunexpr(p,'dir'));
            cellfun(@mkdir,p(i))


            % find mwt folders
            [fnmwt,pmwt] = cellfun(@dircontent,pg,cellfunexpr(pg,'Option'),...
                cellfunexpr(pg,'MWT'), 'UniformOutput',0);
            pmwt = celltakeout(pmwt); fnmwt = celltakeout(fmwt);
            % zip MWT files
            for mwt = 1:numel(pmwt)
                [f,p] = dircontent(pmwt{mwt});
                p = celltakeout(p); f = celltakeout(f);
                i = regexpcellout(f,'(.dat)|(.summary)|(.png)|(.set)|(.blobs)');
                k = regexpcellout(f,'(evan.dat)|(drunkposture.dat)|(shanespark.dat)|(swanlake.dat)|(tapN_30.dat)');
                i(k) = false;
                zipfilename = strrep(pmwt{mwt},pData,zipdir);
                filelist = p(i);
                display(sprintf('zipping [%s]...',fnmwt{mwt}));
                zip(zipfilename,filelist);
            end


        end
    case 'off'
end



%% STEP3: INTERPRET INPUT AND DEAL OUTPUT
% HomePath = pData;
O = []; % [CODE] Define output O % temperary assign O = nothing
% STEP2: OPTION INTERPRETATION



% STEP3A: CREATE OPTION LIST 
display ' ';
display 'Select analysis option...';
ID = {'ShaneSpark';'LadyGaGa';'DrunkPosture'};
display(makedisplay(ID))
display ' ';
option = ID{input('option: ')};



% STEP3B: CREATE OPTION NOT NEEDING TIME INPUTS
OptionNoTimeInput = {'ShaneSpark'};
% STEP2C: OPTION SELECTION 
i = celltakeout(regexp(ID,option),'logical');
if sum(i)~=1;
    display 'option entered not found'l
    display 'please select from the following list:';
    [show] = makedisplay(ID,'bracket'); disp(show);
% ask for analysis ID
display 'Enter analysis number,press [ENTER] to abort';
a = input(': ');
if isempty(a) ==1; return; else option = ID{a}; end
end
% STEP2D: TIME INTERVAL
optioni = celltakeout(regexp(OptionNoTimeInput,option),'logical');
if optioni ==0; timeintervalstatus = 'input'; 
else timeintervalstatus = 'noneed'; end
% STEP2E: DEFINE CHOROUTPUTS AND CHOR CODE
chorcode = option;
switch option
    case 'ShaneSpark'; fnvalidate = {'*.trv';'*shanespark.dat'}; 
    case 'DrunkPosture'; fnvalidate = {'*drunkposture.dat'};
    case 'LadyGaGa'; fnvalidate = {'*evan.dat';'*.sprevs'};
end



%% STEP4: USER INPUTS - DEFINE EXP OBJECTIVES
% STEP4A: GET BASIC EXP INFO
display 'Checking if MWTExpDataBase is already loaded';
if exist('pExpfD','var')==0||exist('ExpfnD','var')==0||...
        exist('pMWTfD','var')==0|| exist('MWTfnD','var')==0;
    display 'Loading MWTExpDataBase...';
    [A] = MWTDataBaseMaster(pData,'GetStdMWTDataBase');
    pExpfD = A.pExpfD; ExpfnD = A.ExpfnD; GfnD = A.GfnD;
    pGfD = A.pGfD; pMWTf = A.pMWTf; MWTfn = A.MWTfn;
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
searchclass = 'E';
display 'Enter search term for experiment folder name';


% 
% display 'MWT files [M], Exp files [E], Group name [G] or no search [A]?';
% searchclass = input(': ','s');
switch searchclass
    case 'M' % search for MWT
        display 'option under construction'
    case 'G' % search for group name
        display 'option under construction'
        
    case 'E' % search for Experiment folders
        display 'Enter search term:';
        searchterm = input(': ','s');
        % find matches
        k = regexp(ExpfnD,searchterm,'once');
        searchindex = logical(celltakeout(k,'singlenumber'));
        pExpfS = pExpfD(searchindex);
        ExpfnS = ExpfnD(searchindex);
        disp(ExpfnS);
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
    case 'A'
        pExpfT = pExpfD;
        ExpfnT = ExpfnD;
end  
if isempty(ExpfnT)==1; display 'No target experiments'; return; end



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
    a = celltakeout(regexp(MWTfn,'^(\d{8})','match'),'match');
    expcount = numel(unique(a));
    str = 'Got %d MWT files from %d experiments';
    display(sprintf(str,numel(MWTfn),expcount));
    % create output file
    MWTfG.(gnamechose{g})(:,1:2) = [MWTfn,pMWTf];
end



% STEP4B: USER INPUT-TIME INTERVALS
% works only for the same run conditions
display ' ';
switch timeintervalstatus
    case 'input'
        display 'Enter analysis time periods: ';
        tinput = input('Enter start time, press [Enter] to use MinTracked: ');
        intinput = input('Enter interval, press [Enter] to use default (10s): ');
        tfinput = input('Enter end time, press [Enter] to use MaxTracked: ');
        display 'Enter duration after each time point to analyze';
        % (optional) survey duration after specifoied target time point
        durinput = input('press [Enter] to analyze all time bewteen intervals: '); 
        
        % organize time inputs
        if isempty(tinput) ==1; tinput = NaN; end
        if isempty(intinput) ==1; intinput = NaN; end
        if isempty(durinput) ==1; durinput = NaN; end
        if isempty(tfinput) ==1; tfinput = NaN; end
        TimeInputs = [tinput,intinput,durinput,tfinput];
        
    case 'auto'
        tinput = []; int = []; tf = []; dur = [];
    case 'noneed';
end



% STEP4C: CREATE OUTPUT FOLDER
display ' ';
display 'Name your analysis output folder';
a = clock;
time = [num2str(a(4)),num2str(a(5))];
name = [input(': ','s'),'_',option,'_',datestr(now,'yyyymmdd'),time];
mkdir(pSave,name);
pSaveA = [pSave,'/',name];



%% STEP5: CHOR 
% STEP4B: CHECK IF CHOR HAD BEEN DONE
% display ' '; display 'Checking chor outputs...'
% % prepare pMWTf input for validation
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1); pMWTf = pMWTfT; MWTfn = MWTfnT;
% % check chor ouptputs
% pMWTfC = {}; MWTfnC = {}; 
% for v = 1:size(fnvalidate,1);
%     [valname] = cellfunexpr(pMWTf,fnvalidate{v});
%     [fn,path] = cellfun(@dircontentext,pMWTf,valname,'UniformOutput',0);
%     novalfn = cellfun(@isempty,fn);
%     if sum(novalfn)~=0;
%         pMWTfnoval = pMWTf(novalfn); MWTfnoval = MWTfn(novalfn);
%         pMWTfC = [pMWTfC;pMWTfnoval]; MWTfnC = [MWTfnC;MWTfnoval];
%     end
% end
% pMWTfC = unique(pMWTfC); MWTfnC = unique(MWTfnC);
% % reporting
% if isempty(pMWTfC)==0;
%     str = 'Need to Chore %d MWT files';
%     display(sprintf(str,numel(pMWTfC)));
% else display 'All files have required Chor outputs';
% end
% STEP4C: RUN CHORE
% if isempty(pMWTfC)==0; 
[fnvalidate] = chormaster_20140206(pMWTf,pProgram,chorcode);
% else
%     display 'No Chor needs to be ran.';
% end




%% STEP6: ANALYSIS SWITCH BOARD
display ' '; display 'Importing data generated by Choreography...';
switch option
    case 'ShaneSpark'
        Dance_ShaneSpark_20140206(MWTfG,fnvalidate,pSaveA);
    
    case 'DrunkPosture';
        Dance_DrunkPosture_20140206(MWTfG,fnvalidate,pSaveA,TimeInputs);

    case 'LadyGaGa'
        %% STEP5: IMPORT CHOR OUTPUTS
        % STEP5A: Import and process Chor generated data
        % MWTfevandat
        % note: this take a long time
        display 'Importing evan.dat';
        % evandat legends (%tnNss*b12)
        evandatL = {1,'time';2,'number';3,'goodnumber';4,'speed';5,'speedStd';...
        6,'bias';7,'tap';8,'puff'};
        MWTfevandatL = {1,'MWT filename';2,'Data';3,'mintime';4,'maxtime';...
        5,'mean number tracked';6,'mean good number';7,'mean percent N valid';...
        8,'mean speed';9,'min speed';10,'max speed';11,'mean bias'};
        % import
        MWTfevandat = {}; 
        for p = 1:numel(pMWTf); % for each mwt
        [~,datevanimport] = dircontentext(pMWTf{p},'*evan.dat');  
        MWTfevandat(p,1) = MWTfn(p);
        MWTfevandat(p,2) = {dlmread(datevanimport{1})};
        end
        % summarize
        for x = 1:size(MWTfevandat,1)
        MWTfevandat{x,3} = min(MWTfevandat{x,2}(:,1)); % min time
        MWTfevandat{x,4} = max(MWTfevandat{x,2}(:,1)); % max time
        MWTfevandat{x,5} = mean(MWTfevandat{x,2}(:,2)); % mean number tracked
        MWTfevandat{x,6} = mean(MWTfevandat{x,2}(:,3)); 
        MWTfevandat{x,7} = MWTfevandat{x,6}/MWTfevandat{x,5}*100; 
        MWTfevandat{x,8} = mean(MWTfevandat{x,2}(:,4)); 
        MWTfevandat{x,9} = min(MWTfevandat{x,2}(:,4)); 
        MWTfevandat{x,10} = max(MWTfevandat{x,2}(:,4)); 
        MWTfevandat{x,11} = mean(MWTfevandat{x,2}(:,6)); 
        end
        display 'done.';
        % sprevs
        display 'Importing *.sprevs, this will take a while...';
        % sprevs legends
        MWTfsprevsL = {1,'MWT filename'; 2,'Data';3,'mintime';4,'maxtime';...
        5,'objects tracked';6,'mean reversal';7,'minreversal'; ...
        8,'max reversal'};
        sprevsL = {1,'object ID'; 2,'time'; 3,'reversal'; 4,'trackduration?'};
        % import data
        MWTfsprevs = {};
        for p = 1 : numel(pMWTf); 
        [~,ps] = dircontentext(pMWTf{p},'*.sprevs');
        A = []; for k = 1:size(ps,1); a = dlmread(ps{k}); A = [A;a]; end
        MWTfsprevs(p,1) = MWTfn(p); MWTfsprevs(p,2) = {A};
        end 
        % summarize sprevs
        for x = 1:size(MWTfsprevs,1)
        MWTfsprevs{x,3} = min(MWTfsprevs{x,2}(:,2));
        MWTfsprevs{x,4} = max(MWTfsprevs{x,2}(:,2)); 
        MWTfsprevs{x,5} = numel(unique(MWTfsprevs{x,2}(:,1))); 
        MWTfsprevs{x,6} = mean(MWTfsprevs{x,2}(:,3)); 
        MWTfsprevs{x,7} = min(MWTfsprevs{x,2}(:,3)); 
        MWTfsprevs{x,8} = max(MWTfsprevs{x,2}(:,3)); 
        end
        display 'done';
        % summary Data
        Data.MWTfsprevs = MWTfsprevs;
        Data.MWTfsprevsL= MWTfsprevsL;
        Data.MWTfevandat = MWTfevandat;
        Data.MWTfevandatL = MWTfevandatL;
        Data.evandatL = evandatL;
        Data.sprevsL = sprevsL;
        %% STEP6: DESCRIPTIVE STATS
        % STEP6A: PREPARE TIME POINTS
        % prepare groups
        gnameL = fieldnames(MWTfG);
        % prepare universal timepoints limits
        % find smallest starting time and smallest ending time
        t = max(cell2mat(Data.MWTfsprevs(:,3)));
        t = str2num(num2str(t,'%.0f'));
        MWTfsprevStartTime = t;
        t = min(cell2mat(Data.MWTfsprevs(:,4)));
        t = str2num(num2str(t,'%.0f'));
        MWTfsprevEndTime = t;
        str = 'Earliest time tracked (MinTracked): %0.1f';
        display(sprintf(str,MWTfsprevStartTime));
        str = 'Max time tracked  (MaxTracked): %0.1f';
        display(sprintf(str,MWTfsprevEndTime));
        % processing inputs
        if tinput ==0; ti = MWTfsprevStartTime; 
        elseif isempty(tinput)==1; ti = MWTfsprevStartTime; tinput = 0; 
        elseif tinput>MWTfsprevStartTime; ti=tinput; end
        if isempty(intinput)==1; int = 10; else int = intinput; end
        if isempty(tfinput)==1; tf = MWTfsprevEndTime; else tf = tfinput; end
        if isempty(durinput)==0; duration = 'restricted'; else duration = 'all'; end
        % reporting
        str = 'Starting time: %0.0fs';
        display(sprintf(str,ti));
        switch duration
        case 'all'
        timepoints = [ti:int:tf];
        str = 'Time points: %0.0f ';
        timeN = numel(timepoints);
        display(sprintf(str,timeN));
        case 'restricted'
        % need coding
        end

        % STEP6B: DESCRIPTIVE STATS BY GROUPS
        % summarize group data
        G = [];
        for g = 1:numel(gnameL);
        % get group info
        A = [];
        gname = gnameL{g};    
        pMWTf = MWTfG.(gname)(:,2);
        MWTfn = MWTfG.(gname)(:,1);
        A.MWTfn = MWTfn;
        [~,i,~] = intersect(Data.MWTfsprevs(:,1),MWTfn);
        MWTfsprevs = Data.MWTfsprevs(i,:);
        [~,i,~] = intersect(Data.MWTfevandat(:,1),MWTfn);
        MWTfevandat = Data.MWTfevandat(i,:);

        %% MWTfsprevsum summary
        for p = 1:numel(MWTfn); % for each MWT plate
        A.X(:,p) = timepoints';
        for t = 1:numel(timepoints)-1; % for each stim
            % get data durint time frame 
            k = MWTfsprevs{p,2}(:,2)>timepoints(t) ....
                & MWTfsprevs{p,2}(:,2)<timepoints(t+1);
            %%
            sprevsValid = MWTfsprevs{p,2}(k,:);
            m = MWTfevandat{p,2}(:,1)>timepoints(t) ...
                & MWTfevandat{p,1}(:,1)<timepoints(t+1);
            evandatValid = MWTfevandat{p,2}(m,:);
            %% get N.Min
            if isempty(evandatValid)==1; % if no valid times
                A.N.Minimum(t,p) = 0; 
            else A.N.Minimum(t,p) = min(evandatValid(:,3)); 
            end
            % get N.Max
            if isempty(evandatValid)==1; 
                A.N.Maximum(t,p) = 0; 
            else A.N.Maximum(t,p) = max(evandatValid(:,3)); 
            end
            Nrev = size(sprevsValid(:,2),1);
            A.Y.RevIncidents(t,p) = Nrev;
            A.Y.RevWorm(t,p) = size(unique(sprevsValid(:,1)),1);
            A.Y.RevDist(t,p) = mean(sprevsValid(:,3));
            A.E.RevDist(t,p) = std(sprevsValid(:,3))./sqrt(Nrev);
            A.Y.RevDur(t,p) = mean(sprevsValid(:,4));
            A.E.RevDur(t,p) = std(sprevsValid(:,4))./sqrt(Nrev);
            % calculate total duration reversed
            RevEndTime = sprevsValid(:,2)+sprevsValid(:,4); % time start+time end
            overTimei = RevEndTime(:,1)>timepoints(t+1); % time tracked till after the end of timepoint
            RevEndTime(overTimei,1) = timepoints(t+1);
            RevDur = RevEndTime(:,1)-sprevsValid(:,2);
            A.Y.TotalTimeRev(t,p) = sum(RevDur);
        end % end of loop timepoints
        end % end of loop MWT
        % summarize group data
        Ytype = fieldnames(A.Y);
        B.X(:,g) = mean(A.X,2);
        for y = 1:numel(Ytype)
        Stat = Ytype{y};
        B.Y.(Stat)(:,g) = mean(A.Y.(Stat),2);
        B.E.(Stat)(:,g) = (std(A.Y.(Stat)')')./sqrt(size(A.Y.(Stat),2));
        end
        B.MWTf.(gname) = MWTfn;
        end % end of loop for group
        Graph = B;
        Graph.GroupName = gnameL;
        %% STEP7: GRAPH GROUPED DATA
        MeasureType = fieldnames(Graph.Y);
        for a = 1:numel(MeasureType);
        X = Graph.X(2:end,:);
        Y = Graph.Y.(MeasureType{a});
        E = Graph.E.(MeasureType{a});
        f1 = figure('Visible','on'); 
        hold on;
        errorbar(X,Y,E);
        figname = [(MeasureType{a}),'[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),':',num2str(tf,'%.0f'),']'];
        %saveas(gcf,figname,'fig'); % save as matlab figure 
        savefigjpeg(figname,pSaveA);
        end  
        %% STEP6C: SAVE MATLAB
        cd(pSaveA); save('matlab.mat');
    otherwise
end


%% STEP7: REPORT AND END
display 'Analysis completed';

end




























