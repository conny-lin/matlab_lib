function [MWTftrv,MWTfdat,MWTfGi,GAA,MWTfdatG,MWTftrvG] = groupMWTimport(pExp,pFun,MWTfdat,MWTftrv)
[~,GAA,MWTfGi] = setgroup(MWTfdat,pFun,pExp,0); % assign group name
% [BUG] confirm entry of groups
[MWTfdatG] = groupMWTfdata(MWTfdat,MWTfGi); % group data
[MWTftrvG] = groupMWTfdata(MWTftrv,MWTfGi); % group data
[savename] = creatematsavename(pExp,'import_','.mat'); % create save name
cd(pExp);
save(savename); % save file
end