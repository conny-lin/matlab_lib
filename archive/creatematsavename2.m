 function [savename] = creatematsavename2(pExp,prefix,suffix,sequence)
% add experiment code after a prefix i.e. 'import_';
[~,expn] = fileparts(pExp);
i = strfind(expn,'_');
if size(i,2)>2;
    expn = expn(1:i(3)-1);
else
    ...
end
switch sequence
    case 1 % prefix_expn
        savename = strcat(prefix,'_',expn,suffix);
    case 2 % expn_prefix
        savename = strcat(expn,'_',prefix,suffix);
        
end
