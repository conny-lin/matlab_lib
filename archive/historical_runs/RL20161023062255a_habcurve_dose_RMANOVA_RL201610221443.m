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
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return



%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% IMPORT HABITUATION CURVES DATA +++++++++++++
Data = importHabCurveData(pMWT);
% --------------------------------------------


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
    
    % save text data ++++++++++++
    p = fullfile(pSave,sprintf('%s RMANOVA.txt',msr));
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
% =========================================================================



%% Graph ==================================================================



% =========================================================================
s



%% report done ++++++++++++
fprintf('\nDONE\n');
return
% -------------------------

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

















