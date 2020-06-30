function [varargout] = MWTAdminMaster(varargin)
%% MWT Admin Master
% 'Get new MWT files'
% [varargout] = MWTAdminMaster(option,drivefrom,driveto)

%% VARARGOUT
varargout{1} = {};


%% VARARGIN
pList = varargin{1};


%% OPTIONS
optionlist = {'off';
%     'Experiment set summary';
    'database summary';
    'Data structure';
    'Get new MWT files';
    'Get missing MWT zip files';
    'Get missing MWT and MWT zip files'
    };


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
            [option] = chooseoption(optionlist); 
        end
end



%% OPTION SWITCH BOARD

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
    
    case 'database summary'
        
        %% pData path
        names = fieldnames(pList);

        if sum(strcmp(names,'pData')) ==1
            pData = pList.pData;
        else
            display('Cut and paste data path here')
            pData = input(': ','s');
        end
        if sum(strcmp(names,'pSave')) ==1
            pSave = pList.pSave;
        else
            display('Cut and paste save path here')
            pSave = input(': ','s');      
        end
        
        [A] = MWTDataBase_searchAll(pData);

        groupnames = unique(A.foldername(regexpcellout(A.type,'Group'),:));
        expnames = unique(A.foldername(regexpcellout(A.type,'Exp'),:));
        mwtnames = unique(A.foldername(regexpcellout(A.type,'MWT'),:));
        mwtnamesval = unique(A.foldername(regexpcellout(A.type,'MWT\>'),:));
        analysisnames = unique(A.foldername(regexpcellout(A.type,'Matlab'),:));
        
        %% get only mwt folders
        B = A(regexpcellout(A.type,'MWT'),:);
        display(sprintf('%d MWT folders found',size(B,1)));
        %% make summary
        T = table(B.expfolder,'VariableNames',{'Experiment'});
        expn = char(T.Experiment);
        T.ExpDate = expn(:,1:8);
        T.Tracker = expn(:,9:9);
        T.Expter = expn(:,11:12);
        a = regexpcellout(T.Experiment,'_','split');
        T.runcond = char(a(:,3));
        T.MWTfolder = B.foldername;
        T.Group = B.groupfolder;
        a = regexpcellout(T.Group,'_','split');
        T.strain = a(:,1);
        T.ExpCond = char(cellfun(@regexprep,T.Group,T.strain,...
            cellfunexpr(T.Group,''),'UniformOutput',0));
        
        
        % write table
        cd(pSave); writetable(T,'ExpSum.dat','Delimiter','\t');
        varargout{1} = T;
    case 'Experiment set summary'
        
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


%% VARARGOUT
AdminOutput.option = option;

varargout{1} = option;
end




















