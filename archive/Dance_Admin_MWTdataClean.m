%% OBJECTIVE:
% clean MWT data: keep only .png .set .summary .blobs

%% PATHS
pDataHome = '/Volumes/ParahippocampalGyrus/MWT_1_Data_Cleaning';
pAnalysisStore = '/Volumes/ParahippocampalGyrus/MWT_Data_Analysis_store';
pMatStore = '/Volumes/ParahippocampalGyrus/MWT_MatAnalysis_Data';
pZipBackup = '/Volumes/ParahippocampalGyrus/MWT_0_Data_Temp_Backup';
addpath('/Users/connylin/OneDrive/MATLAB/Functions_Developer');

%% GET A LIST OF MWT FOLDERS
[Expfn, pExp] = dircontent(pDataHome);

MWTDatabase = struct;
MWTDatabase.exp_name = {};
MWTDatabase.group_name = {};
MWTDatabase.MWT_folder_name = {};
MWTDatabase.pMWT = {};
MWTDatabase.pExp = {};

for x = 1:numel(Expfn)
   display(sprintf('processing exp: %s',Expfn{x}));
   [Groupfn, pGroup] = dircontent(pExp{x});
   for g = 1:numel(Groupfn)
       display(sprintf('processing group: %s',Groupfn{g}));
       
       if strcmp(Groupfn{g},'MatlabAnalysis')
           display('store matlab analysis data');
           % rename file and store else where
           destination = [pMatStore,'/',Expfn{x},' Mat Analysis'];
           if isdir(destination) == 0; mkdir(destination); end
           copyfile(pGroup{g},destination,'f');
           rmdir(pGroup{g},'s');
           
       else
           if isdir(pGroup{g}) ==1
                [MWTfn, pMWT] = dircontent(pGroup{g});
                n = numel(MWTfn);
                MWTDatabase.MWT_folder_name(end+1:end+n,1) = MWTfn;
                MWTDatabase.group_name(end+1:end+n,1) = repmat(Groupfn(g),n,1);
                MWTDatabase.exp_name(end+1:end+n,1) = repmat(Expfn(x),n,1);
                MWTDatabase.pMWT(end+1:end+n,1) = pMWT;
                MWTDatabase.pExp(end+1:end+n,1) = repmat(pExp(x),n,1);
           else % if it is a file not director
               destination = [pMatStore,'/',Expfn{x},' Mat Analysis'];
               if isdir(destination) == 0; mkdir(destination); end
               movefile(pGroup{g}, destination)
           end

            clear MWTfn pMWT
       end
   end
end

%% CREATE ZIP BACKUP
% display ' '; display('** Zipping exp files for backup **');
% pExp = unique(MWTDatabase.pExp);
% [~,ExpNames] = cellfun(@fileparts,pExp,'UniformOutput',0);
% for x = 1:numel(pExp)
%     display(sprintf('zipping: %s',ExpNames{x}));
%     pExpNew = regexprep(pExp{x},pDataHome,pZipBackup);
%     zip(pExpNew,pExp{x});
% end


%% CREATE ZIP BACKUP, CLEAN, MOVE ANALYSIS RESULTS, ZIP
display ' '; display '** Cleaning starts **';
[Expfn, pExp] = dircontent(pDataHome);
for x = 1:numel(Expfn)
    display ' ';
   display(sprintf('* processing exp: %s',Expfn{x}));
   
   display(sprintf('zipping: %s',Expfn{x}));
   pExpNew = regexprep(pExp{x},pDataHome,pZipBackup);
   zip(pExpNew,pExp{x});
   
   [Groupfn, pGroup] = dircontent(pExp{x});
   
   for g = 1:numel(Groupfn)
       display(sprintf('-- processing group: %s',Groupfn{g}));
          
        [MWTfn, pMWT] = dircontent(pGroup{g});
        for x = 1:numel(pMWT)
            [~,mwtfn] = fileparts(pMWT{x});
            display(sprintf('cleaning [%d/%d] MWT folder: %s', ...
                x,numel(pMWT),mwtfn));
            % get content
            [fn,pf] = dircontent(pMWT{x});
            % move files except for .png .set .summary .blobs
            i = ~regexpcellout(fn,'(.png)|(.set)|(.summary)|(.blobs)');
            if sum(i) > 0
                display(sprintf('moving %d analysis files',sum(i)));
                fn = fn(i);
                pf = pf(i);

                newfolderpath = regexprep(pMWT{x},pDataHome,pAnalysisStore);
                if isdir(newfolderpath) == 0; mkdir(newfolderpath); end

                cellfun(@movefile,pf, cellfunexpr(pf,newfolderpath));
                %        for f = 1:numel(fn)
                %            movefile(pf{f}, newfolderpath)
                %        end
            end
            % zip file
            zip(pMWT{x},pMWT{x})
            % delete unzipped file
            rmdir(pMWT{x},'s');
        end
   end
end



%% CLEAN, MOVE ANALYSIS RESULTS, ZIP
% display ' '; display '** Cleaning starts **';
% pMWT = MWTDatabase.pMWT;
% for x = 1:numel(pMWT)
%     [~,mwtfn] = fileparts(pMWT{x});
%     display(sprintf('cleaning [%d/%d] MWT folder: %s', ...
%         x,numel(pMWT),mwtfn));
%     % get content
%     [fn,pf] = dircontent(pMWT{x});
%     % move files except for .png .set .summary .blobs
%     i = ~regexpcellout(fn,'(.png)|(.set)|(.summary)|(.blobs)');
%     if sum(i) > 0
%         display(sprintf('moving %d analysis files',sum(i)));
%         fn = fn(i);
%         pf = pf(i);
% 
%         newfolderpath = regexprep(pMWT{x},pDataHome,pAnalysisStore);
%         if isdir(newfolderpath) == 0; mkdir(newfolderpath); end
% 
%         cellfun(@movefile,pf, cellfunexpr(pf,newfolderpath));
%         %        for f = 1:numel(fn)
%         %            movefile(pf{f}, newfolderpath)
%         %        end
%     end
%     % zip file
%     zip(pMWT{x},pMWT{x})
%     % delete unzipped file
%     rmdir(pMWT{x},'s');
% end
% 
% End
display '**** PROGRAM COMPLETE *****';












