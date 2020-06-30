 function [savename] = creatematsavename(pExp,prefix,suffix)
    % add experiment code after a prefix i.e. 'import_';
    [~,expn] = fileparts(pExp);
    i = strfind(expn,'_');
    if size(i,2)>2;
        expn = expn(1:i(3)-1);
    else
        ...
    end
    savename = strcat(prefix,expn,suffix);
    end
