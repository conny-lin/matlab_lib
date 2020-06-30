function [Output] = MWTDataBaseMaster(HomePath,option)
switch option
    case 'GetStdMWTDataBase'
        display 'Searching for Experiment folders...';
        [~,~,fn,p] = dircontent(HomePath);
        expnameidentifider = '^\d{8}[A-Z][_]([A-Z]{2})[_](.){1,}';
        i = not(cellfun(@isempty,regexp(fn,expnameidentifider,'match')));
        pNonExpf = p(not(i)); NonExpfn = fn(not(i));
        pExpfD = p(i); ExpfnD = fn(i);
        str = '%d [%d standardized] experiment folders';
        display(sprintf(str,numel(fn),sum(i)));
        Output.pExpfD = pExpfD; Output.ExpfnD = ExpfnD;
        Output.NonExpfn = NonExpfn; Output.pNonExpf = pNonExpf;


        % pGfD and GfnD
        display 'Searching for Group folders...';
        [~,~,fn,p] = cellfun(@dircontent,pExpfD,'UniformOutput',0);
        fn = celltakeout(fn,'multirow');
        i = not(celltakeout(regexp(fn,'MatlabAnalysis'),'singlenumber'));
        Gfn = fn(i);
        p = celltakeout(p,'multirow');
        pGf = p(i);
        [fn,p,~,~] = cellfun(@dircontent,pGf,'UniformOutput',0);
        empty = cellfun(@isempty,fn); % see which group folder is empty
        pGfD = pGf(not(empty));
        GfnD = Gfn(not(empty));
        if sum(empty)>1; 
            pGfproblem = pGf(empty); 
            display '> The following folders are empty:';
            disp(Gfn(empty));
        end
        str = '> %d folders found under Exp folders';
        display(sprintf(str,numel(Gfn)));
        str = '> %d [%d unique] Group folders';
        display(sprintf(str,numel(GfnD),numel(unique(GfnD))));
        Output.GfnD = GfnD; Output.pGfD = pGfD;
        
        % pMWTfD & MWTfnD
        display 'Searching for MWT folders...';
        fn = celltakeout(fn(not(empty)),'multirow');
        p = celltakeout(p(not(empty)),'multirow');
        mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
        pMWTf = p(mwt); MWTfn = fn(mwt);
        str = '> %d [%d unique] MWT folders';
        display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));
        Output.pMWTf = pMWTf; Output.MWTfn = MWTfn;
        
        % Zip files?
        display 'Searching for zipped files...';
        zip = logical(celltakeout(regexp(fn,'.zip'),'singlenumber'));
        if sum(zip)>1; display 'zipped files found'; 
            pZipf = p(zip); Zipfn = fn(zip);
            disp(Zipfn); 
            str = '> %d [%d unique] zip files';
            display(sprintf(str,numel(Zipfn),numel(unique(Zipfn))));
            Output.pZipf = pZipf; Output.Zipfn = Zipfn;
        else
            display '> No zip files found.';
        end
    case 'GetExpTargetInfo'
        pExpfD = HomePath;
        % pGfD and GfnD
        display 'Searching for Group folders';
        [~,~,fn,p] = cellfun(@dircontent,pExpfD,'UniformOutput',0);
        fn = celltakeout(fn,'multirow');
        i = not(celltakeout(regexp(fn,'MatlabAnalysis'),'singlenumber'));
        Gfn = fn(i);
        p = celltakeout(p,'multirow');
        pGf = p(i);
        [fn,p,~,~] = cellfun(@dircontent,pGf,'UniformOutput',0);
        empty = cellfun(@isempty,fn); % see which group folder is empty
        pGfD = pGf(not(empty));
        GfnD = Gfn(not(empty));
        if sum(empty)>1; 
            pGfproblem = pGf(empty); 
            display 'the following folders are empty:';
            disp(Gfn(empty));
        end
        str = '%d folders found under Exp folders';
        display(sprintf(str,numel(Gfn)));
        str = '%d [%d unique] Group folders';
        display(sprintf(str,numel(GfnD),numel(unique(GfnD))));
        Output.GfnT = GfnD; Output.pGfT = pGfD;
        
        % pMWTfD & MWTfnD
        display 'Searching for MWT folders';
        fn = celltakeout(fn(not(empty)),'multirow');
        p = celltakeout(p(not(empty)),'multirow');
        mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
        pMWTf = p(mwt); MWTfn = fn(mwt);
        str = '%d [%d unique] MWT folders';
        display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));
        Output.pMWTfT = pMWTf; Output.MWTfnT = MWTfn;
        
        % Zip files?
        display 'Searching for zipped files';
        zip = logical(celltakeout(regexp(fn,'.zip'),'singlenumber'));
        if sum(zip)>1; display 'zipped files found'; 
            pZipf = p(zip); Zipfn = fn(zip);
            disp(Zipfn); 
            str = '%d [%d unique] zip files';
            display(sprintf(str,numel(Zipfn),numel(unique(Zipfn))));
            Output.pZipf = pZipf; Output.Zipfn = Zipfn;
        else
            display 'No zip files found.';
        end
    case 'GetSingleExpInfo'
        pExpfD = HomePath;
        % pGfD and GfnD
        display 'Searching for Group folders';
        [~,~,fn,p] = dircontent(pExpfD);
        fn = celltakeout(fn,'multirow');
        i = not(celltakeout(regexp(fn,'MatlabAnalysis'),'singlenumber'));
        Gfn = fn(i);
        p = celltakeout(p,'multirow');
        pGf = p(i);
        [fn,p,~,~] = cellfun(@dircontent,pGf,'UniformOutput',0);
        empty = cellfun(@isempty,fn); % see which group folder is empty
        pGfD = pGf(not(empty));
        GfnD = Gfn(not(empty));
        if sum(empty)>1; 
            pGfproblem = pGf(empty); 
            display 'the following folders are empty:';
            disp(Gfn(empty));
        end
        str = '%d folders found under Exp folders';
        display(sprintf(str,numel(Gfn)));
        str = '%d [%d unique] Group folders';
        display(sprintf(str,numel(GfnD),numel(unique(GfnD))));
        Output.GfnT = GfnD; Output.pGfT = pGfD;
        
        % pMWTfD & MWTfnD
        display 'Searching for MWT folders';
        fn = celltakeout(fn(not(empty)),'multirow');
        p = celltakeout(p(not(empty)),'multirow');
        mwt = logical(celltakeout(regexp(fn,'\<(\d{8})[_](\d{6})\>'),'singlenumber'));
        pMWTf = p(mwt); MWTfn = fn(mwt);
        str = '%d [%d unique] MWT folders';
        display(sprintf(str,numel(MWTfn),numel(unique(MWTfn))));
        Output.pMWTfT = pMWTf; Output.MWTfnT = MWTfn;
        
        % Zip files?
        display 'Searching for zipped files';
        zip = logical(celltakeout(regexp(fn,'.zip'),'singlenumber'));
        if sum(zip)>1; display 'zipped files found'; 
            pZipf = p(zip); Zipfn = fn(zip);
            disp(Zipfn); 
            str = '%d [%d unique] zip files';
            display(sprintf(str,numel(Zipfn),numel(unique(Zipfn))));
            Output.pZipf = pZipf; Output.Zipfn = Zipfn;
        else
            display 'No zip files found.';
        end

    case 'FindAllMWT'
        % code based on
            % [b] = getalldir(home); 
            % [Output] = dircontentmwtall(HomePath);
        %display 'Searching for MWT in all drives, this will take a while...';         
        a = cellfun(@genpath,HomePath,'UniformOutput',0);
        paths = regexpcellout(a,pathsep,'split');
        paths(cellfun(@length,paths)<1) = []; % get rid of cell has zero lengh
        paths = paths';
        [~,fn] = cellfun(@fileparts,paths, 'UniformOutput',0);
        search = '(\<(\d{8})[_](\d{6})\>)';
        k = regexpcellout(fn,search);
        Output.pMWTf = paths(k);
        Output.MWTfn = fn(k);
  
        
        
        
    otherwise
end