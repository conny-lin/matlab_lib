function [varargout] = FindAllMWT(pS)
%% INSTRUCTION
% pS can be string or cell array

%% updates
% 20140413 update
    % add zip files as well
    % updated getalldir

%% reporting
display 'searching for MWT files, this will take a while...';
%%  get all paths and folder names under input dir
[pf,fn] = getalldir(pS);

%% search term for MWT folder name
search = '(\<(\d{8})[_](\d{6})\>)';
k = regexpcellout(fn,search);
pMWTf= pf(k);
MWTfn = fn(k);
nonpMWTf = pf(~k);
nonMWTfn = fn(~k);


%% get MWT.zip
% get content under all paths
[fn,pf] = cellfun(@dircontent,pf,'UniformOutput',0);
% take out file names
fn = celltakeout(fn,'multirow');
% get only MWT.zip files
search = '(\<(\d{8})[_](\d{6})[.]zip\>)';
k = regexpcellout(fn,search);
% get MWTzip file names
MWTzipfn = fn(k);
% get MWT zip file just MWT code
MWTzipfnNoext = regexprep(MWTzipfn,'[.]zip','');
% get paths
pf = celltakeout(pf,'multirow');
pMWTzip = pf(k);

%% construct output
A.pMWTf = pMWTf;
A.MWTfn = MWTfn;
A.pMWTzip = pMWTzip;
A.MWTzipfn = MWTzipfn;
A.MWTzipfnNoext = MWTzipfnNoext;
varargout{1} = A;

%% report
display 'done';
  
end  







