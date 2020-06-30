function pSave = create_savefolder(pSave,subfolderName)

if nargin == 2
    pSave = fullfile(pSave,subfolderName);    
end

% create folder
if isdir(pSave) == 0; mkdir(pSave); end
