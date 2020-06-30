function [pZip] = Zip2Raw(pExp,pFun,pRaw)
%%
[zipf,pzip] = dircontentext(pExp,'*.zip'); % get all zip files
[expname] = findstadexpfoldername(pExp,pFun); % find exp name
cd(pRaw); % create standardized expfolder name
pZip = strcat(pRaw,'/',expname);
if isdir(pZip) ==1;
    display('back up already found in Raw_Data');
    answer = input('delete zip files instead (y=1,n=0): ');
    if answer ==1;
    else
    return
    end
else
    mkdir(expname);
end
[move2pZip] = cellfunexpr(zipf,pZip);
cd(pExp);
movefile('*zip',pZip); % move zip to there


end