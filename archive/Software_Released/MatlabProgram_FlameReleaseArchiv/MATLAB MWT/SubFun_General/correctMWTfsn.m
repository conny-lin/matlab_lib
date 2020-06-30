function correctMWTfsn(MWTfsn,MWTrunameCorr,pMWTf,MWTfn,Home)
i = find(not(cellfun(@strcmp,MWTfsn,MWTrunameCorr))); % not the same
if isempty(i) ==1;
    display('No file name corrected...');
else
for x = 1:numel(i); % for each MWTf that has differen run name
    % parse ext names
    [fn,oldpaths,~,~] = dircontent(pMWTf{i(x,1),1});
    [~,~,oldext] = filenameparse4(fn); 
    % replace old name with new name
    [newname] = cellfunexpr(oldext,MWTrunameCorr{i(x,1),1}); 
    newfilenames = cellfun(@strcat,newname,oldext,...
        'UniformOutput',0);
    % create new path
    [p] = cellfunexpr(oldext,pMWTf{i(x,1)});
    [slash] = cellfunexpr(oldext,'/');
    newpaths = cellfun(@strcat,p,slash,newfilenames,'UniformOutput',0);

    % move files 
    % [BUGFIX] double check if oldpaths and newpaths are the same
    cellfun(@movefile,oldpaths,newpaths);
    display(sprintf('%s file names corrected',MWTfn{i(x,1)}));
end
end
[pMWTf,MWTfn,MWTfsn,MWTsum,pExp] = getMWTrunamefromHomepath(Home);