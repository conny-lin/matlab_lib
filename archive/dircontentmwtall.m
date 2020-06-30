function [A] = dircontentmwtall(home)
% declare output
display 'Searching for MWT in all drives, this will take a while...';
A = []; 
[b] = getalldir(home); % get all paths

%% [MWTfn & pMWTf] all files with MWT name structure
[p,fn] = cellfun(@fileparts,b, 'UniformOutput',0);
search = '(\<(\d{8})[_](\d{6})\>)';
c = celltakeout(regexp(fn,search),'logical');
MWTfn = fn(c); pMWTf = b(c); % create output
NonMWTfn = fn(not(c)); pNonMWT = b(not(c));

%% [MWTfnR & pMWTfnR] MWT with proper raw data content
% check if the folder has .blobs .set .summary
suminfo = cell(numel(pMWTf),3);
for x = 1:1%numel(pMWTf)
    [s,~] = dircontentext(pMWTf{x},'*.summary');
    [b,~] = dircontentext(pMWTf{x},'*.blobs');
    [t,~] = dircontentext(pMWTf{x},'*.set');
    if isempty(t)==0 && isempty(s)==0 && isempty(b)==0;
       suminfo(x,1:3) = [MWTfn(x),pMWTf(x),{'rawdata'}]; 
    else
       suminfo(x,1:3) = [MWTfn(x),pMWTf(x),{'missrawdata'}];
    end
end
i = cellfun(@isempty,regexp(suminfo(:,3),'rawdata'));
MWTfnR = MWTfn(i); pMWTfnR = pMWTf(i);
str = '%d MWT files found, %d are Raw file folders';
display(sprintf(str,numel(MWTfn),numel(MWTfnR)));

%% [pMWTfzip MWTfnzip]
% check within each dir to see if there are MWT zip folders
[zip] = cellfunexpr(pNonMWT,'*.zip');
[fn,p] = cellfun(@dircontentext,pNonMWT,zip,'UniformOutput',0); 
pzip = celltakeout(p,'multirow');
fnzip = celltakeout(fn,'multirow');
i = regexp(fnzip,'\<((\d{8})[_](\d{6}))\>');
k = not(cellfun(@isempty,i));
MWTfnzip = fnzip(k); pMWTfzip = pzip(k);
MWTfnzip = regexprep(MWTfnzip,'.zip','');
str = '%d zipped MWT files found';
display(sprintf(str,numel(MWTfnzip)));

%% package output
A.pMWTfzip = pMWTfzip; A.MWTfnzip = MWTfnzip; 
A.MWTfnR = MWTfnR; A.pMWTfnR = pMWTfnR;
A.NonMWTfn = NonMWTfn; A.pNonMWT = pNonMWT;
A.MWTfn = MWTfn; A.pMWTf = pMWTf;

end

