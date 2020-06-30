function AnkieOriginalFormatReorg(home)
%put MWT folders under matching group folder MWT names
[~,pmwt] = dircontentmwt(home);
[fn,pungf] = dircontentext(home,'UngroupRecor*');
if isempty(fn) ==1;
    display 'No UngroupRecord found';
    return
end
[fn,pgf] = dircontent((pungf{1}));
i = cellfun(@isempty,regexp(fn,'.mat')); % exclude.mat
pgf = pgf(i);
for x = 1:numel(pgf);
    [fn2,p2] = dircontentext(pgf{x},'*.zip');
    fn3 = regexprep(fn2,'.zip',''); % identify target mwt names
    for y = 1:numel(fn3);
        target = [home,'/',fn3{y}]; % get target mwt files
        movefile(target,pgf{x});% move target mwt to group folder p{x}
    end
end
% check group code for each group folder
for x = 1:numel(pgf)
    [~,MWTsum] = MWTrunameMaster(pgf{x},'groupcode');
end
% change name for group folders
for x = 1:numel(pgf)
    [ph,gfn] = fileparts(pgf{x});
    disp(gfn);
    display 'change to...';
    newname = input(': ','s');
    newpath = [ph,'/',newname];
    mkdir(ph,newname);
    [~,pgc,~,~] = dircontent(pgf{x});
    newpath2 = cellfunexpr(pgc,newpath);
    cellfun(@movefile,pgc,newpath2);
    rmdir(pgf{x});
end
% get new pgf name
[fn,pgf] = dircontent((pungf{1}));
i = cellfun(@isempty,regexp(fn,'.mat')); % exclude.mat
pgf = pgf(i);
% create empty group folders
pd = '/Volumes/Rose/Ankie_Hung';
[~,homename] = fileparts(home);
mkdir(pd,homename);
[~,~,fn,~] = dircontent(pungf{1});
pexpn = [pd,'/',homename];
[pn] = cellfunexpr(fn,pexpn);
cellfun(@mkdir,pn,fn);

% move MWT back to expfolder
for x = 1:numel(pgf) 
    [~,pmwtg] = dircontentmwt(pgf{x});
    for y = 1:numel(pmwtg)
        movefile(pmwtg{y},pexpn);
    end
end
