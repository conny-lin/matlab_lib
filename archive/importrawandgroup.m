function [Expfdat,MWTftrv,MWTfdat,MWTfGi,GAA,MWTfdatG,...
    MWTftrvG] = importrawandgroup(pExp2)
%% import and group raw data
[Expfdat,MWTftrv,MWTfdat] = importungroupedexp(pExp2); % Import Beethoven files


[~,GAA,MWTfGi] = setgroup(MWTfdat,pFun,pExp2,0); % assign group name
% [BUG] confirm entry of groups
[MWTfdatG] = groupMWTfdata(MWTfdat,MWTfGi); % group data
[MWTftrvG] = groupMWTfdata(MWTftrv,MWTfGi); % group data
[savename] = creatematsavename(pExp2,'import_'); % create save name
cd(pExp2);
save(savename); % save file
end
