%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pD = fileparts(pM);
pSave = pM;
% --------------------
% load MWTDB +++++++
load(fullfile(pD,'MWTDB.mat'),'MWTDB');
pMWT = MWTDB.mwtpath;
% -----------------

% settings ++++++
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% IMPORT HABITUATION CURVES DATA ========================================
Data = importHabCurveData(pMWT);
% create tap data obj ++++++++++++++++++++++
TD = TapData;
v = {'mwtpath','groupname','tap'};
for vi = 1:numel(v)
    TD.(v{vi}) = Data.(v{vi});
end
msrlist = {'RevFreq','RevSpeed','RevDur'};
TD.Response = table2array(Data(:,msr));
TD.Measures = msr;
% ------------------------------------------
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
save(fullfile(pSave,'data.mat'),'Data','G','textout');
% ----------------------
% =========================================================================



%% Graph ==================================================================

% plot line graph +++++++++++++++++++++++++++
for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    
    fig1 = plotHabStd(TD,msr,'off');

    % adjust color +++++
    color = color_rainbow;
    f1 = get(fig1);
    a1 = get(f1.Children);
    e1 = get(a1.Children);
    for x =1:size(color,1)
        c = color(x,:);
        f1.Children.Children(x).Color = c;
        f1.Children.Children(x).MarkerFaceColor = c;
        f1.Children.Children(x).MarkerEdgeColor = c;
    end
    % ------------------
    
    % save +++++++
    savename = sprintf('%s/%s %s',pSave,strain,msr);
    printfig(savename,pSave,'w',w,'h',h,'closefig',1);
    % ------------
end
% ------------------------------------------

% =========================================================================




%% report done ++++++++++++
fprintf('\nDONE\n');
return
% -------------------------

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

















