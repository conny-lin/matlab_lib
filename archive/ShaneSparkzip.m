function ShaneSparkzip(pExp)
% make a backup zip on experimenter folder
if exist(strcat(pExp,'.zip'),'file') ~=2; % if this file had not been zipped
    display('Zipping a copy of current file as backup, please wait...');
    zip(pExp,pExp); % create a zip back up in case of mistakes
end

% unzip raw data
% [DEVELOP] change original name file for it to start with run name
[~,~] = unziprawdata(pExp); % Unzip raw data
display('done.');