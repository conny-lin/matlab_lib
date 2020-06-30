 function [savename] = creatematsavenamewdate(prefix,suffix)
    % add experiment code after a prefix i.e. 'import_';
    date = datestr(now, 'yyyymmddHHMM');
    savename = strcat(prefix,date,suffix);
    end
