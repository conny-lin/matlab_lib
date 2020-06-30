function createexpname(pExp2)
% create save name
[~,expn] = fileparts(pExp2);
i = strfind(expn,'_');
if size(i,2)>2;
    expn = expn(1:i(3)-1);
else
    ...
end
savename = strcat('import_',expn,'.mat');
% save file
cd(pExp2);
save(savename,'Expfdat','GAA','MWTfGi','MWTfdat','MWTftrv','expn',...
    'javacode');
end