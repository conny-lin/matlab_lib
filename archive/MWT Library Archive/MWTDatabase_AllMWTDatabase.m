function [varargout] = MWTDatabase_AllMWTDatabase(pData)
%%
if ischar(pData) == 1 && size(pData,1) == 1
    pData = {pData};
end

[A] = GetStdMWTDataBase(pData)

end