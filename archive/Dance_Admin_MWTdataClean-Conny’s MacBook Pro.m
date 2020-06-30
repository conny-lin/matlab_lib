%% OBJECTIVE:
% clean MWT data: keep only .png .set .summary .blobs

%% PATHS [Manual setting]
pDataHome = '/Volumes/ParahippocampalGyrus/MWT_1_Data_Cleaning';
pAnalysisStore = '/Volumes/ParahippocampalGyrus/MWT_Data_Analysis_store';
pMatStore = '/Volumes/ParahippocampalGyrus/MWT_MatAnalysis_Data';
pZipBackup = '/Volumes/ParahippocampalGyrus/MWT_0_Data_Temp_Backup';
pDone = '/Volumes/ParahippocampalGyrus/MWT_1_Data_Cleaning_Done';
addpath('/Users/connylin/OneDrive/MATLAB/Functions_Developer');
zipstatus = 1;

%% PREPARE MWT FOLDERS
[Expfn, pExp] = dircontent(pDataHome);


%%
for x = 1:numel(Expfn)
   display ' ';
   display(sprintf('Processing exp: %s ****',Expfn{x}));
   
   %% check if already has back up (not coded)
   
   %% zip whole experiment file for backup
   if zipstatus == 1
       display(sprintf('*zipping: %s',Expfn{x}));
       pExpNew = regexprep(pExp{x},pDataHome,pZipBackup);
       zip(pExpNew,pExp{x});
   end
   
   % create store exp folder
   display '*create exp folder store';
   pExpA = regexprep(pExp{x},pDataHome,pAnalysisStore);
   if isdir(pExpA) == 0; mkdir(pExpA); end
   
   % create done clean exp folder
   display '*create exp folder done folder';
   pExpA = regexprep(pExp{x},pDataHome,pDone);
   if isdir(pExpA) == 0; mkdir(pExpA); end
   
   % see if non folder file under exp folder 
   [Gfilename,pGfile, Groupfn, pGroup] = dircontent(pExp{x});
   i = ~regexpcellout(Groupfn,Gfilename);
   % if so, move under exp folder
   if sum(i) > 0
       display '*move files under exp folder to storage';
       pGfileMove = pGfile(i);
       for f = 1:sum(i)
            movefile(pGfileMove{f}, ...
                regexprep(pGfileMove{f},pDataHome,pAnalysisStore));
       end
   end
   
   
   
   %% look at group folders
    % find exp folder content
    [Gfilename,pGfile, Groupfn, pGroup] = dircontent(pExp{x});
   
    for g = 1:numel(Groupfn)
       display(sprintf('*processing group: %s',Groupfn{g}));
      
       %% move MatlabAnalysis files to store
       
        if strcmp(Groupfn{g},'MatlabAnalysis') ==1
            display('store matlab analysis data');
            % rename file and store else where
            pFNew = regexprep(pGroup{g},pDataHome,pAnalysisStore);
            if isdir(pFNew) == 0; mkdir(pFNew); end 
            [~,pT] = dircontent(pGroup{g});
            pNew = regexprep(pT,pDataHome,pAnalysisStore);
            cellfun(@movefile,pT,pNew)
            rmdir(pGroup{g},'s')
        
        else
                     
           % create store group folder
           display '**create group folder store';
           p = regexprep(pGroup{g},pDataHome,pAnalysisStore);
           if isdir(p) == 0; mkdir(p); end

           % create done clean group folder
           display '**create group folder done folder';
           p = regexprep(pGroup{g},pDataHome,pDone);
           if isdir(p) == 0; mkdir(p); end

           % move zip MWT files to done folder
           [MWTfilenames, pMWTfilenames] = dircontent(pGroup{g});
           i = regexpcellout(MWTfilenames,'\<\d{8}[_]\d{6}\>(.zip)');
           pS = pMWTfilenames(i);
           pNew = regexprep(pS,pDataHome,pDone);
           cellfun(@movefile,pS,pNew)

            % get group folder content
           [fn,pf,folders, p] = dircontent(pGroup{g});
            i = regexpcellout(folders,'\<\d{8}[_]\d{6}\>');
            MWTfn = folders(i);
            pMWT = p(i);
           % move files under group folder to analysis store
           i = ~ismember(fn,MWTfn);
           if sum(i) > 0
               pS = pf(i);           
               % move files
               pNew = regexprep(pS,pDataHome,pAnalysisStore);
               a = cellfunexpr(pNew,'f');
               cellfun(@movefile,pS,pNew,a)
           end

           % if group folder is empty, delete
           [fn,pf,MWTfn, pMWT] = dircontent(pGroup{g});
           if isempty(fn) == 1; 
               rmdir(pGroup{g},'s'); 
           else 
               % get new group folder content
               [fn,pf,MWTfn, pMWT] = dircontent(pGroup{g});   

               %% process each MWT folders
                for m = 1:numel(pMWT)
                    [~,mwtfn] = fileparts(pMWT{m});
                    display(sprintf('***cleaning [%d/%d] MWT folder: %s', ...
                        m,numel(pMWT),mwtfn));

                    % create MWT folder store
                    p = regexprep(pMWT{m},pDataHome,pAnalysisStore);
                    if isdir(p) == 0; mkdir(p); end

                    % get content
                    [fn,pf,folder,p] = dircontent(pMWT{m});

                    % move files except for .png .set .summary .blobs
                    i = ~regexpcellout(fn,'(.png)|(.set)|(.summary)|(.blobs)');
                    if sum(i) > 0
                        display(sprintf('***moving %d analysis files',sum(i)));
                        fn = fn(i);
                        pS = pf(i);
                        pNew = cellfun(@fileparts,...
                            regexprep(pS,pDataHome,pAnalysisStore),...
                            'UniformOutput',0);
                        cellfun(@movefile,pS,pNew);
                    end

                    % zip file to store
                    display '***zipping MWT file';
                    zip(regexprep(pMWT{m},pDataHome,pDone),pMWT{m})             
                    % delete unzipped file
                    rmdir(pMWT{m},'s');

                end
           end

           % if group folder is empty, delete
           if isdir(pGroup{g})
                [fn,pf,MWTfn, pMWT] = dircontent(pGroup{g});
                if isempty(fn) == 1; rmdir(pGroup{g},'s'); end
           end
        end  
       
    end

    %% delete exp folder
    [f,p] = dircontent(pExp{x});
    if isempty(f) == 1; rmdir(pExp{x},'s'); 
    else
        warning('exp folder still contain stuff');
    end
end


% report complete
display ' ';
display '**** PROGRAM COMPLETE *****';












