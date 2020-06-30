function pSave = setup_std(prgpath,wrkgrpname,varargin)

%% defaults
genSave = 1;
vararginProcessor;

%% PATHS
% ADD FUNCTION PATH
add_code_package_paths(wrkgrpname);

% get var
[~,fname] = fileparts(prgpath);
prgpathname = [prgpath,'.m'];
tstamp = generatetimestamp;

% deposit current code
pDepository = '/Users/connylin/Dropbox/Code/Matlab/Working Depository';
name = sprintf('%s/%s%s_%s.m',pDepository,tstamp,wrkgrpname,fname);
copyfile(prgpathname,name);

% copy current code
pSave = prgpath;
if genSave
    create_savefolder(pSave); % get folder %     if isdir(pSave) == 0; mkdir(pSave); end
    pCode = create_savefolder(pSave,'_Archive Code'); % get folder %     if isdir(pSave) == 0; mkdir(pSave); end
    fname_new = sprintf('%s_a%s.m',fname,tstamp);
    copyfile(prgpathname, fullfile(pCode,fname_new));
    addpath(pSave); % add current code folder to path (20160913r)
end
