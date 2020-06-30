function addcorruname2expfolder(Home)
[pExpV,Expfn,~,~,~,~,MWTfsn] = getMWTpathsNname(Home,'show');
q = input('exp list correct? ');
if q ==0;
    return
end
for x =1:numel(pExpV);
[~,~,~,~,~,~,MWTfsn] = getMWTpathsNname(pExpV{x},'show');
[~,~,~,runcond,~] = parseMWTfnbyunder(MWTfsn);
if numel(unique(runcond)) ==1;% check consistency of runcond
    runame = char(unique((runcond)));
else
    str = 'different runcond name within expfolder [%s]';
    display(sprintf(str,Expfn{x}));
    return
end
[homepath,expfn] = fileparts(pExpV{x});
% change exp folder name (20130709B_AH)
part1 = regexp(expfn,'(\d{8})[A-Z][_][A-Z][A-Z][_]','match');
part2 = runame;
part3 = regexp(expfn,'(\d{8})[A-Z][_][A-Z][A-Z][_]','split');
part3 = part3{1,2};
newexpname = [char(part1) char(part2) '_' char(part3)]; % reconstruct
mkdir(homepath,newexpname);
newexpath = [homepath,'/',newexpname];
[~,p1,~,~] = dircontent(pExpV{x});% get content
newexpathc = cellfunexpr(p1,newexpath);
cellfun(@movefile,p1,newexpathc); % move content
rmdir(pExpV{x});
end