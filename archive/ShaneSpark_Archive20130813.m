function [O] = ShaneSpark(pExp,pFun)
%% Analyze experiment folder that gives standard habituation curve
% for student uses
% habitution anaysis complete flow
%% set up output
O = {};


%% prepare zip and unzip
[pExpf,pMWTf] = unzipMWT(pExp);
[pExpf,pMWTf,MWTfn] = getunzipMWT(pExp); % get unzipped MWT file folders
zipExpbackup(pExpf); % zip a pExp as back up


%% [DEVELOP] check MWT run names
[pExpf,MWTsum] = MWTrunameMaster(pExp,'tested');
% take out results
pMWTf = MWTsum(:,1);
MWTfn = MWTsum(:,2);
MWTfsn = MWTsum(:,2:3);


%% Assign group names
[gnmaster,groupnameU] = defineGroupName(pExp);

ID = 'Developer'
switch ID
    case 'Developer'
        % create group folders and move MWTf into them
        % create group folders
        % move files to group folders
        cd(pExp);
        cellfun(@mkdir,groupnameU); % create group folders
        % move folders
        [~,pMWTf] = dircontentmwt(pExp);
        for x = 1:numel(groupnameU)
            i = not(cellfun(@isempty,regexp(gnmaster(:,2),groupnameU{x}))); % get MWT that needs to be moved
        [groupfolder] = cellfunexpr(find(i),strcat(pExp,'/',groupnameU{x}));
        cellfun(@movefile,pMWTf(i),groupfolder);
        end
    case 'Tested'
end

display(' ');
% sequence appears on the graph
[GAA] = groupseq(GA);
[savename] = creatematsavename3(expname,'Groups_','.mat');
cd(pGradRawExp);
save(savename,'GA','MWTfgcode');
cd(pAExp);
save(savename,'GA','MWTfgcode');
display('done');


%% validate MWTf folder contents
% [DEVELOP] choice to get rid of bad files
validaterawfilecontents(pExp); % Experiment error reporting
% needs to have .summary .set and .blobs
[set,~] = cellfun(@dircontentext,pMWTf,'*.set');
[summary,~] = cellfun(@dircontentext,pMWTf,'*.summary');
[blob,~] = cellfun(@dircontentext,pMWTf,'*.blobs');
% evaluate if empty
seti = cellfun(@isempty,set) ==1;
sumi = cellfun(@isempty,summary) ==1;
blobi = cellfun(@isempty,blob) ==1;
if sum(seti)>0||sum(sumi)>1||isempty(blobi)>1;
    display 'one of MWT file missing one of [set summary or blob] files';
    display 'need further programming to address this...';
    broken = 1;
end



%% [UNTESTED] moving broken files to defined folder
if broken ==1;
% create folders under pExp
mkdir(pExp,'BrokenMWTfiles');
pBF = [pExp '/' 'BrokenMWTfiles'];
brokeni = find(sumi+blobi); % if blob and sum are missing
[p] = cellfunexpr(numel(brokeni),pBF);
cellfun(@movefile,pMWTf(brokeni),pBF);  




%% standardize folder name and back up to Raw data
%[pAExp,pExpS,pRaw,pRawC,pRawCExp,expname,analyzedname] = ...
%standardizefoldername(pFun,pExp); % standardize folder name % [ARCHIVE]
display('Standardizing experiment folder name...');
[expname,pExpter] = findstadexpfoldername(pExp,pFun);% standardize folder name: 20130528B_DH_100s30x10s10s
[~,originalname] = fileparts(pExp); % find original name

% record original name
cd(pExp);
str = originalname;
fName = strcat('originalexpname_',originalname,'.txt');
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end

% move files to standardize name
pNew = [pExpter '/' expname];
cd(pExpter);
mkdir(expname);
movefile([pExp '/*'],pNew);
rmdir(pExp); % delete original file
pExp = pNew; % reset pExp
% make a copy to pRaw data backup
pRaw = P.Raw; % find pRaw
zip([pRaw '/' expname],pExp); % make a zip copy to Raw

%% [UNTESTED]..............
%% get defined user name
% find path for report to grad students
pGradRaw = P.GradRaw;
pGradRawExp = [pGradRaw,'/',expname];
cd(pGradRaw);
mkdir(expname);
% make folder for analysis report to grad student
pExpS = strcat(pExpter,'/',expname);
[analysissavename] = creatematsavenamewdate('_Analysis_ShaneSpark_','');
pAExp = strcat(pExpter,'/',expname,analysissavename);
cd(pExpter);
mkdir(pAExp);
str = Expterfname;                 %# A string
fName = strcat('OriginalExpName_',expname,'.txt');         %# A file name
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end
cd(pGradRawExp);
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end



%% [DEVELOP] change raw report to text file append

switch STATUS;
case 'run before chor installed in lab MAC'
    ...
 case 'release chor'       
    %% [DEVELOP] Assign group names and sequence appears on the graph

    [GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExp,0);
    display(' ');
    [GAA] = groupseq(GA);
    [savename] = creatematsavename3(expname,'Groups_','.mat');
    cd(pGradRawExp);
    save(savename,'GA','MWTfgcode');
    cd(pAExp);
    save(savename,'GA','MWTfgcode');
    display('done');
end
%% organize MWT files and back up
organizemwtfiles(pExp,pExpS,pRaw,expname); % move files

%% Choreography and importing generated data
switch STATUS;
case 'run before chor installed in lab MAC'
...
case 'release chor'
    ShaneSparkChor(pExp); % chore
    cd(pExp);
    diary(diarysavename);
end


Codingstatus = 'Archive';
switch Codingstatus
case 'Active'
    % do nothing
case 'Archive'
    % Archive of previous codes
    switch TYPE  
        case 'Organize';
            %% zip and unzip data
            %% [DEVELOP] change original name file for it to start with run name
            [~,~] = unziprawdata(pExp); % Unzip raw data
            if exist(strcat(pExp,'.zip'),'file') ~=2; % if this file had not been zipped
                display('Zipping a copy of current file as backup, please wait...');
                zip(pExp,pExp); % create a zip back up in case of mistakes
            end
            display('done');

            %% check names
            [MWTfsn] = correctMWTnamingswitchboard3(pExp); % Make sure MWTrun naming are correct
            % show strain group. validate strains

            %% validate MWTf folder contents
            %% [DEVELOP] choice to get rid of bad files
            validaterawfilecontents(pExp); % Experiment error reporting

            %% create standardize folder name
            [pAExp,pExpS,pRaw,pGradRaw,pGradRawExp,expname,analyzedname] = ...
                standardizefoldername(pFun,pExp); % standardize folder name
            cd(pAExp);
            diary(dsavn);

            %% [DEVELOP] change raw report to text file append

            switch STATUS;
                case 'run before chor installed in lab MAC'
                    ...
                 case 'release chor'       
                    %% [DEVELOP] Assign group names and sequence appears on the graph

                    [GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExp,0);
                    display(' ');
                    [GAA] = groupseq(GA);
                    [savename] = creatematsavename3(expname,'Groups_','.mat');
                    cd(pGradRawExp);
                    save(savename,'GA','MWTfgcode');
                    cd(pAExp);
                    save(savename,'GA','MWTfgcode');
                    display('done');
            end
            %% organize MWT files and back up
            organizemwtfiles(pExp,pExpS,pRaw,expname); % move files

            %% Choreography and importing generated data
            switch STATUS;
                case 'run before chor installed in lab MAC'
                ...
                case 'release chor'
                    ShaneSparkChor(pExp); % chore
                    cd(pExp);
                    diary(diarysavename);
            end

        case 'Analysis'
            %% [BUGlist] 
            % [BUG] sometimes there are data points but no object valid
            % [BUG] trv size not consistent, fixes
            % [BUG] check for plate consistency
            % [BUG] trv size not consistent, fixes
            %% Import trv and group data for graphing
            [MWTftrv] = importtrvNsave(pExp,pExp); % import trv generated from Chore
            diary(diarysavename);

             switch STATUS;
                case 'run before chor installed in lab MAC'
                    %% [DEVELOP] Assign group names and sequence appears on the graph
                    [GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExp,0);
                    display(' ');
                    [GAA] = groupseq(GA);
                    [savename] = creatematsavename3(expname,'Groups_','.mat');
                    cd(pGradRawExp);
                    save(savename,'GA','MWTfgcode');
                    cd(pAExp);
                    save(savename,'GA','MWTfgcode');
                    display('done');
                 case 'release chor'  
                     ...       
            end
            %% Data analysis and graphing
            %% [Check] statistic formula needs to be checked
            ShaneSparkGraph3(pExp,pFun,pExp,MWTfgcode,GAA,expname,dsavn);
            cd(pExp);
            diary(dsavn);

            %% back up and clean up
            % remove blobs, summary png and set files
            removeallexceptanalyzed(pExp);
            % move analyzed files to analyzed folder
            moveanalyzedfiles2analyzedfolder(pExp,pExp);
            % make a copy to Conny's folder
            backup2Connyfolder(pFun,analyzedname,pExp);


            %% reporting
            display(' ');
            display('ShaneSpark analysis completed.');  
        otherwise 
        display('you need to type in correct analysis stage');
        display('run the program again');
    end

end % coding switch end
end % function end




