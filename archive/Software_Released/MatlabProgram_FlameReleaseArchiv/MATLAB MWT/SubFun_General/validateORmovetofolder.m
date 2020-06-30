function [MWTf,pMWTf] = validateORmovetofolder(pExp,foldername,ext)
%%
display(sprintf('Validating %s file exists in every MWT folders...',ext));
[MWTf,pMWTf] = dircontentmwt(pExp); % get only MWTf
extension(1:numel(pMWTf),1) = {ext};
[extf,~] = cellfun(@dircontentext,pMWTf,extension,'UniformOutput',0);
[missingext] = cellfun(@isempty,extf);

if missingext ~=0; % if there is missing files
    cd(pExp);
    mkdir(foldername);
    display(sprintf('missing %s file found...',ext));
    pMS = strcat(pExp,'/',foldername);
    for x = 1:size(t,1)
        p = pMWTf{t(x,1),1}; % get path of MWTf
        movefile(p,pMS); % move MWTf to missing sum file folder
    end
    [MWTf,pMWTf] = dircontentmwt(pExp);
end
display('done');
end
    
