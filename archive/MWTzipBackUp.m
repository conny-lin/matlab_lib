function MWTzipBackUp(zipdir,pData, varargin)
%%
% all 
% sequential ie) MWTzipBackUp(pProgram,pData, 'seq',10), back up top 10
% experiments

%% varargin
i = strcmp(varargin,'seq');
if isempty(i)==0
   Number = varargin{i+1};
else
    Number = NaN;
end



%% check exisitance of backup folder
% p = fileparts(pProgram);
% filename = 'MWT_ZipBackUp';
% zipdir = [p,'/',filename];
% if exist(zipdir,'dir') ~= 7
%     display 'Must Manuually create MWT_ZipBackUp folder'
%     return
%     mkdir(p,filename);
% end



%% check dir in zip
[fnzip,pzip] = dircontent(zipdir);
[fne,pe] = dircontent(pData);
% find experiment without backup
i = ~ismember(fne,fnzip);
fne = fne(i);
pe = pe(i);

display(sprintf('[%d] of experiments not backed up',numel(fne)));
%% see if there is limit to how many to back up
if isnan(Number) ==0 && numel(fne) > Number
    
    fne = fne(1:Number);
    pe = pe(1:Number);
end


%% back up
zipbackup(fne,pe,zipdir,pData);
end



%% Back up
function zipbackup(fne,pe,zipdir,pData)
if isempty(fne)==0
    display ' ';
    [~,filename] = fileparts(zipdir);
    display(sprintf('Backing up [%d] exp folders to [%s]',...
        numel(fne),filename));
    display 'DO NOT stop this process';

    % create group folders
    % find MWT folders
    [fmwt,pmwt] = cellfun(@dircontent,pe,cellfunexpr(pe,'Option'),...
        cellfunexpr(pe,'MWT'),'UniformOutput',0);
    pmwt = celltakeout(pmwt); fmwt = celltakeout(fmwt);

    % find group folders
    [pg,~] = cellfun(@fileparts,pmwt,'UniformOutput',0);
    pg = unique(pg);
    p = strrep(pg,pData,zipdir);
    i = ~cellfun(@exist,p,cellfunexpr(p,'dir'));
    cellfun(@mkdir,p(i));


    % find mwt folders
    [~,pmwt] = cellfun(@dircontent,pg,cellfunexpr(pg,'Option'),...
        cellfunexpr(pg,'MWT'), 'UniformOutput',0);
    pmwt = celltakeout(pmwt); fnmwt = celltakeout(fmwt);
    % zip MWT files
    for mwt = 1:numel(pmwt)
        [f,p] = dircontent(pmwt{mwt});
        p = celltakeout(p); f = celltakeout(f);
        i = regexpcellout(f,'(.dat)|(.summary)|(.png)|(.set)|(.blobs)');
        k = regexpcellout(f,...
            '(evan.dat)|(drunkposture.dat)|(shanespark.dat)|(swanlake.dat)|(tapN_30.dat)');
        i(k) = false;
        zipfilename = strrep(pmwt{mwt},pData,zipdir);
        filelist = p(i);
        display(sprintf('zipping [%s]...',fnmwt{mwt}));
        zip(zipfilename,filelist);
    end
end
end