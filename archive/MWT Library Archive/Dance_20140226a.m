function [varargout] = Dance(varargin)
%% INSTRUCTION
% modified from Dance to suit Flame

%% PROGRAM SETTING

% choice = {'Rose';'DataTest';'Flame'};
% programpathoption = 'Rose';
programpathoption = 'MWTCoding';
% programpathoption = 'DataTest';
% programpathoption = 'Flame';
zip = 'off'; 
CheckStatus = 'NoCheck'; %'Check'; 
%User = 'All'; %User = 'Conny';

pathMaster(programpathoption)

%% STEP1: PROGRAM DEFAULT PATHS 
switch coding
    case 'Rose'
        pProgram = '/Users/connylinlin/Documents/Programming/MATLAB/MATLAB MWT Projects/MWT009_DanceReview';
    case 'Flame'
        % add program path (Mac only)
        pProgram = cd;

end

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





%% OTHER PATHS
% Get experiment home folders
switch coding
    case 'DataTest'
        p = fileparts(pProgram);
        pData = [p,'/DataTest'];
        pSave = '/Users/connylinlin/Documents/Lab/Lab Project & Data/Lab Data Matlab';
    case 'Rose'
        pData = '/Volumes/Rose/MWT_Analysis_20131020';
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
if strcmp(CheckStatus,'Check') ==1

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


    % CHECK AND TRANSFER BAD GROUP NAMES TO BAD NAME FOLDER
        gnameU = unique(Gfn);
        n = 1; k = [];
        for g = 10:10:numel(gnameU)
            if g+10 > numel(gnameU)
                makedisplay(gnameU(n:numel(gnameU),1))

            else
                makedisplay(gnameU(n:g,1))
            end
            n = g+1;
            display('select problem group name, press [Enter] if all correct')
            i = input(': ','s');
            if isempty(i) ==0
                k = [k,str2num(i)+g-10];
            end
        end

    % display problem folder names
    if isempty(k) ==0
        display ' ';
        display 'Problem group folder names:';
        display(gnameU(k));

        % find problem folder path
        i = ismember(Gfn, gnameU(k));
        p = pGf(i);
        fn = Gfn(i);
        
%         % move to grouping folder
%         % find experiment folder
%         [p1,~] =  cellfun(@fileparts,p,'UniformOutput',0);
%         [~,f1] =  cellfun(@fileparts,p1,'UniformOutput',0);
%         pd = [fileparts(pData),'/MWT_BadGroupName'];
%         if exist(pd,'dir') ~=7
%             mkdir(pd);
%         end
%         for x = 1:numel(p1)
%             [p,fn] = fileparts(p1{x});
%             copyfile(p1{x},[pd,'/',fn]);
%         end
        error 'Bad group names found, correct and run again';
        disp(unique(fn));
    end
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
            cellfun(@mkdir,p(i));


            % find mwt folders
            [fnmwt,pmwt] = cellfun(@dircontent,pg,cellfunexpr(pg,'Option'),...
                cellfunexpr(pg,'MWT'), 'UniformOutput',0);
            pmwt = celltakeout(pmwt); fnmwt = celltakeout(fmwt);
            % zip MWT files
            for mwt = 1:numel(pmwt)
                [f,p] = dircontent(pmwt{mwt});
                p = celltakeout(p); f = celltakeout(f);
                i = regexpcellout(f,'(.dat)|(.summary)|(.png)|(.set)|(.blobs)');
                k = regexpcellout(f,...
                    '(evan.dat)|(drunkposture.dat)|(shanespark.dat)|(swanlake.dat)|(tapN_30.dat)');
                i(k) = false;
                zipfilename = strrep(pmwt{mwt},pData,zipdir);
                filelist = p(i);
                display(sprintf('zipping [%s]...',fnmwt{mwt}));
                zip(zipfilename,filelist);
            end


        end
    case 'off'
end



%% STEP3A: USER INPUT - OPTIONS
display ' ';
display 'Select option...';
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
% switch option
%     case 'ShaneSpark'; fnvalidate = {'*.trv';'*shanespark.dat'}; 
%     case 'DrunkPosture'; fnvalidate = {'*drunkposture.dat'};
%     case 'LadyGaGa'; fnvalidate = {'*evan.dat';'*.sprevs'};
% end



%% SEARCH DATABASE

[MWTfG] = MWTDataBaseMasterSearch(pData);



%% STEP4B: USER INPUT-TIME INTERVALS
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



%% STEP4C: CREATE OUTPUT FOLDER
display ' ';
display 'Name your analysis output folder';
a = clock;
time = [num2str(a(4)),num2str(a(5))];
name = [input(': ','s'),'_',option,'_',datestr(now,'yyyymmdd'),time];
mkdir(pSave,name);
pSaveA = [pSave,'/',name];




%% STEP5: CHOR 
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1); pMWTf = pMWTfT; MWTfn = MWTfnT;
[fnvalidate] = chormaster_20140225(pMWTf,pProgram,chorcode);





%% STEP6: ANALYSIS SWITCH BOARD
display ' '; display 'Importing data generated by Choreography...';
switch option
    case 'ShaneSpark'
        Dance_ShaneSpark_20140220(MWTfG,fnvalidate,pSaveA);
    
    case 'DrunkPosture';
        Dance_DrunkPosture_20140225(MWTfG,fnvalidate,pSaveA,TimeInputs);

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




























