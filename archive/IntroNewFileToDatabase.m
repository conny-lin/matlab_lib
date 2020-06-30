%% BackStage_IntroNewFileToDataBase
%% README.
% this function aims to incorporate new MWT files in standard database.
% from MWT deposited in path defined in pIn, the program does:
% - checks experiment folder naming 
% - check group name is started wtih strain name
% - allow change of group names
% - zip MWT folders and move to database folder defined in path pData


%% 2. GET INCOMING EXP FOLDERS
[ExpNameIn,pExpIn] = dircontent(pIn);
[ExpName_Database,pExp_Database] = dircontent(pData);


%% 3. CHECK EXP NAMING
% example: 20150202A_AT_100s30x10s10s

% check new exp names
i = regexpcellout(ExpNameIn,...
    '\d{8}[A-Z]{1}(_)[A-Z]{2}(_)\d{1,}(s)\d{1,}(x)\d{1,}(s)\d{1,}(s)');
if sum(~i) > 0
    display ' ';
    display 'Please correct exp names below to correct format (e.g. 20150202A_AT_100s30x10s10s):'
    disp(ExpNameIn(~i))
    display '  ** BackStage: Correction required **'
    return
else
    display 'PASS: experiment names in incoming files all correct';
end


% check databse exp names
i = regexpcellout(ExpName_Database,...
    '\d{8}[A-Z]{1}(_)[A-Z]{2}(_)\d{1,}(s)\d{1,}(x)\d{1,}(s)\d{1,}(s)');
if sum(~i) > 0
    display ' ';
    display 'Please correct exp names below to correct format (e.g. 20150202A_AT_100s30x10s10s):'
    disp(ExpNameIn(~i))
    display '  ** BackStage: Correction required **'
    return
else
    display 'PASS: experiment names in database all correct';
end



%% 4. CHECK IF EXP FOLDER HAS GROUP FOLDERS
bothpaths = [{pExp_Database}; {pExpIn}];
pathsnames = {'Database','Incoming'};
for y = 1:numel(bothpaths)
    [a,b] = cellfun(@dircontent,bothpaths{y},'UniformOutput',0);
    val = false(size(b));
    for x = 1:numel(b)
        if isempty(b{x}) == 0
            val(x) = true;
        end
    end
    if sum(~val) > 0
        display ' ';
        display(sprintf('The following exp folders in %s contained no group folder:',...
            pathsnames{y}));
        disp(ExpName_Database(~val))
        display '  ** BackStage: Correction required **'
        return
    else
        display(sprintf('PASS: all %s exp folders contain group folder',...
            pathsnames{y}));
    end
end



%% 5. CHECK GROUP FOLDER NAMING
% example: BZ142 or BZ142_condition_condition
if isempty(ExpNameIn) == 0
    bothpaths = [{pExp_Database}; {pExpIn}];
    pathsnames = {'Database','Incoming'};
else
    bothpaths = [{pExp_Database}];
    pathsnames = {'Database'};
end

for y = 1:numel(bothpaths)
    % get info
    [a,b] = cellfun(@dircontent,bothpaths{y},'UniformOutput',0);
    val = false(size(b));
    GroupName = celltakeout(a);
    pG = celltakeout(b);
    GroupName_Parts = regexpcellout(GroupName,'_','split');
    
    % check strain name
    GroupName_Strain = GroupName_Parts(:,1);
    i = regexpcellout(GroupName_Strain,'^[A-Z]{1,}\d{1,}');
    j = i == false;
    GroupName_Strain_Problem = GroupName_Strain(j);
    if isempty(GroupName_Strain_Problem) == 0
        display 'these names need to be corrected:';
        disp(unique(GroupName_Strain_Problem));
    else
        display 'all group names passed test';
    end
    k = ismember(GroupName_Strain,GroupName_Strain_Problem);
    pGroup_Problem = pG(k);
    [pExp_Problem,n] = ...
        cellfun(@fileparts,...
            cellfun(@fileparts,pGroup_Problem,'UniformOutput',0)...
        ,'UniformOutput',0);
    [~,a] = cellfun(@fileparts,pGroup_Problem,'UniformOutput',0);
    
    
    %% 5.1 CORRECT GROUP NAMES 
    gStart = 1;
    sortlater = false(size(pGroup_Problem));
    for g = gStart:numel(pGroup_Problem)

        %% get group problem path
        pG = pGroup_Problem{g};
        [~,gname_target] = fileparts(pG);

        %% deal with all other groups in the exp file together
        [pExp,gname_old] = fileparts(pG);
        [~, ExpName] = fileparts(pExp);
        display ' '; 
        display(sprintf('Groups within exp [%s]:',ExpName))
        [gnames_problem,pGnames_problem] = dircontent(pExp);

        %% look into file names for clue
        for gg = 1:numel(pGnames_problem)

            % unzip
            [ZipName,pZip] = dircontent(pGnames_problem{gg});
            pZip1 = pZip{1};
            pZip_Temp1 = regexprep(pZip1, pData, pTemp);
            if isdir(regexprep(pZip_Temp1,'.zip','')) == 0
                unzip(pZip1,fileparts(pZip_Temp1));
            end

            % show file name
            pMWT_Temp1 = regexprep(pZip_Temp1,'.zip','');
            fn = dircontent(pMWT_Temp1);
            i = regexpcellout(fn,'(.set)');
            n = regexprep(fn{i},'.set','');
            [~,gname_Temp] = fileparts(fileparts(pZip_Temp1));
            display(sprintf('[%s] contains file name: %s',gname_Temp,n));

            % get suggsted strain name
            if strcmp(pG,pGnames_problem{gg})
                a = regexp(n,'_','split');
                % cross check if these names duplicates existing names
                StrainName_Suggested = [a{1}];
                if sum(ismember(gnames_problem,StrainName_Suggested)) > 0
                    StrainName_Suggested = [a{1},'_',gname_target];
                end
                recommendPhrase = ...
                    sprintf('[1] Use [%s]\n[2] Use another name\n[3] Sort Later\n[0] Abort program ',...
                    StrainName_Suggested);
            end
        end

        %% ask for desired strain name
        display ' ';
        display(sprintf('Choose options for correcting group name [%s]', ...
            gname_target))
        status = 0;
        while status == 0
            disp(recommendPhrase);
            i = input(': ');
            switch i
                case 2
                    StrainName_Desired = input('enter desired strain name: ','s');
                    status = 1;
                case 1
                    StrainName_Desired = StrainName_Suggested;
                    status = 1;
                case 3
                    sortlater(g) = true;
                    status = 1;

                case 0
                    display '** Program Aborted **';
                    gStart = g;
                    return
                otherwise 
                    status = 0;
            end
        end

        %% prompt to change name
        if sortlater(g) == false;
            i = input(sprintf('Change groupname [%s] to [%s] (yes=1, no=0, 5=abort): ',...
                gname_old,StrainName_Desired));
            status = 0;
            switch i
                case 1
                    status = 1;
                case 0
                    StrainName_Desired = input('Enter desired group name: ','s');
                    status = 1;
                otherwise
                    display '** Program Aborted **';
                    gStart = g;
                    return
            end

            if status == 1;
                % add strain name in front of group code
                pG_NewName = [fileparts(pG),'/',StrainName_Desired];
                % change group folder name
                source = pG;
                destination = pG_NewName;
                movefile(source,destination);
                gStart = g+1;
            end
        end

    end

end

% report
display 'PASS: all group names contain strain names';



%% 6. CHECK INTEGRITY OF MWT FILES & ZIP FILES & MIGRATE TO CENTRAL FILE
if isempty(ExpNameIn) == 0
    for e = 1:numel(ExpNameIn)
        % get exp paths
        pExp = pExpIn{e};

        % reporting
        [~,fn] = fileparts(pExp);
        display ' ';
        display(sprintf('Processing new exp [%s]',fn));

        %% check integrity of MWT files
        [~,pG] = dircontent(pExp);
        [fn,p] = cellfun(@dircontent,pG,'UniformOutput',0);
        pMWT_List = celltakeout(p);
        for m = 1:numel(pMWT_List)
            pMWT = pMWT_List{m};
            [fA, pA] = dircontent(pMWT);
            iMWT_original = ...
                regexpcellout(fA,'(.blobs)|(.blob)|(.png)|(.set)|(.summary)');
            pA_MWT_original = pA(iMWT_original);
            source = pA(~iMWT_original);

            % move analysis files to storage
            destination = regexprep(source, pIn, pAnalysis);

            % create analysis storage folder
            p = unique(cellfun(@fileparts,destination,'UniformOutput',0));
            i = cellfun(@isdir,p);
            for f = 1:numel(p)
                if i(f) == 0; mkdir(p{f}); end
            end

            % move file
            cellfun(@movefile,source,destination);

            % zip MWT file
            [~,fn] = fileparts(pMWT);
            display(sprintf('zipping [%s]',fn));
            zip(pMWT,pMWT);
            rmdir(pMWT,'s');

        end

        %% move exp to pData
        source = pExp;
        destination = regexprep(source, pIn, pData);
        movefile(source, destination);


    end
end

%% 7. CHECK GROUP NAME EXTENSIONS OK
% survey current database status
[~, p] = dircontent(pData);
[f,p] = cellfun(@dircontent,p,'UniformOutput',0);
fGroupNames_Database = celltakeout(f);
pGroupNames_Database = celltakeout(p);
fGroupNames_Database_Parts = ...
    regexpcellout(fGroupNames_Database,'_','split');
fGroupNames_Database_Ext = fGroupNames_Database_Parts(:,2:end);

% get group name parts
nExt = size(fGroupNames_Database_Ext,2);
% find unique extension per col
ExtCollection =  {};
for x = 1:nExt
    Ext = {};
    Ext(:,1) = fGroupNames_Database_Ext(:,x);
    Ext(:,2) = pGroupNames_Database;
    Ext(:,3) = repmat({x},size(Ext,1),1);
    i = ~cellfun(@isempty,Ext(:,1));
    Ext(~i,:) = [];
    ExtCollection = [ExtCollection;Ext];
end

% get name to change
ExtU = unique(ExtCollection(:,1));
disp(makedisplay(ExtU))

% visually inspect bad names
status = input('anymore changes? (yes=1, no=0): ');


while status == 1  
    i = input('Choose bad name: ');
    badName = ExtU{i};
    corrName = input(sprintf('enter correct name for [%s]: ',badName),'s');

    % check repeats per col
    a = ExtCollection(:,1);
    p = ExtCollection(:,2);
    i = ismember(a,badName);
    pGroupNameProblem = p(i);
    if sum(i) > 0
        display(sprintf('[%s] found in experiment folder:',badName));
        [pProblem, fProblem] = cellfun(@fileparts,pGroupNameProblem,...
            'UniformOutput',0);
        pProblemU = unique(pProblem);
%         if numel(pProblemU) == 1
%             [~,n] = fileparts(pProblemU{1});
%         else
            [~,n] = cellfun(@fileparts,pProblemU,'UniformOutput',0);
%         end
        disp(n);

        % change folder name
        pNew = cellfun(@strcat,...
                pProblem,...
                cellfunexpr(pProblem,'/'),...
                regexprep(fProblem,badName,corrName),...
                'UniformOutput',0);
        cellfun(@movefile,pGroupNameProblem,pNew);
        display 'corrected';
    else
        display(sprintf('no bad name [%s] found',badName));
    end
    
    % survey current database status
    [~, p] = dircontent(pData);
    [f,p] = cellfun(@dircontent,p,'UniformOutput',0);
    fGroupNames_Database = celltakeout(f);
    pGroupNames_Database = celltakeout(p);
    fGroupNames_Database_Parts = ...
        regexpcellout(fGroupNames_Database,'_','split');
    fGroupNames_Database_Ext = fGroupNames_Database_Parts(:,2:end);

    % get group name parts
    nExt = size(fGroupNames_Database_Ext,2);
    % find unique extension per col
    ExtCollection =  {};
    for x = 1:nExt
        Ext = {};
        Ext(:,1) = fGroupNames_Database_Ext(:,x);
        Ext(:,2) = pGroupNames_Database;
        Ext(:,3) = repmat({x},size(Ext,1),1);
        i = ~cellfun(@isempty,Ext(:,1));
        Ext(~i,:) = [];
        ExtCollection = [ExtCollection;Ext];
    end

    % get name to change
    ExtU = unique(ExtCollection(:,1));
    disp(makedisplay(ExtU))
    status = input('anymore changes? (yes=1, no=0): ');
end


%% 8. UPDATE DATABASE INDEX
display 'update database index';
[~, p] = dircontent(pData);
[f,p] = cellfun(@dircontent,p,'UniformOutput',0);
f = celltakeout(f);
p = celltakeout(p);
[~,n] = cellfun(@fileparts,...
    cellfun(@fileparts,p,'UniformOutput',0),'UniformOutput',0);
f = [regexpcellout(f,'_','split'),n];

gnameParts = f;
T = cell2table(gnameParts);
cd(pDriveHome);
writetable(T,'MWT_Database.txt','Delimiter','\t')

%% CODE DONE
display '  ** BackStage: Ready to Dance **'
display ' ';
return