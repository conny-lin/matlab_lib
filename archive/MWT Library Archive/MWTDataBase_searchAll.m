function [varargout] = MWTDataBase_searchAll(pData)
 
%% instruction
% revised - 20140420


%% look for previous database
[~,p] = dircontent(pData,'MWTDatabase.mat');
if isempty(p) == 0
    display 'Searching for all directory under path';
    display 'new search will take a while, load previous search result?';
    option = input('1-yes, 2-no: ');
    if option == 1
        load(p{1}); 
        varargout{1} = MWTDatabase;
        return
    end
else
    display ('no previous MWTDatabase found');
    option = 2;
end



%% get new database
if option == 2
    
    % search for folders
    display('searching for folder under each folder, please wait...');
    [pf,fn] = getalldir(pData);
    display('overwrite previous search result?')
    overwriteoption = input('1-yes, 2-no: ');
   
    % make table
    A = table(cell(size(fn)),fn,pf,'VariableNames',...
        {'type','foldername','folderpath'});
    A = sortrows(A,3);
    
    
    % find mwt level folders 
    [a,~] = cellfun(@fileparts,A.folderpath,'UniformOutput',0);
    A.groupfolderpath = a;
    
    % find group level folders 
    [a,b] = cellfun(@fileparts,A.groupfolderpath,'UniformOutput',0);
    A.groupfolder = b;
    A.expfolderpath = a;
    
    
    % find exp level folders 
    [a,b] = cellfun(@fileparts,A.expfolderpath,'UniformOutput',0);
    A.expfolder = b;
    A.datafolderpath = a;
    
        
    % find data level folders 
    [~,b] = cellfun(@fileparts,A.datafolderpath,'UniformOutput',0);
    A.datafolder = b;
    
    % identify mwt folder
    i = regexpcellout(A.foldername,'\<(\d{8})[_](\d{6})\>');
    A.type(i,:) = {'MWT'};
    
    
    
    % identify experiment folder
    expidentifier = '^\d{8}[A-Z][_]([A-Z]{2})[_](.){1,}';
    A.type(regexpcellout(A.foldername,expidentifier),:) = {'Exp'};
    
   
    
    % identify pData folder
    [~,n] = fileparts(pData);
    A.type(regexpcellout(A.foldername,n),:) = {'DataBase'};

    % identify group folder name under valid exp name
    A.type(regexpcellout(A.groupfolder,expidentifier),:) = {'Group'};
    
    % label bad MWT folders
    A.type(regexpcellout(A.foldername,'\<(\d{8})[_](\d{6})[_]'),:) =...
        {'MWT_bad'};
    

    % get rid of Matlab analysis folder
    A.type(regexpcellout(A.foldername,'\<Matlab'),:) =...
        {'Matlab'};
    

    %% manually check empty types
    i = find(cellfun(@isempty,A.type));
    if isempty(i) == 0
        display ' ';
        display 'can not assign some paths to known groups';
        display ('do you wish to address problem paths manually? ');
        opt = input('1-yes, 2-no, skip this: ');
        if opt == 1
            for x = 1:numel(i)
                display ' ';
                display(sprintf('[%d/%d] problem folder path:',x,numel(i)));
                disp(A.folderpath{i(x)})
                if input('1-stop, any key-continue: ') == 1
                    return
                end
            end
            k = input('have all problem paths been deleted(1) or corrected(2)? ');
            if k == 1
                A(i,:) = [];
            else
                error 'please re-run the program to update';
            end
        end    
    end
   
    %% write MWTDatabase
    MWTDatabase = A;
    varargout{1} = MWTDatabase;
    if overwriteoption == 1
        cd(pData); save('MWTDatabase.mat','MWTDatabase');
    end      
end


