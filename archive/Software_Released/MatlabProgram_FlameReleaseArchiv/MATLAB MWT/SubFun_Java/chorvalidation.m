%% choreography validation
for x = 1:size(pExptarget,1);
    pExp = pExptarget{x};
    [~,pMWTf] = dircontentmwt(pExp);
    for y = 1:numel(pMWTf)
        Shanesparkchoretapreversal2(pMWTf{y})
    end
end


%% load previous trv and compare to current trv
 [MWTftrvOld,~] = ShaneSparkimporttrvNsave(pExpOld,pExpOld,'OldLinux');
 [MWTftrvNew,~] = ShaneSparkimporttrvNsave(pExpNew,pExpNew,'ConnyChor');
% testing history:
% test equality - not completely equal, gives a bit more reversing, but good
% enough
MWTftrvL = {1,'MWTfile name';2,'Run name';3,'RawData';4,'NReversed';...
5,'TotalN';6,'N_NoResponse';7,'Time';8,'FreqRev';9,'DistTimeNReversed';...
10,'Dist/NRev';11,'Dist/TotalN'};
% time
test = 'Time';
k = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),test))));
old = MWTftrvOld{:,k};
new = MWTftrvNew{:,k};
Eq = isequal(old,new);
if Eq ==1;
    Eqresult = 'Equal';
else
    Eqresult = 'Not Equal';
end
str = 'Equality test for [%s]: %s';
display(sprintf(str,test,Eqresult));

% NReversed
test = 'NReversed';
k = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),test))));
old = MWTftrvOld{:,k};
new = MWTftrvNew{:,k};
Eq = isequal(old,new);
if Eq ==1; Eqresult = 'Equal'; else Eqresult = 'Not Equal'; end
str = 'Equality test for [%s]: %s';
display(sprintf(str,test,Eqresult));
% check for row equality
if Eq ==0;
    rowOld = size(old,1);
    rowNew = size(new,1);
    if size(old,1) ~= size(new,1); display '*Row number different';
    elseif size(old,1) == size(new,1); display '*Row number equal'; 
    end
    str = 'old has %d rows, new has %d rows';
    display(sprintf(str,rowOld,rowNew));
end
MoreInOld = sum(old>new);
MoreInNew = sum(old<new);
if MoreInOld<MoreInNew; 
    str = 'Numeric Test [%s]: Old (%d) < New (%d) analysis';
    display(sprintf(str,test,MoreInOld,MoreInNew));
elseif MoreInOld>MoreInNew;
     str = 'Numeric Test [%s]: Old (%d) > New (%d) analysis';
    display(sprintf(str,test,MoreInOld,MoreInNew));
else
end

% TotalN
test = 'DistTimeNReversed';
k = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),test))));
old = MWTftrvOld{:,k};
new = MWTftrvNew{:,k};
Eq = isequal(old,new);
if Eq ==1; Eqresult = 'Equal'; else Eqresult = 'Not Equal'; end
str = 'Equality test for [%s]: %s';
display(sprintf(str,test,Eqresult));
% check for row equality
if Eq ==0;
    rowOld = size(old,1);
    rowNew = size(new,1);
    if size(old,1) ~= size(new,1); display '*Row number different';
    elseif size(old,1) == size(new,1); display '*Row number equal'; 
    end
    str = 'old has %d rows, new has %d rows';
    display(sprintf(str,rowOld,rowNew));
end
MoreInOld = sum(old>new);
MoreInNew = sum(old<new);
if MoreInOld<MoreInNew; 
    str = 'Numeric Test [%s]: Old (%d) < New (%d) analysis';
    display(sprintf(str,test,MoreInOld,MoreInNew));
elseif MoreInOld>MoreInNew;
     str = 'Numeric Test [%s]: Old (%d) > New (%d) analysis';
    display(sprintf(str,test,MoreInOld,MoreInNew));
else
end
percenterror = ((new-old)./old)*100;
display(sprintf('*min percenterror %.1f',min(percenterror)));
display(sprintf('*max percenterror %.1f',max(percenterror)));
display(sprintf('*mean percenterror %.1f',mean(percenterror)));
display(sprintf('*min abs percenterror %.1f',min(abs(percenterror))));
display(sprintf('*max abs percenterror %.1f',max(abs(percenterror))));
display(sprintf('*min percenterror %.1f',mean(abs(percenterror))));
% positive is increase

%% run betthoven v2 chor
choretapreversalBeethovenV2(pMWTNew)
% source[MWTftrv,MWTftrvL] = ShaneSparkimporttrvNsaveExt(pExp,pSave,option,ext)
i = [1,3:5,8:10,12:16,19:21,23:27]; % index to none zeros
[fn,~] = dircontentext(pMWTNew,'*.bv2'); 
A = dlmread(fn{1},' ',0,0);
New = A(:,i);
[fn,~] = dircontentext(pMWTNew,'*.trv'); 
A = dlmread(fn{1},' ',0,0);
Newtrv = A(:,i);
[fn,~] = dircontentext(pMWTOld,'*.trv'); 
A = dlmread(fn{1},' ',5,0);
i = [1,3:5,8:10,12:16,19:21,23:27]; 
Old = A(:,i);
%%
e = isequal(Old(:,4),New(:,4));
isequal(NewLast(:,4),New(:,4))
RevN = [Old(:,4) NewLast(:,4) New(:,4) Newtrv(:,4)]
NoRespN = [Old(:,3) NewLast(:,3) New(:,3) Newtrv(:,3)]
RevDist = [Old(:,5) NewLast(:,5) New(:,5) Newtrv(:,5)]
%%
NewLast = New;