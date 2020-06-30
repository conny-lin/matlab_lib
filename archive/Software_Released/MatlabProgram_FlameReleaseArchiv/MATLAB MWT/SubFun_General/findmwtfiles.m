function [S,T,MWTfnWanted] = findmwtfiles(Source,Target)
%% STEP2: DEFINE SAVE PATH
cd(Target);
mkdir(Target,'MWT_Lost&Found');
pSave = [Target,'/MWT_Lost&Found'];
%% STEP3: SEARCH THROUGH SOURCE AND TARGET DRIVES
% STEP3A: FIND MWT FILES IN SOURCE
[S] = dircontentmwtall(Source);
% STEP3B: FIND MWT FILES IN TARGET
[T] = dircontentmwtall(Target);
%% STEP4: COMPARE
% combine MWTfnzip and MWTfnR
MWTfnS = [S.MWTfnzip; S.MWTfnR]; MWTfnSU = unique(MWTfnS);
MWTfnT = [T.MWTfnzip; T.MWTfnR]; MWTfnTU = unique(MWTfnT);
MWTfnWanted = setdiff(MWTfnS,MWTfnT);
str = '%d files found in Source but not in target';
display(sprintf(str,numel(MWTfnWanted)));
%% STEP5: FIND PATHS TO MISSING FILES
pMWTfS = [S.pMWTfzip; S.pMWTfnR];
for x = 1:numel(MWTfnWanted)
    str = 'finding %s';
    display(sprintf(str,MWTfnWanted{x}));
    i = celltakeout(regexp(S.MWTfnzip,MWTfnWanted{x}),'logical');  
    if sum(i)>0; k = find(i);
        copyfile(S.pMWTfzip{k(1)},pSave); 
        display 'copied ziped file';
    else 
       i = celltakeout(regexp(S.MWTfnR,MWTfnWanted{x}),'logical');
       if sum(i)==0; k = find(i); display 'copied raw file';
           mkdir(S.MWTfnR{k(1)},pExport);
           [~,p] = dircontent(S.pMWTfnR{k(1)});
           [export] = cellfunexpr(p,[pSave,'/',S.MWTfnR{k(1)}]);
           cellfun(@copyfile,p,export);
       else
           str = 'can not find [%s]';
           display(sprintf(str,MWTfnWanted{x}));
       end
    end
    
end

end