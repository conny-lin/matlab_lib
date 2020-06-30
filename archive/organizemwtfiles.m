function organizemwtfiles(pExpO,pExpS,pRaw,expname)
display(' ');
display('File organizing begins...');
% zip to pRaw/expname
[p,oriname] = fileparts(pExpO);
pRawzip = strcat(pRaw,'/',expname,'.zip');
% [suspend duplicate pRaw backup]
%if exist(pRawzip,'file')~=2;% check if there is already a zipped file in Raw
   display('backing up a zip copy to Raw_Data...');
   zip(pRawzip,oriname,p);
%else
%    display('Raw_Data already has this file backed up, skip...');
%end
%% [suspend, unnecessary] move all MWTf to pExpS
ID = 0;
switch ID
    case 0
        return
    case 1
        
    [~,p,~,~] = dircontent(pExpO);
    if isequal(pExpO,pExpS)==0;
        display('moving files to standardized folder...');
        for x = 1:size(p,1);
            movefile(p{x,1},pExpS);        
        end 
        display('deleting old experiment folder...');
        rmdir(pExpO,'s'); % remove old file 
        display('updating new experiment path...');
    else
        display('folder already in standardized name');
    end
end
display('done');