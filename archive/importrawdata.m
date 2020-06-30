function [Expfdat,MWTftrv,MWTfdat,MWTfGi,GAA,MWTfdatG,MWTftrvG] = ...
    importrawdata(pExp2,pFun)
%% get supporting .mat
cd(pFun);
load('javasetting.mat'); % load matlab program

%% import and group raw data
[Expfdat,MWTftrv,MWTfdat] = importungroupedexp(pExp2); % Import Beethoven files
[~,GAA,MWTfGi] = setgroup(MWTfdat,pFun,pExp2,0); % assign group name
% [BUG] confirm entry of groups
[MWTfdatG] = groupMWTfdata(MWTfdat,MWTfGi);
[MWTftrvG] = groupMWTfdata(MWTftrv,MWTfGi);
%% save
[savename] = creatematsavename(pExp2,'import_');
cd(pExp2);
save(savename,'Expfdat','GAA','MWTfGi','MWTfdat','MWTftrv','expn',...
    'javacode','MWTfdatG','MWTftrvG'); % save file
end