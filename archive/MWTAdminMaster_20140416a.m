function [varargout] = MWTAdminMaster(varargin)
%% MWT Admin Master
% 'Get new MWT files'
% [varargout] = MWTAdminMaster(option,drivefrom,driveto)


%% OPTIONS
optionlist = {'off';
    'Data structure';
    'Experiment set summary';
    'Get new MWT files';
    'Get missing MWT zip files';
    'Get missing MWT and MWT zip files'
    };

%% VARARGIN
pList = varargin{1};
% deal with option
switch nargin
    case 0 % if no option given
        [option] = chooseoption(optionlist);
    
    
    case 1
        if ischar(varargin{1}) ==1
            i = ismember(varargin{1},optionlist);
            if sum(i) ==1
                [option] = chooseoption(optionlist); 
            end
        elseif isstruct(varargin{1}) == 1
            MWTSet = varargin{1};
            pData = MWTSet.pData;
            
%             pSave = MWTSet.pSaveA;
            [option] = chooseoption(optionlist); 
        end
end



%% DEAL WITH OPTIONS

switch option
    case 'off'
         varargout{1} = {};
         return
    
         
    case 'Data structure'  
        % pData path
        if exist('pData','var') ==0
            display('Cut and paste data path here')
            pData = input(': ','s');
        end
        [Summary] = MWTAdminMaster_DataStructure(pData);
        varargout{1} = Summary;
    
    case 'Experiment set summary'
        % pData path
        if exist('pList.pData','var') ~=7
            display('Cut and paste data path here')
            pData = input(': ','s');
        else
            pData = pList.pData;
        end
        if exist('pList.pSaveA','var') ~=7
            display('Cut and paste save path here')
            pSave = input(': ','s');
        else
            pSave = pList.pSave;
        end
        [MWTDataTable] = MWTDataBase_searchAll(pData);
        %%
        
        
        
        
        
        
        
        %%
        [Report] = MWTAdminMaster_ExpSum(MWTfG,pSave);
        varargout{1} = Report;
        
    case 'Get new MWT files'
        % 'Get new MWT files'
        % [varargout] = MWTAdminMaster(option,drivefrom,driveto)
        [pSource,pDesg] = selectdrive; 
%         homepath = varargin{2};
%         storedrive = varargin{3};
        [pathcopied] = CopyNewMWTFiles(pSource,pDesg);
        varargout{1} = pathcopied;
        
    case 'Get missing MWT zip files'
        
        [pSource,pDesg] = selectdrive;         
%         pSource = varargin{2};
%         pDesg = varargin{3};
        CopyMissMWTZipFiles(pSource,pDesg);
         varargout{1} = 'Completed';
        
    case 'Get missing MWT and MWT zip files';
        pSource = varargin{2};
        pDesg = varargin{3};
        CopyMissMWTandZipFiles(pSource,pDesg);
        varargout{1} = 'Completed';
        
end
varargout{1} = option;
end



%% Subfunction
function [varargout] = MWTAdminMaster_DataStructure(pData)
%% get data structure
% look at database
    [A] = MWTDataBaseMaster(pData,'GetStdMWTDataBase');
    Expfn = A.ExpfnD;
    pExp = A.pExpfD;

    %% get run condition
    a = celltakeout(regexp(A.ExpfnD,'_','split'),'split');
    RC = a(:,3); 
    RCU = unique(RC);
    
    Summary = unique(RC);
    D = {}; S = {};
    for x = 1:size(Summary,1)
        i = ismember(RC,Summary{x});
        Summary{x,2} = Expfn(i);
        ExpfnT = Expfn(i);
        Summary{x,3} = pExp(i);
        pExpT = pExp(i);
        % get group folder
        e = {};
        for y = 1:size(Summary{x,2},1)
            [~,~,f,pf] = dircontent(Summary{x,3}{y,1});
            i = ~ismember(f,{'MatlabAnalysis'});
            f = f(i);
            pf = pf(i);
            Summary{x,2}(y,2:numel(f)+1) = f';
            
            %% get MWT folder count
            g = {};
            for z = 1:numel(pf)
                % check if folder is a MWT folder
                [mwtf,pmwt] = dircontent(pf{z},'Option','MWTall');
                g{z,1} = f{z};
                g{z,2} = numel(mwtf);
            end
            e = [repmat(ExpfnT(y),z,1),g];
            D = [D;e];
        end
        S = [S;[repmat(RCU(x),size(D,1),1),D]];
    end
    %% output
    varargout{1} = Summary;
    varargout{2} = S;
end

%% CHECK MWT FILE INTEGRITY 
% if strcmp(option,'checkMWTfileIntegrity') == 1
%     %% CHECK INTEGRITY OF MWT FILES
%     % prepare pMWTf input for validation
%     display 'Validating MWT folder contents...';
%     % check for files
%     fname = '*.blobs';
%     a = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
%         cellfunexpr(pMWT,fname),'UniformOutput',0))); % get numer of files
%     fname = '*.summary';
%     b = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
%         cellfunexpr(pMWT,fname),'UniformOutput',0))); % get numer of files
%     fname = '*.set';
%     c = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
%         cellfunexpr(pMWT,fname),'UniformOutput',0))); % get numer of files
%     % fname = '*.png';
%     % d = cellfun(@numel,(cellfun(@dircontentext,paths,...
%     %     cellfunexpr(paths,fname),'UniformOutput',0))); % get numer of files
% 
% 
%     %% MARK BAD MWT FILES
%     [r,c] = find([a,b,c]==0);
%     if isempty(r)==0;
%         % make pBadFile folder
%         p = fileparts(fileparts(fileparts(fileparts(pMWT{1}))));
%         filename = 'MWT_BadFiles';
%         pBadFiles = [p,'/',filename];
%         if exist(pBadFiles,'dir')~=7
%             mkdir(p,filename)
%         end
%         pData = p;
% 
%         p = pMWT(r); % % find files with missing MWT files
%         % mark bad mwt folder
%         % make new name
%         pmwark = {};
%         for x = 1:numel(p)
%             pmark{x,1} = [p{x},'_missingchorintput'];
%         end
% 
%         % copy file
%         for x = 1:numel(p)
%            movefile(p{x},pmark{x});
%         end
%     %     a = cellfun(@strrep,p,cellfunexpr(p,pData),cellfunexpr(p,pBadFiles),...
%     %         'UniformOutput',0); % replace pData path with pBadFiles paths
%     %     makemisspath(cellfun(@fileparts,a,'UniformOutput',0)); % make folders
%     %     cellfun(@movefile,p,a); % move files
%         str = '[%d] bad MWT files moved out of Analysis folder';
%         display(sprintf(str,numel(a)));
%         pMWT = pMWT(~r); % update path
%     else
%         display 'All MWT files contain .blob, .summary & .set';
%     end
%     
%     
% end
% 

%% CHECK EXPERIMENT FOLDERNAME
% 
% if strcmp(CheckStatus,'Check') ==1
% 
%     % STEP2A: CHECK EXPERIMENT FOLDER NAMES
%     [fn,p] = dircontent(pData);
% 
%     fn1 = fn;
%     i = ~regexpcellout(fn1,...
%         '\<\d{8}[A-Z][_][A-Z]{2}[_]\d{1,}[s]\d{1,}[x]\d{1,}[s]\d{1,}[s]');
%     while sum(i)~=0
%         k = find(i);
%         display 'Some experiments were not named correctly';
%         display 'rename to this format: 20131008B_SJ_100s30x10s10s';
% 
%         for x = 1:numel(k)
%             display(sprintf('change [ %s ] to',fn1{k(x)}));
%             fn1{k(x)} = input(': ','s');
%         end
%         i = ~regexpcellout(fn1,...
%         '\<\d{8}[A-Z][_][A-Z]{2}[_]\d{1,}[s]\d{1,}[x]\d{1,}[s]\d{1,}[s]');
%     end
% 
% 
%     i = find(~strcmp(fn,fn1));
%     p1 = p;
%     for x = 1:numel(i)
%        fn2 = fn1{i(x)};
%        p2 = p1{i(x)};
%        newpath = [fileparts(p2),'/',fn2];
%        movefile(p2,newpath);
%     end
% 
% 
% 
%     % STEP2B: CHECK EXPERIMENT GROUPS
%         display 'checking if MWT folders are grouped...';
%         [A] = MWTDataBaseMaster(pData,'GetStdMWTDataBase');
%         Gfn = A.GfnD; pGf = A.pGfD;
%         % check if MWT folder is below
%         i = regexpcellout(Gfn,'\<\d{8}[_]\d{6}\>');
%         [p,~] = cellfun(@fileparts,pGf,'UniformOutput',0);
%         [~,fn] = cellfun(@fileparts,p,'UniformOutput',0);
%         fn = unique(fn(i));
%         p = unique(p(i));
%         if isempty(p)==0
%            display ' ';
%            display(sprintf('[%d] experiments not grouped',numel(fn))); 
%            disp(fn);
%            error 'please group MWT folders under group folders';
%         end
% 
% 
%     % CHECK AND TRANSFER BAD GROUP NAMES TO BAD NAME FOLDER
%         gnameU = unique(Gfn);
%         n = 1; k = [];
%         for g = 10:10:numel(gnameU)
%             if g+10 > numel(gnameU)
%                 makedisplay(gnameU(n:numel(gnameU),1))
% 
%             else
%                 makedisplay(gnameU(n:g,1))
%             end
%             n = g+1;
%             display('select problem group name, press [Enter] if all correct')
%             i = input(': ','s');
%             if isempty(i) ==0
%                 k = [k,str2num(i)+g-10];
%             end
%         end
% 
%     % display problem folder names
%     if isempty(k) ==0
%         display ' ';
%         display 'Problem group folder names:';
%         display(gnameU(k));
% 
%         % find problem folder path
%         i = ismember(Gfn, gnameU(k));
%         p = pGf(i);
%         fn = Gfn(i);
%         
% %         % move to grouping folder
% %         % find experiment folder
% %         [p1,~] =  cellfun(@fileparts,p,'UniformOutput',0);
% %         [~,f1] =  cellfun(@fileparts,p1,'UniformOutput',0);
% %         pd = [fileparts(pData),'/MWT_BadGroupName'];
% %         if exist(pd,'dir') ~=7
% %             mkdir(pd);
% %         end
% %         for x = 1:numel(p1)
% %             [p,fn] = fileparts(p1{x});
% %             copyfile(p1{x},[pd,'/',fn]);
% %         end
%         error 'Bad group names found, correct and run again';
%         disp(unique(fn));
%     end
% end
% 
% 
% 

%% STEP2C: CHECK ZIP BACKUP
% switch zip
%     case 'on'
%         p = fileparts(pProgram);
%         filename = 'MWT_ZipBackUp';
%         zipdir = [p,'/',filename];
%         if exist(zipdir,'dir') ~= 7
%             mkdir(p,filename);
%         end
% 
%         % check dir in zip
%         [fnzip,pzip] = dircontent(zipdir);
%         [fne,pe] = dircontent(pData);
%         % find experiment without backup
%         i = ~ismember(fne,fnzip);
%         fne = fne(i);
%         pe = pe(i);
%         if isempty(fne)==0
%             display ' ';
%             display(sprintf('Backing up [%d] exp folders to [%s]',...
%                 numel(fne),filename));
%             display 'DO NOT stop this process';
% 
%             % create group folders
%             % find MWT folders
%             [fmwt,pmwt] = cellfun(@dircontent,pe,cellfunexpr(pe,'Option'),...
%                 cellfunexpr(pe,'MWT'),'UniformOutput',0);
%             pmwt = celltakeout(pmwt); fmwt = celltakeout(fmwt);
% 
%             % find group folders
%             [pg,~] = cellfun(@fileparts,pmwt,'UniformOutput',0);
%             pg = unique(pg);
%             p = strrep(pg,pData,zipdir);
%             i = ~cellfun(@exist,p,cellfunexpr(p,'dir'));
%             cellfun(@mkdir,p(i));
% 
% 
%             % find mwt folders
%             [fnmwt,pmwt] = cellfun(@dircontent,pg,cellfunexpr(pg,'Option'),...
%                 cellfunexpr(pg,'MWT'), 'UniformOutput',0);
%             pmwt = celltakeout(pmwt); fnmwt = celltakeout(fmwt);
%             % zip MWT files
%             for mwt = 1:numel(pmwt)
%                 [f,p] = dircontent(pmwt{mwt});
%                 p = celltakeout(p); f = celltakeout(f);
%                 i = regexpcellout(f,'(.dat)|(.summary)|(.png)|(.set)|(.blobs)');
%                 k = regexpcellout(f,...
%                     '(evan.dat)|(drunkposture.dat)|(shanespark.dat)|(swanlake.dat)|(tapN_30.dat)');
%                 i(k) = false;
%                 zipfilename = strrep(pmwt{mwt},pData,zipdir);
%                 filelist = p(i);
%                 display(sprintf('zipping [%s]...',fnmwt{mwt}));
%                 zip(zipfilename,filelist);
%             end
% 
% 
%         end
%     case 'off'
% end


%% archive codes
% 
% 
% %% program status
% programstatus = 'Coding';
% 
% 
% %% path [coding only]
% switch programstatus
%     case 'Coding'
%         pFun = '/Users/connylinlin/Documents/Programming/MATLAB/MATLAB MWT Projects/MWT009_DanceReview';
%         pFunS = [pFun,'/SupportFunction'];
%         addpath(pFunS);
% end
% 
% %% OPTIONS
% OPT = {'Get new MWT experiments';
%     'Check control groups';
%     'Read Set Files'};
% disp(makedisplay(OPT))
% 
% 
% 
% %% READ SET FILES
% dircontent(cd);
% a = fileread('test.set')
% 
% 
% 

%% GET NEW MWT EXPERIMENTS FROM FLAME
% % get paths
% [fn,p] = dircontent('/Volumes'); % find a list of hard drive
% 
% % select data source drive
% display ' ';
% disp(makedisplay(fn))
% i = input('Choose data source drive: ');
% pSource = p{i};
% 
% 
% % select destination drive
% display ' ';
% disp(makedisplay(fn))
% i = input('Choose data destination drive: ');
% pDest = p{i};
% 
% % find mwt filesin source drive
% [Source] = MWTDataBaseMaster(pSource,'FindAllMWT');
% 
% % find mwt files in dest drive
% [Dest] = MWTDataBaseMaster(pDest,'FindAllMWT');
% 
% 
% % reporting
% [~,Destname] = fileparts(pDest);
% display(sprintf('%s: [%d] files found',Destname,numel(Dest.MWTfn)));
% [~,Sourcename] = fileparts(pSource);
% display(sprintf('%s: [%d] files found',Sourcename,numel(Source.MWTfn)));
% 
% % compare mwt in destination drive
% [a,newfileind,~] = setxor(Source.MWTfn,Dest.MWTfn);
% display(sprintf('[%d] unique MWT files in [%s] not found in [%s]',...
%     numel(unique(Source.MWTfn(newfileind))),Sourcename,Destname));
% disp(Source.MWTfn(newfileind));
% % disp(Source.pMWTf(newfileind))
% p = Source.pMWTf(newfileind)
% 
% 
% 
% 
% 
% %% find common MWT folder
% [expfolderpath,groupfolder] = cellfun(@fileparts,cellfun(...
%     @fileparts,Source.pMWTf(i),...
%     'UniformOutput',0),'UniformOutput',0);
% [~,expfoldername] = cellfun(@fileparts,expfolderpath,'UniformOutput',0);
% expfoldernameU = unique(expfoldername);
% 
% %% check exp name
% expnameval = regexpcellout(expfoldername,...
%     '\<(\d{8})[A-Z][_][A-Z]{2}[_](\d{1,})[s](\d{1,})[x](\d{1,})[s](\d{1,})[s]');
% expcopy = unique(expfolderpath(...
%     ismember(expfoldername,expfoldername(expnameval))));
% [p,fn] = cellfun(@fileparts,expcopy,'UniformOutput',0);
% display 'below experiments will be copied';
% disp(fn);
% %%
% display 'below experiments folders are problematic:';
% i = ismember(expfoldername,expfoldername(~expnameval));
% expproblem = unique(expfolderpath(i));
% display(expproblem);
% %%
% p = expfolderpath(~expnameval)
% cd(p{end})
% 
% 
% %% check group name
% 
% % copy

















