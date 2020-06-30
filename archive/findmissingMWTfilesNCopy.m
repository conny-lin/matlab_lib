function findmissingMWTfilesNCopy(Source,Target)
%% search for missing MWT files
% get list from Maestro
[pExpM,ExpfnM,~,~,pMWTfM,MWTfnM,~] = getMWTpathsNname(Source,'noshow');
% get list from Rose
[pExpR,ExpfnR,~,~,pMWTfR,MWTfnR,~] = getMWTpathsNname(Target,'noshow');
str = '[%d/%d] files in Maestro/Rose';
display(sprintf(str,numel(MWTfnM),numel(MWTfnR)));
DiffM = setdiff(MWTfnM,MWTfnR); % in Maestro but not in Rose
DiffR = setdiff(MWTfnR,MWTfnM);
[zipext] = cellfunexpr(MWTfnM,'.zip');
[pH,mwtfn] = cellfun(@fileparts,pMWTfM,'UniformOutput',0);

%% define paths
cd(Target);
pMissZip = [pRose,'/','MissingMWT'];
if isdir(pMissZip)~=1;
    mkdir('MissingMWT');
end
cd(pMissZip);
savename = ['report' datestr(now,'yyyymmddHHMM') '.mat'];
save(savename,'pMWTfR','MWTfnR','DiffM');

%%
for x =1:numel(DiffM);
a = find(not(cellfun(@isempty,regexp(MWTfnM,DiffM{x}))));
if sum(a)>=1;
    pzip = [pH{a(1)},'/',MWTfnM{a(1)},'.zip']; % get zipfile path
    copyfile(pzip,pMissZip);
end
end


%% copy a zip copy of DiffR as well
% create mwtfilename.info
% in there gives runname.rnn 
% containing text files with description of the
% group code and expdate
%