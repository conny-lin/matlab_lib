function putmwtzipfolderunderadatefolder(p)
%% put zip folders under a date file
%% search for paths with .zip
% regexp(allpaths,'.zip');
% user inputs
% p = pG;
[fn,pmwt] = dircontentmwt(p);
i = celltakeout(regexp(fn,'_','split'),'split');
b = i(:,2);
k = cellfun(@isempty,b);
mwtdate = i(:,1);
%%
mwtfn = fn(not(k));
pmwt = pmwt(not(k));
%%
dateU = unique(a);
pc = cellfunexpr(dateU,p);
cellfun(@mkdir,pc,dateU);
%%
for x = 1:1%numel(dateU)
    i = celltakeout(regexp(mwtdate,dateU{x}),'logical');
    k = find(i);
    [desp] = cellfunexpr(k,[p,'/',dateU{x}]);
    
    cellfun(@movefile,pmwt(i),desp)

end
%%
[txt] = cellfunexpr(p,'*.zip')
%%
[zipfn,pzips] = cellfun(@dircontentext,p,txt,'UniformOutput',0);
zipfna = celltakeout(zipfn,'multirow');
%% process zip name for search
a = celltakeout(regexp(zipfna,'(.zip)$','split','once'),'split');
zipmwtname = a(:,1);
zipfn=DiffM;
a = celltakeout(regexp(zipfn,'_','split'),'split');
zipdate = a(:,1);
ziptime = a(:,2);

%% user examination for expdate
numel(zipdate)
numel(unique(zipdate))

%%
cd(pRose);
cellfun(@mkdir,unique(zipdate));
% transfer zip files into dates
zdate = unique(zipdate);
for x = 2:numel(zdate)
    i = not(cellfun(@isempty,regexp(zipdate,zdate{x})));
    [pdes] = cellfunexpr(find(i),[pRose ,'/',zdate{x}]); 
    cellfun(@movefile,pzips(i),pdes);
end
%
for x = 2:numel(zdate)
    pziph = [pRose,'/',zdate{x}];
[zfn,pz] = dircontentext(pziph,'*.zip');
cd(pziph);
for y = 1:numel(zfn)
    name = zfn{y}(1:end-4);
mkdir(name);
unzip(zfn{y},[pziph,'/',name]);
end
end

