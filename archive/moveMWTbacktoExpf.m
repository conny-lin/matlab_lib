
function moveMWTbacktoExpf(Home)
[pExpV,Expfn,~,~,~,~,~] = getMWTpathsNname(Home,'noshow');
 
%% look at groupped MWT under exp folder
for x = 1:numel(pExpV)
    pExp = pExpV{x,1};
    % display exp name
    [~,expname] = fileparts(pExp);
    str = 'Experiment folder: %s';
    display(sprintf(str,expname));
    
    % display group folders
    [~,~,fn,p] = dircontent(pExp);
    str = 'Group folders: %s';
    display(sprintf(str,char(fn)));

    % find MWT files under exp folders
    [~,~,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = getMWTpathsNname(pExp,'show');
    [p,h] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
    [pE] = cellfunexpr(MWTfn,pExp);
    i = (not(strcmp(p,pE)));
    if sum(i) ~=0;
        pMWTmove = pMWTf(i);
        MWTfnmove = MWTfn(i);
        % move MWT files under pExpV
        [s] = cellfunexpr(MWTfnmove,'/');
        [pE] = cellfunexpr(pMWTmove,pExp);
        desg = cellfun(@strcat,pE,s,MWTfnmove,'UniformOutput',0);
        cellfun(@movefile,pMWTmove,pE); % move file back to experiment folder
    end
    
end


