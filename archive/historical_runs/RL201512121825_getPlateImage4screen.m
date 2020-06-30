%% get plate image for visual inspection
pSaveHome = fileparts(fileparts(mfilename('fullpath')));
programName = 'Dance_Glee_Preggers';
analysisNLimit = 0;
exp_exclusion = {};
plate_exclusion = {};



% query database
pData = '/Volumes/COBOLT/MWT';
D = load([pData,'/MWTDatabase.mat']);
Db = D.MWTDatabase.mwt;


%% get plate pictures
pSave = [pSaveHome,'/plate image'];
if isdir(pSave) == 0; mkdir(pSave); end
rc = '100s30x10s10s';

%% load included exp
str = sprintf('%s/Dance_Glee_Preggers/mwt_summary included.csv',pSaveHome);
T = readtable(str);
pMWT = T.mwtpath;


for mi = 1:numel(pMWT)
    pmwt = pMWT{mi};
    [f,p] = dircontent(pmwt,'*.png');
    p(regexpcellout(f,'^[.]'))= [];  % ignore temp files

    if numel(p) == 1
        ps = char(p);
        a = parseMWTinfo(pMWT(mi));

        pd = sprintf('%s/%s %s %s.png',pSave,char(a.groupname), char(a.expname), char(a.mwtname));
       copyfile(ps,pd); 
    else
        error('too many png');
    end
end

