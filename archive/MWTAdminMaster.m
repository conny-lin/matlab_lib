function [AdminOutput] = MWTAdminMaster(varargin)
%% MWT Admin Master
% Revised 20140420



%% OPTIONS
optionlist = {'off';
%     'Experiment set summary';
    'database summary';
%     'Data structure';
%     'Get new MWT files';
%     'Get missing MWT zip files';
%     'Get missing MWT and MWT zip files'
    };


%% VARARGIN PROCESSING 
V = varargin;

[A] = processvarargin(V);

% pList
if A.structN == 1
    pList = A.struct{1};
end
% option
if A.strN == 1  
    option = A.str{1};
else
    [option] = chooseoption(optionlist);
end





%% OPTION SWITCH BOARD
AdminOutput.option = option;
switch option
      
    case 'off'
         return
    
    case 'check namings'
        
    case 'group MWT'
    case 'Data structure'  
        [AdminOutput.Summary] = MWTAdminMaster_DataStructure(pList.pData);
    
    case 'database summary'
        [AdminOutput.Summary] = MWTAdminMaster_DatabaseSummary(pList);

        
    case 'Get new MWT files'
        [pSource,pDesg] = selectdrive; 
        [pathcopied] = CopyNewMWTFiles(pSource,pDesg);
        varargout{1} = pathcopied;
        
    case 'Get missing MWT zip files'
        
        [pSource,pDesg] = selectdrive;         
        CopyMissMWTZipFiles(pSource,pDesg);
         varargout{1} = 'Completed';
        
    case 'Get missing MWT and MWT zip files';
        pSource = varargin{2};
        pDesg = varargin{3};
        CopyMissMWTandZipFiles(pSource,pDesg);
        varargout{1} = 'Completed';
        
end


%% VARARGOUT

end




















