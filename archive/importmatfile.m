function [Expfdat] = importmatfile(rawfilename,pExp)
cd(pExp);
a = dir(rawfilename);
a = {a.name};
load(char(a));
end