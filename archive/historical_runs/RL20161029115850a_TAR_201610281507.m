%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths & settings -----------
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
% ---------------------------

% strains %------
pDataHome = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/2-Wildtype/3-Results/0-Data/10sISI Dose';
%----------------

% time settings
taptimes = [100:10:(10*29+100)];
% ------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% MAIN CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% raster ==================================================================
% create save path +++++++++++++++++++
pSave = fullfile(pDataHome,'Raster');
% -----------------------------------

% load mwt paths +++++++++++++++++++
load(fullfile(pDataHome,'MWTDB.mat'));
% check if all MWTDB are dir
i = cellfun(@isdir,MWTDB.mwtpath);
if sum(i) ~= numel(i)
   MWTDB(~i,:) = [];
   if isempty(MWTDB)
       error('no data');
   end
end
% ---------------------------------- 

% dance raster ++++++++++++++++
if ~isempty(MWTDB)
    Dance_Raster(MWTDB,'pSave',pSave,'graphopt',0);
end
% ----------------------------
% =========================================================================


%% TAR ====================================================================
% create save path +++++++++++++++++++
pSave = create_savefolder(fullfile(pDataHome,'TAR'));
% -----------------------------------

% data path +++++++++++++++++++
pData = fullfile(pDataHome,'Raster/Dance_Raster');
% ------------------------------

% Dance_rType ++++++++++++++ (this will not run), load data from this
Data = Dance_rType(pData,'pSave',pSave);
% -------------------------
pSave = fullfile(pSave,'Dance_rType');
% =========================================================================


%% DESCRIPTIVE STATS & RMANOVA N=PLATES ==================================
% get food/nofood +++++++++++++++++
% g = Data.groupname;
% gfood = repmat({'Food'},size(g,1),1);
% i = regexpcellout(g,'NoFood');
% gfood(i) = {'NoFood'};
% Data.food = gfood;
% 
% gdose = repmat({'0mM'},size(g,1),1);
% i = regexpcellout(g,'400mM');
% gdose(i) = {'400mM'};
% Data.dose = gdose;
% % ------------------------------


% anova +++++++++++++++++
rmName = 'tap';
fName = {'dose'};
fNameInd = 'groupname';
fNameS = strjoin(fName,'*');
idname = 'mwtpath';
msr = 'AccProb';

% anova +++++++++++++++++++++++++++++++++++++++
A = anovarm_convtData2Input(Data,rmName,[fName,fNameInd],msr,idname);
textout = anovarm_std(A,rmName,fNameInd,fNameS);
% -----------------------------------------------

% save data ++++++++++++
cd(pSave);
p = sprintf('%s RMANOVA.txt',msr);
fid = fopen(p,'w');
fprintf(fid,'%s',textout);
fclose(fid);
% ----------------------
% =========================================================================



%% graph ==================================================================
%% sort groups properly and lable no food as purple

graphpackname = 'bkrainbowline';
msrlist = {'AccProb'};
gns = {'N2','N2_100mM','N2_200mM','N2_300mM','N2_400mM',...
    'N2_500mM','N2_600mM'};    

for msri = 1:numel(msrlist)

    msr = msrlist{msri};
    
    % get graph data ----------------
    D = G.(msr);
    y = D.Y;
    e = D.E;
    x = D.X;
    gn = D.groupname;
    D1(:,:,1) = x;
    D1(:,:,2) = y;
    D1(:,:,3) = e;
    
    % sort by N2
%     gns = sortN2first(gn,gn);
    [i,j] = ismember(gn,gns);
    D1 = D1(:,j,:);    
    X = D1(:,:,1);
    Y = D1(:,:,2);
    E = D1(:,:,3);
    % -------------------------------

    % setting --------------------------
    w = 4.5;
    h = 3.5;
    gp = graphsetpack(graphpackname);
    gnss = regexprep(gns','_',' ');
%     gnss = regexprep(gnss,strain,genotype);
    gnss = regexprep(gnss,'N2','Wildtype');
    gp.DisplayName = gnss;
    gpn = fieldnames(gp);
    % -----------------------------------

    % plot ------------------------------------------
    fig = figure('Visible','on','PaperSize',[w h],'Unit','Inches',...
        'Position',[0 0 w h]); 
    ax1 = axes('Parent',fig,'XTick',[0:10:30]); 
    hold(ax1,'on');
    e1 = errorbar(X,Y,E,'Marker','o','MarkerSize',4.5);
    % -----------------------------------------------

    % get settings -----------------------------------
    for gi = 1:numel(gn)
        for gpi = 1:numel(gpn)
            e1(gi).(gpn{gpi}) = gp.(gpn{gpi}){gi};
        end
    end
    % -----------------------------------------

    % title -------------------------
%     title(genotype)
    % -------------------------------

    % legend ------------------------
    %     lg = legend('show');
    %     lg.Location = 'eastoutside';
    %     lg.Box = 'off';
    %     lg.Color = 'none';
    %     lg.EdgeColor = 'none';
    %     lg.FontSize = 8;
    % -------------------------------

    % x axis -----------------------------------------------
    xlabel('Tap')
    xlim([0 30.5]);
    % --------------------------
    % y axis ---------------------
    yname = sprintf('P (%s)',rTargetName);
    ylim([0 1]);
    ylabel(yname);
    % ------------------------
    % axis ------------------------------------
    axs = get(ax1);
    ax1.TickLength = [0 0];
    ax1.FontSize = 10;
    % ----------------------------------------------------

    % save -------------------------------------------
    savename = sprintf('%s/%s',pSave,msr);
    printfig(savename,pSave,'w',w,'h',h,'closefig',1);
    % -------------------------------------------
end
% =========================================================================


%% -------------------
    

% end


