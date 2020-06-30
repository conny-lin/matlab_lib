function synexpnameWruncond(Home)

%% [Done] synchronize exp runcondition name
[pExpV,ExpfnV,~,~,~,~,~] = getMWTpathsNname(Home,'noshow');
% prase exp name by under
[split] = regexp(ExpfnV,'_','split');
% take cell out
[expnameparts] = celltakeout(split,'split');
A = celltakeout(regexp(expnameparts(:,1),'[A-Z]','split'),'split');
expdate = A(:,1);
expter = celltakeout(regexp(expnameparts(:,2),'[A-Z][A-Z]','match'),'split');
runcondE = expnameparts(:,3);

% match exp runcon with mwt runcond -----------------------
for x = 1:numel(pExpV)
    pExp = pExpV{x,1};
    [~,~,~,~,pMWTf,MWTfn,MWTfsnM] = getMWTpathsNname(pExp,'noshow');
    [~,~,~,runcond,~] = parseMWTfnbyunder(MWTfsnM); % parsename
    runcondM = char(unique(runcond));
    if strcmp(runcondE{x},runcondM) ==1;
        test{x,1} = 'pass';
    else
        test{x,1} = 'fail';
    end
end
% find failed exp
Exp2check = ExpfnV(cellfun(@isempty,regexp(test,'pass')),1);
disp(Exp2check);