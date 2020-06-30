% get unzipped MWT & Exp file folder path
function [pExp,pMWTf,MWTfn] = getunzipMWT(Home)
display 'Finding MWT folder under specified path...';
[allpaths] = getalldir(Home);
[mwtval,b] = regexp(allpaths,'\d\d\d\d\d\d\d\d_\d\d\d\d\d\d','match','split');
i = find(not(cellfun(@isempty,mwtval))); % index to MWTfolders
pMWTf = {};
for x = 1:numel(i)
pMWTf(x,1) = allpaths(i(x,1),1);% get path to MWT folders
MWTfn(x,1) = mwtval{i(x,1),1}(1);
end
[p,fn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
pExp = unique(p); % set different

%% reporting
if isempty(MWTfn) ==1;
    display 'No MWT files found under input path';
else
display(sprintf('>> %d [%d unique] MWT files found under',numel(MWTfn),...
    numel(unique(MWTfn))));
display(sprintf('>> %d [%d unique] Exp/Group folders, ',numel(pExp),...
    numel(unique(pExp))));
end




