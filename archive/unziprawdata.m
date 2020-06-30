function [MWTf,pMWTf] = unziprawdata(pExp)
display('Checking if files are zipped...');
% check if unzipped, if so, unzip all
[MWTf,pMWTf] = dircontentext(pExp,'*.zip');
if isempty(MWTf) ==0; % if there is zip files
    display('unzipping files, please wait...');
    for x = 1:size(MWTf,1);
        [pH,~] = fileparts(pMWTf{x,1}); % get home path
        unzip(MWTf{x,1},pH); % unzip them all
        delete(pMWTf{x,1}); % delete zip files
    end
    display('done');
end