%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pD = fileparts(pM);
pSave = pM;
msrlist = {'speed','curve'};

% load MWTDB +++++++
load(fullfile(pD,'MWTDB.mat'),'MWTDB');
pMWT = MWTDB.mwtpath;
% -----------------

% settings ++++++
timelist= [5 10 95];
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% IMPORT HABITUATION CURVES DATA =========================================
% check trv files
[pTrv,~,pMWTnoTRV] = getpath2chorfile(pMWT,'*.trv');
% import legend
pTrvLegend = '/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Chor_output_handling/legend_trv.mat';
load(pTrvLegend);
% get necessary legends
legend_output = {'tap','time', 'N_alreadyRev', 'N_ForwardOrPause', 'N_Rev', 'RevDis', 'RevDur'};
ind_get = find(ismember(legend_trv,legend_output));

S = struct;
for mwti =1:numel(pTrv)
    pf = pTrv{mwti};
    if size(pf,1) > 1; error('fix trv paths'); end
    % see version of trv
    d = dlmread(pf);
    ncol = size(d,2);
    if ncol ~= numel(legend_trv); error('trv col number wrong'); end
    % add tap
    tapnumber = (1:size(d,1))';
    D = array2table([tapnumber,d(:,ind_get)],'VariableNames',legend_output);
    % frequency is # reversed divided by total number not already reversing
    D.RevFreq = D.N_Rev./(D.N_Rev + D.N_ForwardOrPause);
    % calculate reversal speed: reversal speed is reversal distance divided by reversal duration
    D.RevSpeed = D.RevDis./D.RevDur;
    D.RevDis = [];
    % prepare summary output identifiers
    pmwt = fileparts(pf);
    db = parseMWTinfo(pmwt);
    dbname = {'expname','groupname','mwtname'};
    S(mwti).mwtpath = {pmwt};
    S(mwti).expname = db.expname;
    S(mwti).groupname = db.groupname;
    S(mwti).mwtname =  db.mwtname;
    % enter variable in structural array
    vnames = D.Properties.VariableNames;
    for vi = 1:numel(vnames)
        vn = vnames{vi};
        S(mwti).(vn) = D.(vn);
    end
end

% expand import into table
n = arrayfun(@(x) numel(x.tap),S);
nrow = sum(n);
rowi = [0 cumsum(n)];
vnames = fieldnames(S);
identifiers = {'expname', 'groupname', 'mwtname','mwtpath'};
varn = vnames(~ismember(vnames,identifiers));
msrlist = varn(~ismember(varn,'wormid'));
% prepare table
Data = table;
for vi = 1:numel(identifiers)
    v = identifiers{vi};
    a = cell(nrow,1); 
    for i = 1:numel(S); a(rowi(i)+1:rowi(i+1)) = S(i).(v); end
    Data.(v) = a;
end
% variables
for vi = 1:numel(varn)
    v = varn{vi};
    A  = cell(size(S)); for i = 1:numel(S); A{i} = S(i).(v); end
    Data.(v) = cell2mat(A');
end
% =========================================================================




%% DESCRIPTIVE STATS & RMANOVA N=PLATES ==================================
% anova +++++++++++++++++
msrlist = {'RevDur','RevFreq','RevSpeed'};
rmName = 'tap';
fName = {'dose'};
idname = 'mwtname';

for msri = 1:numel(msrlist)
    
    msr = msrlist{msri};

    % prep anova variables +++++++++++
    a = regexpcellout(Data.groupname,'(?=[_]).{1,}','match');
    a(cellfun(@isempty,a)) = {'0mM'};
    a = regexprep(a,'_','');
    Data.dose = a;
    % ---------------------------------
    
    % anova +++++++++++++++++++++++++++++++++++++++
    A = anovarm_convtData2Input(Data,rmName,fName,msr,idname);
    textout = anovarm_std(A,rmName,'dose','dose');
    % -----------------------------------------------
    
    % save data ++++++++++++
    cd(pSave);
    p = sprintf('%s RMANOVA.txt',msr);
    fid = fopen(p,'w');
    fprintf(fid,'%s',textout);
    fclose(fid);
    % ----------------------

end


% get graphic data +++++++++++
Data1 = Data(:,[{'groupname','tap'},msrlist]);
G = statsByGroup(Data, msrlist,'tap','groupname');
% -------------------------
 
% save data ++++++++++++
cd(pSave);
save('data.mat','Data','G','textout');
% ----------------------


%% REPORT DONE
fprintf('\nDONE\n');
return
% =========================================================================

















