%% [OBJECTIVE] CHECK IF EXPERIMENT STANDARD NAME IS IN CORRDANCE WITH RUN CONDITION
%% STEP1: PATHS [Need flexibility] 
clearvars -except option
pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
pRose = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811';
pFun = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs';
pSet = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs/MatSetfiles';
pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
pSave = '/Volumes/Rose/MultiWormTrackerPortal/SummaryAnalysis';
addpath(genpath(pFun));
HomePath = pRose;
O = []; % [CODE] Define output O % temperary assign O = nothing

%% STEP2: CHOOSE OPTOIN
option1 = input('Refresh all summary [REFRESH] or only sum new MWT [NEW]?\n: ','s'); 

%% STEP3: GET MWT
[A] = MWTDataBaseMaster(HomePath,'FindAllMWT');
pMWTfD = A.pMWTfnR; MWTfnD = A.MWTfnR;
%% STEP4: FIND MWT WITHOUT SUM FILE
[a,~] = dircontentext(pSum,'*.mfi');
record = celltakeout(regexp(a,'^(\d{8})[_](\d{6})','match'),'singlerow');
MWTfnNoRecord = setdiff(MWTfnD,record);
str = '[%d] MWTf does not have record files';
display(sprintf(str,numel(MWTfnNoRecord)));
option = 'noshow';
switch option
    case 'noshow'
    case 'show'
        display 'MWTf below does not have record files'; 
        disp(MWTfnNoRecord); 
end
%% STEP5: GET EXP INFO FROM .SET
display 'Making MWT info summary, this will take a while...';  
switch option1;
    case 'NEW';  
        for x = 1:numel(MWTfnNoRecord)
            m = celltakeout(regexp(MWTfnD,MWTfnNoRecord{x}),'logical');
            pMWT = pMWTfD{m}; [~,MWTfn] = fileparts(pMWT);
            [fn,p] = dircontentext(pMWT,'*.set');
            
            % if there is no .set file
            if isempty(p)==1; 
                str = 'MWTf[%s] has no *.set file'; 
                display(sprintf(str,MWTfn));
                expcond = [MWTfn,'[NoSetFile]'];
                expathO = '';   
            
            % if there is .set file
            elseif iscell(p)==1 && numel(p)==1; pset = char(p); 
                
                % interpret .set file
                a = fileread(pset); b = regexp(a,'(FALSE)|(TRUE)','split')';
                
                % get original expath and MWTruname
                c = regexp(b{1},'\s','split')';
                % if path name is NOT found in .set file
                if isempty(c{end})==0 && isempty(c{end-1})==1;
                    display 'problems!';
                    expcond = [MWTfn,'[ProblemSetFile]']; expathO = ''; 
                
                    % if path name is found in .set file
                elseif isempty(c{end})==1 && isempty(c{end-1})==0;
                    MWTrunameO = c{end-1}; 
                    d = regexp(b{1},MWTrunameO,'split');
                    expathO = d{1}; d = regexp(expathO,'\','split');
                    expid1 = d{end-1}; 
                    expid2 = char(regexprep(d{end},'\s',''));
                    
                    % get original run condition
                    c = celltakeout(regexp(b(5),'\s','split')','split');
                    d = c(not(cellfun(@isempty,c)));
                    totalduration = str2num(d{end});
                    c = celltakeout(regexp(b(6),'\s','split')','split');
                    d = c(not(cellfun(@isempty,c)));
                    preplate = str2num(d{1}); ISI = str2num(d{2});
                    tapN = str2num(d{3}); tapVar = str2num(d{4});
                    aftertap = totalduration-((ISI*tapN)+preplate); 
                    
                    % make file name
                    expcond = [MWTfn,'[',num2str(totalduration),'s(',num2str(preplate),...
                    's',num2str(tapN),'x',num2str(ISI),'s',num2str(aftertap),'s)]',...
                    MWTrunameO,'[',expid1,'.',expid2,']'];
                end
                
 
            end
            %  save file
            savename = [expcond,'.mfi'];
            cd(pSum); fid = fopen(savename, 'w');
            fprintf(fid, '%s %d %d %d\n', expathO); fclose(fid); 
            
            % reporting
            option = 'noshow';
            switch option
                case 'noshow'
                case 'show'
                    display ' ';
                    str = 'Save name: %s'; a = sprintf(str,savename); disp(a);
                    str = 'original experiment path: %s'; a = sprintf(str,expathO); disp(a);
                    str = 'original MWT run name: %s'; a = sprintf(str,MWTrunameO); disp(a);
                    str = 'Total exp duration: %d(s)'; a = sprintf(str,totalduration); disp(a);
                    str = 'preplate: %d(s)'; a = sprintf(str,preplate); disp(a);
                    str = 'ISI: %d(s)'; a = sprintf(str,ISI); disp(a);
                    str = 'tap: %d'; a = sprintf(str,tapN); disp(a);
                    str = 'variable tap: %d'; a = sprintf(str,tapVar); disp(a);
            end
        end
        %%
    case 'REFRESH'; MWTfnWanted = MWTfnD;
        for m = 1:numel(pMWTfD)
            pMWT = pMWTfD{m};
            [fn,p] = dircontentext(pMWT,'*.set');
            if iscell(p)==1 && numel(p)==1; pset = char(p); 
            elseif isempty(p)==1; str = 'MWTf[%s]has no *.set file'; 
                display(sprintf(str,MWTfnD{m})); continue; 
            end
            a = fileread(pset); b = regexp(a,'(FALSE)|(TRUE)','split')';

            % get original expath and MWTruname
            c = regexp(b{1},'\s','split')';
            if isempty(c{end})==1; MWTrunameO = c{end-1}; 
            else display 'problems!'; return; end
            d = regexp(b{1},MWTrunameO,'split');
            expathO = d{1}; d = regexp(expathO,'\','split');
            expid1 = d{end-1}; expid2 = char(regexprep(d{end},'\s',''));

            % get original run condition
            c = celltakeout(regexp(b(5),'\s','split')','split');
            d = c(not(cellfun(@isempty,c)));
            totalduration = str2num(d{end});
            c = celltakeout(regexp(b(6),'\s','split')','split');
            d = c(not(cellfun(@isempty,c)));
            preplate = str2num(d{1}); ISI = str2num(d{2});
            tapN = str2num(d{3}); tapVar = str2num(d{4});

            % save file
            cd(pSum); aftertap = totalduration-((ISI*tapN)+preplate);
            [~,MWTfn] = fileparts(pMWT);
            expcond = [MWTfn,'[',num2str(totalduration),'s(',num2str(preplate),...
                's',num2str(tapN),'x',num2str(ISI),'s',num2str(aftertap),'s)]',...
                MWTrunameO,'[',expid1,'.',expid2,']'];
            savename = [expcond,'.mfi'];
            fid = fopen(savename, 'w');
            fprintf(fid, '%s %d %d %d\n', expathO); fclose(fid); 

            % reporting
            option = 'noshow';
            switch option
                case 'noshow'
                case 'show'
                display ' ';
                str = 'Save name: %s'; a = sprintf(str,savename); disp(a);
                str = 'original experiment path: %s'; a = sprintf(str,expathO); disp(a);
                str = 'original MWT run name: %s'; a = sprintf(str,MWTrunameO); disp(a);
                str = 'Total exp duration: %d(s)'; a = sprintf(str,totalduration); disp(a);
                str = 'preplate: %d(s)'; a = sprintf(str,preplate); disp(a);
                str = 'ISI: %d(s)'; a = sprintf(str,ISI); disp(a);
                str = 'tap: %d'; a = sprintf(str,tapN); disp(a);
                str = 'variable tap: %d'; a = sprintf(str,tapVar); disp(a);
            end
        end
end

%% STEP1D: GET RUN CONDITION FROM SUMMARY.set
[fn,~] = dircontent(pSum);
a = celltakeout(regexp(fn,'(','split'),'split');
b = a(:,2);
c = celltakeout(regexp(b,')','split'),'split');
d = c(:,1);
e = celltakeout(regexp(fn,'[','split'),'split');
f = e(:,1);
setSum = [f,d];
setSum(cellfun(@isempty,d),:) = [];

%% STEP2: CHECK RUNCONDITION NAME AND EXP NAME
[A] = MWTDataBaseMaster(HomePath,'GetStdMWTDataBase');
pExpfD = A.pExpfD; ExpfnD = A.ExpfnD; GfnD = A.GfnD;
pGfD = A.pGfD; pMWTf = A.pMWTf; MWTfn = A.MWTfn;
pNonExpf = A.pNonExpf; NonExpfn = A.NonExpfn;
% define pMWTfD
 pMWTfD = A.pMWTf; MWTfnD = A.MWTfn;

% check individual exp
for x = j:numel(pExpfD)
    check = 'pass';
    Homepath = pExpfD{x};
    HomeExpname = ExpfnD{x};
    display ' ';
    str = 'checking experiment %s';
    display(sprintf(str,HomeExpname));
     [pExpV,Expfn,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = ...
    getMWTpathsNname(Homepath,'noshow');
    [A] = MWTDataBaseMaster(Homepath,'GetStdMWTDataBase');
    [~,~,~,runcond,~] = parseMWTfnbyunder(MWTfsn);
    

    % find expter
    a = regexp(HomeExpname,'_','split');
    b = a(1,2);
    expter = char(b);
    str = 'expter = %s';
    display(sprintf(str,expter));
    
    % check expdate
    a = celltakeout(regexp(MWTfn,'_','split'),'split');
    b = a(:,1);
    if numel(unique(b))==1; expdate = unique(b); 
        str = 'experiment date consistent: %s';
        display(sprintf(str,char(expdate))); 
    else display 'inconsistent expdate'; check = 'failexp';
    end
    
    % get run cond from .set
    runconSet = {};
    for m = 1:size(runcond,1)
        i = celltakeout(regexp(setSum(:,1),MWTfn{m}),'logical');
        runconSet = [runconSet;setSum(i,2)];
    end
    
    % get runcon from exp name
    a = regexp(HomeExpname,'_','split');
    expruncond = a(1,3);
    
    % get run cond from MWTfsn
    runcondU = unique(runcond);
    
    % match runcon with setcond
    if isequal(runcond,runconSet)==0;
        display 'runcond inconsistent with .set record';
        display 'runconSet:'; disp(runconSet); 
        display 'experiment names:';
        disp([MWTfn;MWTfsn;runcond]); check = 'failset';
    else display 'runcond consistent with .set record';
    end
    
    % check runcond
    if numel(runcondU)==1 && strcmp(char(expruncond),char(runcondU))==1;
        runcondV = runcondU; 
        str = 'runcondition consistent within exp: %s';
        display(sprintf(str,char(runcondV))); 
    else display 'inconsistent runcondition:'; disp(runcondU); 
        str = 'exp runcon: %s';
        display(sprintf(str,char(expruncond)));
        disp([MWTfn;MWTfsn;runcond]); check = 'failruncon';
    end

    switch check
        case 'failruncon';
            str = 'Check expeirment %s';
            display(sprintf(str,HomeExpname));
            j =x-5; return;
        case 'failexp';
            str = 'Check expeirment %s';
            display(sprintf(str,HomeExpname));
            j =x-5; return;
        case 'failset'
            str = 'Check expeirment %s';
            display(sprintf(str,HomeExpname));
            if x <4; j=1; else j =x-2; return;end
    end
end

%% STEP3 [MANUAL]: delete sprevs and correct run name
error('entering manual phase of the script');
[~,~,fn,p] = dircontent(Homepath);
i = ismember(fn,{'MatlabAnalysis'});
p(i)=[];
[~,p] = cellfun(@dircontentmwt,p,'UniformOutput',0);
p = celltakeout(p,'multirow');
[search] = cellfunexpr(p,'*.sprevs');
[fn,p] = cellfun(@dircontentext,p,search,'UniformOutput',0);
p = celltakeout(p,'multirow');
cellfun(@delete,p(2:end));
% correct individual names
[pExpf,MWTsum] = MWTrunameMaster(Homepath,'switch');
display 'done';
display ' ';

%% STEP4A [MANUAL]: auto correct names
[pExpf,MWTsum] = MWTrunameMaster(Homepath,'tested');
display 'done';
display ' ';

%% STEP4B [MANIA]: correct individual names
[pExpf,MWTsum] = MWTrunameMaster(Homepath,'switch');
display 'done';
display ' ';

%% STEP5B[MANUAL]: one by one
[pExpf,MWTsum] = MWTrunameMaster(Homepath,'onebyone');
