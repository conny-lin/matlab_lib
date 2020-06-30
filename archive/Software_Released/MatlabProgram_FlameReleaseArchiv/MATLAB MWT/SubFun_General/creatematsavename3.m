 function [savename] = creatematsavename3(expname,prefix,suffix)
    % add experiment code after a prefix i.e. 'import_';

    savename = strcat(prefix,expname,suffix);
    end
