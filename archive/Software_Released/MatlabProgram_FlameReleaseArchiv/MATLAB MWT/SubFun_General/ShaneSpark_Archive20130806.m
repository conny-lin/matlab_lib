function ShaneSpark(pExp,pFun)
% from HabAnalysis3
% habitution anaysis complete flow
STATUS = 'run before chor installed in lab MAC';
display('This is a beta release. \nFull release will launch once Choreography are installed in lab Macs,\nConny Lin 2013 Aug 2nd.');
TYPE = input('Please indicate which stage of analysis you''d like to do\n(A) Prepare File for Beethoven Analysis type [Organize]\n(B) Following Beethoven Analysis, type [Analysis]\n','s');
%% set up
addpath(genpath(pFun));
pExpO = pExp; % define pExp as original path name 
[dsavn] = diarysavename(pExp); % record diary set up paths

switch TYPE  
    case 'Organize';
        %% zip and unzip data
        %% [DEVELOP] change original name file for it to start with run name
        [~,~] = unziprawdata(pExpO); % Unzip raw data
        if exist(strcat(pExpO,'.zip'),'file') ~=2; % if this file had not been zipped
            display('Zipping a copy of current file as backup, please wait...');
            zip(pExpO,pExpO); % create a zip back up in case of mistakes
        end
        display('done');

        %% check names
        [MWTfsn] = correctMWTnamingswitchboard3(pExpO); % Make sure MWTrun naming are correct
        % show strain group. validate strains

        %% validate MWTf folder contents
        %% [DEVELOP] choice to get rid of bad files
        validaterawfilecontents(pExpO); % Experiment error reporting

        %% create standardize folder name
        [pAExp,pExpS,pRaw,pRawC,pRawCExp,expname,analyzedname] = ...
            standardizefoldername(pFun,pExpO); % standardize folder name
        cd(pAExp);
        diary(dsavn);

        %% [DEVELOP] change raw report to text file append

        switch STATUS;
            case 'run before chor installed in lab MAC'
                ...
             case 'release chor'       
                %% [DEVELOP] Assign group names and sequence appears on the graph
                
                [GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExpO,0);
                display(' ');
                [GAA] = groupseq(GA);
                [savename] = creatematsavename3(expname,'Groups_','.mat');
                cd(pRawCExp);
                save(savename,'GA','MWTfgcode');
                cd(pAExp);
                save(savename,'GA','MWTfgcode');
                display('done');
        end
        %% organize MWT files and back up
        organizemwtfiles(pExpO,pExpS,pRaw,expname); % move files

        %% Choreography and importing generated data
        switch STATUS;
            case 'run before chor installed in lab MAC'
            ...
            case 'release chor'
                ShaneSparkChor(pExpO); % chore
                cd(pExpO);
                diary(diarysavename);
        end
        
    case 'Analysis'
            %% Import trv and group data for graphing
        %% [BUG] sometimes there are data points but no object valid
        %% [BUG] trv size not consistent, fixes
        %% [BUG] check for plate consistency
        %% [BUG] trv size not consistent, fixes
        [MWTftrv] = importtrvNsave(pExpO,pExpO); % import trv generated from Chore
        diary(diarysavename);

         switch STATUS;
            case 'run before chor installed in lab MAC'
                %% [DEVELOP] Assign group names and sequence appears on the graph
                [GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExpO,0);
                display(' ');
                [GAA] = groupseq(GA);
                [savename] = creatematsavename3(expname,'Groups_','.mat');
                cd(pRawCExp);
                save(savename,'GA','MWTfgcode');
                cd(pAExp);
                save(savename,'GA','MWTfgcode');
                display('done');
             case 'release chor'  
                 ...       
        end
        %% Data analysis and graphing
        %% [Check] statistic formula needs to be checked
        ShaneSparkGraph3(pExpO,pFun,pExpO,MWTfgcode,GAA,expname,dsavn);
        cd(pExpO);
        diary(dsavn);

        %% back up and clean up
        % remove blobs, summary png and set files
        removeallexceptanalyzed(pExpO);
        % move analyzed files to analyzed folder
        moveanalyzedfiles2analyzedfolder(pExpO,pExpO);
        % make a copy to Conny's folder
        backup2Connyfolder(pFun,analyzedname,pExpO);


        %% reporting
        display(' ');
        display('ShaneSpark analysis completed.');  
    otherwise 
    display('you need to type in correct analysis stage');
    display('run the program again');
end
end



