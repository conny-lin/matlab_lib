function pFunPublic = addpathfromtextfile(filepath)
% add path from a text file "filepath" including the path to a folder

fileID = fopen(filepath,'r');
dataArray = textscan(fileID, '%s%[^\n\r]',...
    'Delimiter', '',  'ReturnOnError', false);
fclose(fileID);
pFunPublic = char(dataArray{:, 1});
addpath(pFunPublic);
