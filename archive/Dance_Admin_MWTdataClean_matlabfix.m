%% OBJECTIVE:
% Merge matlab files and analysis files


%% PATHS
pHome = '/Volumes/ParahippocampalGyrus/MWT_Data_Org/MWT_AnalysisFiles/MWT_Data_Analysis_store_central files';
pSource = '/Volumes/ParahippocampalGyrus/MWT_Data_Org/MWT_AnalysisFiles/MWT_Data_Analysis_store';
addpath('/Users/connylin/Dropbox/MATLAB/Functions_Developer');

%% CHANGE FOLDER NAMES
% names = '( Mat Analysis)|( MatlabAnalysis)';
[~,~,expnameHome,pExpHome] = dircontent(pHome);
[~,~,expnameA,pExpA] = dircontent(pSource);

%% move files
for x = 1:numel(pExpA)
    
    pOld = pExpA{x};
    [~,n] = fileparts(pOld);
    display(sprintf('process: %s',n));
    
    i = find(ismember(expnameHome,expnameA{x}));
     if numel(i) ==1
     elseif isempty(i) == 1
         mkdir(regexprep(pOld, pSource, pHome))
     end
    %% go to MWT files
    [name1,p1,groupname,pGroup] = dircontent(pOld);
    if numel(name1) > numel(groupname)
        j = ismember(name1,groupname);
        pT = p1(~j);
        pN = regexprep(pT,pSource, pHome);
        cellfun(@movefile,pT,pN);
    end
    
    for g = 1:numel(pGroup)
        [name2,p2,mwtname,pMWT] = dircontent(pGroup{g});
        [~,n] = fileparts(pGroup{g});
        display(sprintf('*group: %s',n));
        p = regexprep(pGroup{g},pSource,pHome);
        if isdir(p) == 0; mkdir(p); end
        if numel(name2) > numel(mwtname)
            if isempty(mwtname)
                pT = p2;
                pN = regexprep(pT,pSource, pHome);
                cellfun(@movefile,pT,pN);
            else 
                k = ~ismember(name2,mwtname);
                pT = p2(k);
                pN = regexprep(pT,pSource, pHome);
                cellfun(@movefile,pT,pN);
            end
        end
        
        for m = 1:numel(pMWT)
            [~,n] = fileparts(pMWT{m});
            display(sprintf('**mwt: %s',n));
            [fn,pf] = dircontent(pMWT{m});
            p = regexprep(pMWT{m},pSource,pHome);
            if isdir(p) == 0; mkdir(p); end
                pT = pf;
                pN = regexprep(pT,pSource, pHome);
                cellfun(@movefile,pT,pN);

            if isempty(dircontent(pMWT{m})) == 1; 
                rmdir(pMWT{m},'s'); 
            else
                error('folder not empty');
            end
        end
        
        if isempty(dircontent(pGroup{g})) == 1; 
            rmdir(pGroup{g},'s'); 
            else
                error('folder not empty');
        end     
        
    end
    
    if isempty(dircontent(pExpA{x})) == 1; 
        rmdir(pExpA{x},'s'); 
    else
        error('folder not empty');
    end
    
end

display '**** PROGRAM COMPLETE *****';
return






% End













