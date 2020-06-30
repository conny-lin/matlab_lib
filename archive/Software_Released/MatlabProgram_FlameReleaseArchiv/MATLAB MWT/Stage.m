function [O] = Stage(path,ID)
%% INSTRUCTION
% drag in MWT program folder to start

%% STEP1: CLEAN UP
clearvars -except option path pathFun ID;
%% STEP1: PATHS [Need flexibility] 
a = regexp(userpath,':','split'); cd(a{:,1}); PathCommonList; clearvars a;
pFunMWT = '/Users/connylinlin/Documents/MATLAB/MATLAB MWT'; 
addpath(genpath(pFunMWT));
pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
pRosePick = '/Volumes/Rose/MWT_Analysis_20130811';
pRose = '/Volumes/Rose/MWT_Analysis_20131020_Liquid';
pSet = '/Users/connylinlin/Documents/MATLAB/MATLAB MWT/MatSetfiles';
pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
pSave = '/Users/connylinlin/Documents/PhD MWT Data Analysis';
pIronMan = '/Volumes/IRONMAN';

%% STEP1A: STAGE SPECIFIC PATHS
P.Setting = [pFunMWT '/' 'MatSetfiles'];
O = [];
Home = path;
%pFun = pathFun;


%% CREATE ANALYSIS LIST
AnaList = {'GetvalidatedExppathsNname';'autoGroupAllbyGC';'ZipBackupExpfolder';...
    'SameMWThasSameRunName';'MoveMWTbacktoExpf';'ShaneSparkChorAfterADate';...
    'CheckMWTnames';'FixNestedMWTf';'MoveUnziped2AnalysisFolder';...
    'UnzipMWTfolders';'DiffMWThasDiffRunName';'AddCorrectRuname2expfolder';...
    'Dance';'CreateMWTPortal';'SwitchName';'SameGroupFolderSameGroupCode';...
    'ShaneSpark';'ShaneSparkMulti';'UngroupFromRCf';'PutRawBacktoExpter';...
    'SavePath4Later';'ExpterAdd';'WhoHasThatName';'ExpterFolders';...
    'ZipAllFiles';'ZipExptoRawData';'AnkieOriginalFormatReorg';...
    'Movezip2Raw';'ShaneSparkAfterADate';'GroupName';'Terrisa';...
    'NameGroups';'SearchDataBase';'SynExpnameWRuncon';...
    'FindNCopyMissingMWTFiles';'MoveMwtZip2DateFolder';...
    'Savegroupnameasdatstring'; 'MakeMWTExpDataBase';...
    'AnalysisDrunkposterdotdat';'Movefiles2MWTlabAnalysis';...
    'LadyGaGaSelect';'ShaneSpark_Std20mM';'habrate2ctrl'; 'BackUpRawData';...
    'ShaneSpark_Std2ctrl_norm2initial'}; 

%% INTERPRET INPUTS 
if isnumeric(ID)==1;
    % need coding
elseif isempty(ID)==1; return
elseif isempty(ID)==0 && ischar(ID)==1;
    f = regexp(AnaList,ID,'match'); % match it with AnaList
    match = cell2mat(celltakeout(f,'singlerow'));
    if size(match,1)==1;
        board = match;
    else
        display 'multiple matches found for ID input, abort...';
        [board] = selectanalysis(AnaList);
    end
else
end

%% SELECT ANALYSIS
function [board] = selectanalysis(AnaList)
    select = sortrows(AnaList);
    % create display list
    [b1] = cellfunexpr(AnaList,'['); [b2] = cellfunexpr(AnaList,']');
    num = cellstr(num2str((1:numel(AnaList))'));
    display(char(cellfun(@strcat,b1,num,b2,select,'UniformOutput',0)));
    % ask for analysis id
    display ' '; selectinput = input('Select analysis (press enter to abort): ');
    if isempty(selectinput)==1; return 
    end
    board = select{selectinput};
end

%% CLASS: SWITCH BOARD
%% CLASS: CONSTRUCT STANDARDIZE DATABASE
switch board
    case 'CreateMWTPortal'
        CreateMWTPortal(path);
    case 'MakeExpterFolders'
        %% create expter folder
        pPF = path;
        createexpterfolders(pFun,pPF);
    case 'Find&CopyMWTfiles'
        Home = path;
        Target = input('copy and paste target path: ','s');
        if isdir(Target)==1;
            findmissingMWTfilesNCopy(Home,Target);
        else
            return
        end    
    case 'MakeMWTExpDataBase'
        HomePath = path;
        pSet = P.Setting;
        makeMWTExpDataBase(HomePath,pSet);
        display 'MWTExpDataBase updated.'      
    case 'Find&CopyMWTfiles2'
        [S,T,MWTfnWanted] = findmwtfiles(Source,Target);
        O.S = S; O.T = T; O.MWTfnWanted = MWTfnWanted;
    case 'SetFileSummary';
        setfilesum;
    case 'GroupMWTruns';
    case 'BuildExpDescription'
        buildexpdatabase;
        
    otherwise
end
%% CLASS: STANDARD PROCEDURES
switch board
    case 'BackUpRawData'
        %% BACK UP MWT RAW DATA FROM FLAME AND ROSE TO BLACK PEARL
        pBP = '/Volumes/BlackPearl/MWT_Data_Raw_BackUp';
        % look in both pRosePick, pRose, and pFlame
        [~,~,fnS,pS] = dircontent(pRose);
        [~,~,fnB,pB] = dircontent(pBP);
        % i = not in back up drive
        [iBk,j] = setdiff(fnS,fnB);

        % compare expdate
        % find date of the experiment that's not in backup
        Expdate = celltakeout(regexp(iBk,'^\d{8}','match'),'singlerow'); 
        
        %% check date in back up drive
        for x = 1:numel(Expdate)
            
            % find MWT files in sources
            % find group folder names
            [~,p] = dircontent(pS{j(x)});
            % find MWT files in group files
            a = [];
            for y = 1:numel(p)
                [fmwt,pmwt] = dircontentmwt(p{y});
                a = [a;fmwt];
            end
            MWTfnS = a;
            
            
            % find path to folder with the same date in back up
            pT = pB(celltakeout(regexp(fnB,Expdate{x}),'logical'));
            
            % find group folder names
            [~,p] = dircontent(pT{1});
            
            % find MWT files in group files
            a = [];
            for y = 1:numel(p)
                [fmwt,~] = dircontentmwt(p{y});
                a = [a;fmwt];
            end
            MWTfnB = a;
            
            % compare the MWT file differences
            [m,n] = setdiff(MWTfnS,MWTfnB);
            
            % if different, back up, if not, don't
            if isempty(m) ==1;
            else
                str = 'backing up %s';
                display(sprintf(str,FnS{j(x)}));
                mkdir(pBP,fnS{j(x)})
                copyfile(pS{j(x)},[pBP,'/',fnS{j(x)}])
 
            end
                
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        % if exp date the same but whole name different, check MWT content
        % back up only MWT files, not analysis files

        
        
    otherwise
end
%% CLASS: DEVELOPER TOOLS
switch board
    case 'ExpterAdd'
        %% update experimenter info
        pFunD = P.FunD;
        pPF = P.Expter;
        expter_add(pFunD,pFun,pPF);
    otherwise
end
%% CLASS: CORRECT MISTAKES
switch board
    case 'SynExpnameWRuncon'
        Home = path;
        synexpnameWruncond(Home);
    case 'AnkieOriginalFormatReorg'
        AnkieOriginalFormatReorg(path);
    case 'AddCorrectRuname2expfolder'
        addcorruname2expfolder(path);
    case 'GroupCodeSameInSameGroupCodeFolder'
        [pExpf,MWTsum] = MWTrunameMaster(path,'groupcode');
        O.pExpf = pExpf;
        O.MWTsum = MWTsum;
    case 'NestedMWTfMoveUp'
        Home = path;
        option = input('[keep] or [delete] nested home folders?','s');
        fixmwtnested(Home,option);
    case 'MWTfsnDiffMWThasDiffName'
        % different MWt should have different name
        [pExpf,MWTsum] = MWTrunameMaster(path,'duplicate');
        O.pExpf = pExpf;
        O.MWTsum = MWTsum;
    case 'MWTfsnSameMWThasSameName'
        [pExpf,MWTsum] = MWTrunameMaster(path,'synchronize');
        O.pExpf = pExpf;
        O.MWTsum = MWTsum;
    case 'SwitchName';
        %% change specific wrong MWTname
        [pExpf,MWTsum] = MWTrunameMaster(path,'switch');
        O.pExpf = pExpf;
        O.MWTsum = MWTsum;        
    case 'FixRunCondExpfNSetFiles'
        checkruncondexpnsetfile;
    otherwise
end
%% CLASS: GET INFORMATION
switch board
   case 'GetExpNname'
    % further bulid on get mwt path and validate, find pExp paths
    Home = path;
    i = input('Would you like to display research result (y=1,n=0): ');
    if i ==1;
        DisplayOptoin = 'show';
    elseif i ==0;
        DisplayOptoin = 'noshow';
    end        
    [pExpV,Expfn,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = ...
    getMWTpathsNname(Home,DisplayOptoin);
    O.pExpV = pExpV;
    O.Expfn = Expfn;
    O.pGp = pGp;
    O.pMWTf = pMWTf;
    O.MWTfn = MWTfn;
    O.MWTfsn = MWTfsn;
    O.Gpn = Gpn;
   case 'WhoHasThatName'
        Home = path;
        expr = input('Enter the variable you are searching for\n: ','s');
        [~,~,~,MWTsum,~] = getMWTrunamefromHomepath(Home);
        [exp,mwt,mwtfilename] = whoshasthatname(MWTsum,expr);
        O.exp = exp;
        O.mwt = mwt;
        O.mwtfilename = mwtfilename;       
   otherwise
end
%% CLASS: MISC TOOLS
switch board
    case 'SaveGroupnameAsdatstring'
        pExp = path;
        savegroupnameasdatstring(pExp);
    case 'UnzipMWTfolders'
        %% unzip all MWT files
        % p can be from any folders, the program will automatically search
        % through p directory and identify zipped MWT folders
        [pExpf,pMWTf] = unzipMWT(path);
        O.pExpf = pExpf;
        O.pMWTf = pMWTf;               
    case 'ZipBackupExpfolder'
        [pExpf,pMWTf,MWTfn] = getunzipMWT(path);
        zipExpbackup(pExpf); % zip a pExp as back up
        O.pExpf = pExpf;
        O.pMWTf = pMWTf;
        O.MWTfn = MWTfn;
    case 'ZipAllFiles'
        %% zip all files under a folder defined by pExp
         zipall(path);
    case 'ZipExptoRawData'
        %% move zip out 
        pExp = path;
        Zip2Raw(pExp,pFun,pRaw) 
    case 'CheckMWTnames'
        % check and correct MWT run names, 
        % p can be from any folder containing MWT files in different layers
        if numel(path)==1 && isdir(path{1})==1;
                [pExpf,MWTsum] = MWTrunameMaster(path,'tested');
              O.pExpf = pExpf;
            O.MWTsum = MWTsum;
        elseif numel(path)>1 && iscell(path);
            [~,targetfn] = cellfun(@fileparts,path,'UniformOutput',0);
            for x = 1:numel(path)
                Home = path{x};
                if isdir(Home)==1;
                    str =  'Checking names for %s';
                    display(sprintf(str,targetfn{x}));
                    [pExpf,MWTsum] = MWTrunameMaster(Home,'tested');
                    O.pExpf.(['E',targetfn{x}]) = pExpf;
                    O.MWTsum.(['E',targetfn{x}]) = MWTsum;
                end
            end
        end        
    case 'Movezip2Raw'
         movezip2Raw(path,P.Raw);
    case 'Movefiles2MWTlabAnalysis'
        moveMWTlabAnalysis(pExpfT);
    case 'MoveMwtZip2DateFolder'
        putmwtzipfolderunderadatefolder(path);
    case 'MoveUnziped2AnalysisFolder'  
        moveRaw2Analysis(path);
    case 'MoveMWTbacktoExpf'
        moveMWTbacktoExpf(path);
    case 'MoveRawBacktoExpter'
        % put Raw file back to expter files
        pPF = P.Expter;
        pRaw = P.Raw;
        pFunD = P.Fun;
        putrawb2expterf(pRaw,pPF,pFunD);
    case 'GroupByGroupCondition';
        %% group folders by group code found in run name
        pH = path;
        groupMWT2gc(pH);
    case 'UngroupFromRunConditionfolder'
        %% pull MWT folders out of RC folders
        pBet = path;
        ungroupRC(pBet,pFunD);
        display('ungroup done');
    case 'SavePath4Later'
        %% save paths for later
        pathFun(strcat(pFunD,'/','MatSetfiles'));
        save('paths.mat','p*');
    otherwise
end
%% CLASS: NEW EXPERIMENT SET UP
switch board
    case 'Terrisa'
        % [Coding] Standardize Data preparation
        Terrisa(pExp)
    case 'SearchDataBase'
        Home = path;
        [MWTDatabase,A] = databasesearch(Home);
        O.MWTDatabase = MWTDatabase; O.Result = A;
    case 'NameGroups'
        Home = path; pSet = P.Setting;
        [pExpList,~,~,~,~,~,~] = getMWTpathsNname(Home,'noshow');
        for x = 1:size(pExpList,1); pExp = pExpList{x};
        [Groups] = GroupNameMaster(pExp,pSet,'groupnameEnter');
        end
    case 'GroupName'
        % name groups
        pSet = P.Setting;
        % if targetpath is home to
        [pExpList,Expfn,~,~,~,~,MWTfsn] = getMWTpathsNname(Home,'noshow');
        for x = 1:size(pExpList,1);
            pExp = pExpList{x};
            [Groups] = GroupNameMaster(pExp,pSet,'groupnameEnter');
            %[GAA] = GroupNameMaster(pExp,pSet,'GraphGroupSequence');
        end
    case 'GroupMWTruns'
        pExp = cd;
        [MWTfn,pMWTf] = dircontentmwt(pExp);    
        [MWTfsn,MWTsum] = getMWTruname(pMWTf,MWTfn);    
        [MWTgcode] = getMWTgcode3(MWTfsn);  
        Groups = unique(MWTgcode); 
        for g = 1:size(Groups,1); mkdir(pExp,Groups{g,1}); end
        for g = 1:size(Groups,1)
        i = logical(celltakeout(regexp(MWTgcode,Groups{g,1}),'singlenumber'));
        path = pMWTf(i);
            for p = 1:numel(path);
                movefile(path{p},[pExp,'/',Groups{g,1}]);
            end
        end
    otherwise
end
%% CLASS: ANALYSIS
switch board
    case 'ShaneSparkIndividual'
        ShaneSparkIndividuals(pExpfD);
    case 'ShaneSparkCombine'
        trvGroup
    case 'LadyGaGaCombine'
        LadyGaGaGraphCombine
    case 'DrunkPosture'
        drunkpostureGroup
    case 'LadyGaGaTap'        
        LadyGaGassr(pExpfT);
    case 'LadyGaGaSelect'
        LadyGaGa_SpecificCondition;
    case 'ShaneSpark'
        % standard habituation curve anaylysis
        Home = path;
        pSet = P.Setting;
        [pExpV,~,~,~,~,~,~] = getMWTpathsNname(Home,'noshow');
        ShaneSpark(pExpV,pSet);
    case 'ShaneSparkAfterADate'
        Home = path;
         pSet = P.Setting;
        [pExptarget,Expntarget] = getExpntargetAfteraDate(Home);
        O.Expntarget = Expntarget;
        ShaneSpark(pExptarget,pSet);
    case 'Dance'
        % evaluating Dance
        pFun = pathFun;
        [O] = Dance(path,pFun);
    case 'ShaneSparkChorAfterADate'
        % run ShaneSpark chore on after a specified date
        Home = path;
        ShaneSparkChorAfterADate(Home);
    case 'ShaneSparkMulti'
        %% repeat ShaneSpark for exp folder contains under p
        pRaw = path;
        addpath(pFun);
        [~,~,~,pExpf] = dircontent(pRaw);
        [~,pAnalyzed] = dircontentext(pRaw,'*ShaneSpark');
        pA = setdiff(pExpf,pAnalyzed);
        pFunC(1:size(pA,1),1) = {pFun};
        Aname(1:size(pA,1),1) = {'ShaneSpark'};
        cellfun(@Dance,pA,pFunC,Aname);
    otherwise
end
%% CLASS: GRAPHS PLUG INS
switch board
    case 'ShaneSpark_Std2ctrl';
        %% OPTOIN: STANDARDIZE RAW DATA TO 0mM
        %% LOAD FILES
        cd(path);
        load('matlab.mat','Graph','MWTfnImport','MWTfG');
        %% get parameters
        M = fieldnames(Graph.Y); % get measure names
        
        %% define control
        % get seqence of group names
        gnameL = fieldnames(MWTfG);
        
        % define control group names
        a = num2str((1:numel(gnameL))');
        [b] = char(cellfunexpr(gnameL,')'));
        c = char(gnameL);
        show = [a,b,c];
        disp(show);
        k = input('Choose control group: ');
        name = ['\<',gnameL{k},'\>'];
        i = celltakeout(regexp(gnameL,name),'logical');
        ctrlN = gnameL(i==1); ictrl = find(i==1);

        %% define Exp group name
        %i = celltakeout(regexp(gnameL,'_'),'singlenumber');
        expN = gnameL(i==0);
        
        %% get raw data for control group
        MWTfn = MWTfG.(ctrlN{1})(:,1); % get MWT filenames from grouped index
        [~,i,~] = intersect(MWTfnImport(:,1),MWTfn); % get index to exp files
        A = MWTfnImport(i,1:2);
        MWTfn = A(:,1);
        B = []; % reset B
        for p = 1:size(MWTfn,1);
            B.X.TapTime(:,p) = A{p,2}(:,1); % get Tap time
            B.N.NoResponse(:,p) = A{p,2}(:,3); 
            B.N.Reversed(:,p) = A{p,2}(:,4); 
            B.N.TotalN(:,p) = B.N.Reversed(:,p)+B.N.NoResponse(:,p);
            B.Y.RevFreq(:,p) = B.N.Reversed(:,p)./B.N.TotalN(:,p);
            B.Y.RevDist(:,p) = A{p,2}(:,5); 
            B.Y.RevDistStd(:,p) = B.Y.RevDist(:,p)/B.Y.RevDist(1,p);
            B.Y.RevFreqStd(:,p) = B.Y.RevFreq(:,p)/B.Y.RevFreq(1,p); % freqStd
        end
        D.(ctrlN{1}) = B;
        

        %% get raw data from experimental groups
        for g = 1:numel(expN) 
            % get index to exp files
            MWTfn = MWTfG.(expN{g})(:,1); % get MWT filenames from grouped index
            [~,iexp,~] = intersect(MWTfnImport(:,1),MWTfn); % get index to exp files
            A = MWTfnImport(iexp,1:2);

        % check if file number the same
        if size(MWTfG.(expN{g}),1) == size(A,1)
            % record sample size of exp
            N = size(MWTfG.(expN{g}),1);
            % report # of exp MWT files
            str = 'N of Exp group [%s] = %d';
            display(sprintf(str,expN{g},size(A,1)));
        else error 'something wrong with experiment file number'; 
        end

        % %% get raw data for exp groups
        B = []; % reset B
        for p = 1:size(MWTfn,1);
            B.X.TapTime(:,p) = A{p,2}(:,1); % get Tap time
            B.N.NoResponse(:,p) = A{p,2}(:,3); 
            B.N.Reversed(:,p) = A{p,2}(:,4); 
            B.N.TotalN(:,p) = B.N.Reversed(:,p)+B.N.NoResponse(:,p);
            B.Y.RevFreq(:,p) = B.N.Reversed(:,p)./B.N.TotalN(:,p);
            B.Y.RevDist(:,p) = A{p,2}(:,5); 
            B.Y.RevDistStd(:,p) = B.Y.RevDist(:,p)/B.Y.RevDist(1,p);
            B.Y.RevFreqStd(:,p) = B.Y.RevFreq(:,p)/B.Y.RevFreq(1,p); % freqStd
        end
        D.(expN{g}) = B;
        end

        %% repeat cal for each measure
        for m = 1:numel(M);  
            
            % get control mean
            Ctrl = Graph.Y.(M{m})(:,ictrl); 
            % get control errorbar
            MWTfn = MWTfG.(ctrlN{1})(:,1); % get MWT filenames from grouped index
            [~,i,~] = intersect(MWTfnImport(:,1),MWTfn); % get index to exp files
            N = numel(i);
            a = (D.(ctrlN{1}).Y.(M{m}))./repmat(Ctrl,1,N)*100;
            CtrlE = nanstd(a')'/sqrt(N);
            
                       
            %% get raw data for exp groups    
            X = []; Y = []; E = [];
            for g = 1:numel(expN)   
                N = size(MWTfG.(expN{g}),1);
                % standardize to control
                a = (D.(expN{g}).Y.(M{m}))./repmat(Ctrl,1,N)*100; % divided by control mean
                Y(:,g) = nanmean(a,2); % get mean of exp group
                E(:,g) = nanstd(a')'/sqrt(N); % get SE
                X(:,g) = (1:1:size(a,1))'; % get x axis
            end
            
            Graph.Std.(M{m}).Y = Y;
            Graph.Std.(M{m}).X = X;
            Graph.Std.(M{m}).E = E;

            %% graphing
            % Create figure
            figure1 = figure('Color',[1 1 1]);
            axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Calibri');
            hold(axes1,'all');

            % graph control          
            x = (1:1:30)';
            y = repmat(100,1,30);
            errorbar(x,y,CtrlE,'Parent',axes1,'LineWidth',3,...
                    'DisplayName',ctrlN{1},'Color',[0 0 0],...
                    'MarkerSize',26,'Marker','.'); 

            % create errorbar
            errorbar1 = errorbar(X,Y,E);       
            gnshow = regexprep(expN,'_',' ');  

            % preset color codes
            color(1,:) = [0.30 0.50 0.92];
            color(2,:) = [0.168 0.505 0.337];
            color(3,:) = [0.847 0.16 0];
            cs = size(color,1);
             
            % new code 20131031
            if numel(expN) <=cs
                for g = 1:numel(expN);
                    set(errorbar1(g),'DisplayName',gnshow{g},...
                            'LineWidth',2,'Color',color(g,1:3),...
                            'MarkerSize',26,'Marker','.'); 
                end
            elseif numel(expN) >cs
                for g = 1:cs;
                    set(errorbar1(g),'DisplayName',gnshow{g},...
                            'LineWidth',2,'Color',color(g,1:3),...
                            'MarkerSize',26,'Marker','.'); 
                end
                for g = cs+1:numel(expN);
                    set(errorbar1(g),'DisplayName',gnshow{g},...
                            'LineWidth',2,...
                            'MarkerSize',26,'Marker','.'); 
                end  
            end
            
            

            % Create legend
            legend1 = legend(axes1,'show');
            set(legend1,'EdgeColor',[1 1 1],'Location','NorthEastOutside',...
            'YColor',[1 1 1],'XColor',[1 1 1],'FontSize',14);  

            % Create xlabel
            xlabel('Stim','FontSize',16,'FontName','Calibri');

            % Create ylabel
            ylabel([M{m},' (% Control)'],'FontName','Arial','FontSize',30); 

            % create x and y limit
             xlim(axes1,[0 31.5]);
%             if m == (1||4);     
%                 ylim(axes1,[20 120]);
%             elseif m == (2||3);
%                 ylim(axes1,[50 180]);
%             end

            %% save figure
            figname = [M{m},'_std0mM'];
            savefig(figname,path);
        end
        cd(path); save('matlab.mat');
    case 'ShaneSpark_Std2ctrl_norm2initial'
    %% correlatoin with controls

cd(path); load('matlab.mat');
%
for m = 1:numel(M); 
    
    % get control mean
    Ctrl = Graph.Y.(M{m})(:,ictrl); 
    % get control errorbar
    MWTfn = MWTfG.(ctrlN{1})(:,1); % get MWT filenames from grouped index
    [~,i,~] = intersect(MWTfnImport(:,1),MWTfn); % get index to exp files
    N = numel(i);
    a = (D.(ctrlN{1}).Y.(M{m}))./repmat(Ctrl,1,N)*100;
    CtrlE = nanstd(a')'/sqrt(N);
    
    
    % get group data
    y = Graph.Std.(M{m}).Y;
    % get diff of initial from 100
    ini = y(1,:);
    inis = 100-ini;   
    % minus everyone from that diff
    f = repmat(inis,size(a,1),1);
    Y = y+f;
    % plot again
    X = Graph.Std.(M{m}).X;
    E = Graph.Std.(M{m}).E;

    
    % graphing
    % Create figure
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Calibri');
    hold(axes1,'all');

    % graph control          
    x = (1:1:30)';
    y = repmat(100,1,30);
    errorbar(x,y,CtrlE,'Parent',axes1,'LineWidth',3,...
            'DisplayName',ctrlN{1},'Color',[0 0 0],...
            'MarkerSize',26,'Marker','.'); 

    % create errorbar
    errorbar1 = errorbar(X,Y,E);       
    gnshow = regexprep(expN,'_',' ');  
    [color] = colorcode(3); % preset color codes
    cs = size(color,1);
    if numel(expN) <=cs
        for g = 1:numel(expN);
            set(errorbar1(g),'DisplayName',gnshow{g},...
                    'LineWidth',2,'Color',color(g,1:3),...
                    'MarkerSize',26,'Marker','.'); 
        end
    elseif numel(expN) >cs
        for g = 1:cs;
            set(errorbar1(g),'DisplayName',gnshow{g},...
                    'LineWidth',2,'Color',color(g,1:3),...
                    'MarkerSize',26,'Marker','.'); 
        end
        for g = cs+1:numel(expN);
            set(errorbar1(g),'DisplayName',gnshow{g},...
                    'LineWidth',2,...
                    'MarkerSize',26,'Marker','.'); 
        end  
    end
    
    % legends and axis lables
    legend1 = legend(axes1,'show');
    set(legend1,'EdgeColor',[1 1 1],'Location','NorthEastOutside',...
    'YColor',[1 1 1],'XColor',[1 1 1],'FontSize',14);  
    xlabel('Stim','FontSize',16,'FontName','Calibri');
    ylabel([M{m},' (% Control) normalized initial'],...
        'FontName','Arial','FontSize',20); 
     xlim(axes1,[0 31.5]);


    % save figure
    figname = [M{m},'_std0mM_normalize2ini'];
    savefig(figname,path);
end

    case 'DrunkPosture_Std2ctrl';
         case 'habrate2ctrl'
        %% LOAD FILES
        cd(path);
        load('matlab.mat','Graph','MWTfnImport','MWTfG');
        % get measure names
        M = fieldnames(Graph.Y);

        %% get seqence of group names
        gnameL = fieldnames(MWTfG);

        %% define control
        % get seqence of group names
        gnameL = fieldnames(MWTfG);
        
        % define control group names
        a = num2str((1:numel(gnameL))');
        [b] = char(cellfunexpr(gnameL,')'));
        c = char(gnameL);
        show = [a,b,c];
        disp(show);
        k = input('Choose control group: ');
        name = ['\<',gnameL{k},'\>'];
        i = celltakeout(regexp(gnameL,name),'logical');
        ctrlN = gnameL(i==1); ictrl = find(i==1);

        %% define Exp group name
        expN = gnameL(i==0);

        %% get data for control
        % get index to exp files
        MWTfn = MWTfG.(ctrlN{1})(:,1); % get MWT filenames from grouped index
        [~,i,~] = intersect(MWTfnImport(:,1),MWTfn); % get index to exp files
        A = MWTfnImport(i,1:2);

        % check if file number the same
        if size(MWTfG.(ctrlN{1}),1) == size(A,1)
            % record sample size of exp
            N = size(MWTfG.(ctrlN{1}),1);
            % report # of exp MWT files
            str = 'N of Exp group [%s] = %d';
            display(sprintf(str,ctrlN{1},size(A,1)));
        else
            warning 'something wrong with control file number';
            display 'use imported number instead';
            MWTfn = A(:,1);
        end


        % get raw data for exp groups
        B = []; % reset B
        for p = 1:size(MWTfn,1);
            B.X.TapTime(:,p) = A{p,2}(:,1); % get Tap time
            B.N.NoResponse(:,p) = A{p,2}(:,3); 
            B.N.Reversed(:,p) = A{p,2}(:,4); 
            B.N.TotalN(:,p) = B.N.Reversed(:,p)+B.N.NoResponse(:,p);
            B.Y.RevFreq(:,p) = B.N.Reversed(:,p)./B.N.TotalN(:,p);
            B.Y.RevDist(:,p) = A{p,2}(:,5); 
            B.Y.RevDistStd(:,p) = B.Y.RevDist(:,p)/B.Y.RevDist(1,p);
            B.Y.RevFreqStd(:,p) = B.Y.RevFreq(:,p)/B.Y.RevFreq(1,p); % freqStd
        end
        D.(ctrlN{1}) = B;


        %% get raw data from experimental groups
        for g = 1:numel(expN) 
            % get index to exp files
            MWTfn = MWTfG.(expN{g})(:,1); % get MWT filenames from grouped index
            [~,iexp,~] = intersect(MWTfnImport(:,1),MWTfn); % get index to exp files
            A = MWTfnImport(iexp,1:2);

            % check if file number the same
            if size(MWTfG.(expN{g}),1) == size(A,1)
                % record sample size of exp
                N = size(MWTfG.(expN{g}),1);
                % report # of exp MWT files
                str = 'N of Exp group [%s] = %d';
                display(sprintf(str,expN{g},size(A,1)));
            else error 'something wrong with experiment file number'; 
            end


            % get raw data for exp groups
            B = []; % reset B
            for p = 1:size(MWTfn,1);
                B.X.TapTime(:,p) = A{p,2}(:,1); % get Tap time
                B.N.NoResponse(:,p) = A{p,2}(:,3); 
                B.N.Reversed(:,p) = A{p,2}(:,4); 
                B.N.TotalN(:,p) = B.N.Reversed(:,p)+B.N.NoResponse(:,p);
                B.Y.RevFreq(:,p) = B.N.Reversed(:,p)./B.N.TotalN(:,p);
                B.Y.RevDist(:,p) = A{p,2}(:,5); 
                B.Y.RevDistStd(:,p) = B.Y.RevDist(:,p)/B.Y.RevDist(1,p);
                B.Y.RevFreqStd(:,p) = B.Y.RevFreq(:,p)/B.Y.RevFreq(1,p); % freqStd
            end
            D.(expN{g}) = B;
        end


        %% calculate slop for everyone
        gn = fieldnames(D);
        Slope = [];
        for g = 1:numel(gn)
            for m = 1:numel(M)
                a = D.(gn{g}).Y.(M{m});
                b = a(2:end,:);
                a = a(1:end-1,:);
                Slope.(gn{g}).(M{m}) = b-a;
            end
        end


        %% stad to control
        %% get seqence of group names
        for m = 1:numel(M)
            ctrlD = Slope.(ctrlN{1}).(M{m});
            ctrlM = nanmean(ctrlD,2); % get control mean
            N = size(ctrlD,2);
            c = repmat(ctrlM,1,N);
            a = (Slope.(ctrlN{1}).(M{m}))./c*100;
            CtrlE = nanstd(a')'/sqrt(N);

            X = []; Y = []; E = [];
            for g = 1:numel(expN)
                N = size(Slope.(expN{g}).(M{m}),2);
                c = repmat(ctrlM,1,N);
                a = (Slope.(expN{g}).(M{m}))./c*100;
                Y(:,g) = nanmean(a,2);
                E(:,g) = nanstd(a')'/sqrt(N); % get SE
                X(:,g) = (1:1:size(a,1))'; % get x axis
            end

            % Create figure
            figure1 = figure('Color',[1 1 1]);
            axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Calibri');
            hold(axes1,'all');

            % graph control
            %CtrlE = Graph.Y.(M{m})(:,ictrl);
            x = (1:1:29)';
            y = repmat(100,1,29);
            errorbar(x,y,CtrlE,'Parent',axes1,'LineWidth',3,...
                    'DisplayName',ctrlN{1},'Color',[0.8 0.8 0.8]); 

            %% create zero lines
            y = zeros(1,29);
            plot(x,y,'Parent',axes1,'LineWidth',3,...
                    'DisplayName','Zero','Color',[0.8 0.8 0.9]); 
            % create errorbar
            errorbar1 = errorbar(X,Y,E);       
            gnshow = regexprep(expN,'_',' ');  

            % preset color codes
            color(1,:) = [0,0,0];
            color(2,:) = [0.04 0.14 0.42];
            color(3,:) = [0.847 0.16 0];
            color(4,:) = [0.168 0.505 0.337];

            %% create errorbar lines
            for g = 1:numel(expN)
             set(errorbar1(g),'DisplayName',gnshow{g},...
            'MarkerSize',30,'Marker','.','LineWidth',2.5,'Color',color(g,:));
            end

            %% Create legend
            legend1 = legend(axes1,'show');
            set(legend1,'EdgeColor',[1 1 1],'Location','NorthEastOutside',...
            'YColor',[1 1 1],'XColor',[1 1 1],'FontSize',14);  

            % Create xlabel
            xlabel('Stim','FontSize',16,'FontName','Calibri');

            % Create ylabel
            ylabel([M{m},'slope (% control)'],'FontName','Arial','FontSize',30); 

            % create x and y limit
             xlim(axes1,[0 12.5]);
        %     if m == (1||4);     
              ylim(axes1,[-200 400]);
        %     elseif m == (2||3);
        %         ylim(axes1,[50 180]);
        %     end

            % save figure
            figname = [M{m},'Slope_std0mM'];
            savefigjpeg(figname,path);
           % errorbar(X,Y,E)
            
        end
     

    otherwise
end
end

%% Subfunction

function [p] = definepath4diffcomputers3(p,cd,grad)


%% Now works for grad student only
% Search for [BUG] and [CODE] for development
% graduatestudentlist = {'Conny Lin';'Evan Ardiel'};
% % [suspend] %disp([num2cell((1:numel(graduatestudentlist))') graduatestudentlist]);
% gradindex = not(cellfun(@isempty,regexp(graduatestudentlist,grad))); % get index to grad list
% if sum(gradindex)==0;
%    display 'Not authorized person';
%     return
% end

%% find hard drive name
% find drive for program
pathProgram = cd;
n = regexp(pathProgram,'/Users/','split');
if numel(n) ==1; % if it is an external hard drive
    n = regexp(pathProgram,'/Volumes/','split');
    programInexternal = 1; % record external hard drive
else
    programInexternal = 0;
end
h = regexp(n{2},'/','split'); 
programharddrive = h{1};

% find drive for data
pathData = p;
n = regexp(pathData,'/Users/','split');
if numel(n) ==1; % if it is an external hard drive
    n = regexp(pathData,'/Volumes/','split');
    dataInexternal = 1; % record external hard drive
else
    dataInexternal = 0;
end
h = regexp(n{2},'/','split'); 
dataharddrive = h{1};

%% defining MWT Portal paths
if dataInexternal ==1; % if it is a external hard drive
    pH = ['/Volumes/',dataharddrive];
elseif strcmp(dataharddrive,'connylinlin') ==1; % if it is conny's computer
    pH = '/Users/connylinlin/MatLabTest';
else
    pHt = input('paste the path of MWT Portal folder','s');
    pH = regexprep(pHt,'/MultiWormTrackerPortal');
end
[~,~,~,pf] = dircontent(pH);

% find portal
portal = regexp(pf,'MultiWormTrackerPortal');
if sum(cellfun(@isempty,portal)) ==0;
    error ('no MultiWormTrackerPortal found..');
end
p.Portal = pf{not(cellfun(@isempty,portal))};

%% get the rest
% define paths for data
p.Raw = [p.Portal,'/','MWT_Raw_Data'];
p.Expter = [p.Portal '/' 'MWT_Experimenter_Folders'];

% define paths for programs
p.Fun = pathProgram;
p.Setting = [pathProgram '/' 'MatSetfiles'];
p.FunD = [pathProgram '/' 'SubFun_Developer'];
p.FunG = [pathProgram '/' 'SubFun_General'];
p.FunR = [pathProgram '/' 'SubFun_Released'];


%% prep grad student only folder
% % [BUG] Needs to pre define this for students
% grad = char(regexprep(grad,' ','_'));
% p.Grad = [p.Expter,'/',grad];
% p.GradA = strcat(p.Grad,'/','MWT_AnalysisReport');
% if isdir(p.GradA) ==0;
%     cd(p.Grad);
%     mkdir('MWT_AnalysisReport');
% end
% p.GradRaw = strcat(p.Grad,'/','MWT_NewRawReport');
% if isdir(p.GradRaw) ==0;
%     cd(p.Grad);
%     mkdir('MWT_NewRawReport');
% end
end


function [a,b,c,d] = dircontent(p)
% a = full dir, can be folder or files, b = path to all files, 
% c = only folders, d = paths to only folders
cd(p); % go to directory
a = {}; % create cell array for output
a = dir; % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = []; 
b = {};
c = {};
d = {};
for x = 1:size(a,1); % for all files 
    b(x,1) = {strcat(p,'/',a{x,1})}; % make path for files
    if isdir(b{x,1}) ==1; % if a path is a folder
        c(end+1,1) = a(x,1); % record name in cell array b
        d(end+1,1) = b(x,1); % create paths for folders
    else
    end
end
end

function [color] = colorcode(choice)
switch choice
    case 3
        color(1,:) = [0.30 0.50 0.92];
        color(2,:) = [0.168 0.505 0.337];
        color(3,:) = [0.847 0.16 0];
    otherwise
end
end





