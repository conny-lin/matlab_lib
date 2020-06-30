function ShaneSpark(pExpList,pSet)
% need unzipped MWT data ungrouped from group folders
% group code must be prechecked

% name groups
for x = 1:size(pExpList,1);
pExp = pExpList{x};
[Groups] = GroupNameMaster(pExp,pSet,'groupnameEnter');
[GAA] = GroupNameMaster(pExp,pSet,'GraphGroupSequence');
end

%% choreography 
for x = 1:size(pExpList,1);
pExp = pExpList{x};
[~,pMWTf] = dircontentmwt(pExp);
for y = 1:numel(pMWTf)
Shanesparkchoretapreversal2(pMWTf{y})
end
end

%% Data processing
for x = 1:size(pExpList,1);
pExp = pExpList{x};
[MWTfgcode] = GroupNameMaster(pExp,pSet,'makeMWTfgcode');
[MWTftrv,MWTftrvL] = ShaneSparkimporttrvNsave(pExp,pExp,'ConnyChor');
[MWTftrvG] = GroupData(MWTftrv,MWTfgcode);
% replace group code with gname
for x = 1:numel(MWTftrvG(:,1))
MWTftrvG(x,1) = MWTfgcode(find(not(cellfun(@isempty,regexp(MWTfgcode(:,1),MWTftrvG{x,1})))),2);
end
ShaneSparkSubPlot(MWTftrvG,pExp);
cd(pExp);
save('ShaneSpark.mat','MWTftrvG');
end