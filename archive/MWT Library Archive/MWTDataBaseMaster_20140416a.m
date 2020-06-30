function [varargout] = MWTDataBaseMaster(pData,varargin)

switch nargin
    case 2     
        OPTION = varargin{1};
        %[varargout{1}] = eval([varargin{1},'(homepath)']);
    case 1   
        [varargout{1}] = GetStdMWTDataBase(pData);
      
end            

%% option
switch OPTION
    case 'search'
        [varargout{1}] = MWTDatabase_search(pData);
        
    case 'FindAllMWT'
        [varargout{1}] = MWTDatabase_FindAllMWT(pData);
    
    case 'FindAllMWTNew'
        [varargout] = FindAllMWT(pS);
        

    case 'GetSingleExpInfo'
        [varargout{1}] = MWTDatabase_GetSingleExpInfo(pData);
    
    case 'GetExpTargetInfo'
        [varargout{1}] = GetExpTargetInfo(pData);
        
    case 'GetStdMWTDataBase'
        [varargout{1}] = GetStdMWTDataBase(pData);
        
    otherwise
        display('No such option');
        varargout{1} = [];
end


end


