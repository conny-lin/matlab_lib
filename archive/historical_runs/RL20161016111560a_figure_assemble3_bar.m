%% INITIALIZING ===========================================================
clc; clear; close all; % clean memory
% paths
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% =========================================================================



%% SETTINGS ===============================================================
% graph setting ---------
tnamesavelist = {'t1','t28_30'};
tnamelist = tnamesavelist;
colorcode = 225;
% ----------------------

% data path -------------
pDataRaster = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/raster_RespondOnly_20161013/Figure';
pDataBar = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/rType_fig_bar/Figure';
% get strain data 
fn = dircontent(fullfile(pDataRaster,tnamesavelist{1}));
a = regexpcellout(fn,'[A-Z]{2,}\d{1,}','match');
a(cellfun(@isempty,a)) = [];
strain_name_list = unique(a);
% --------------------------

% get strain info  -----------
load('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/MWTDatabase/StrainNames.mat');
strainNames = DanceM_load_strainInfo(strain_name_list);
strainNames = sortrows(strainNames,{'genotype'});
% -------------------------
% =========================================================================


for si = 1:size(strainNames,1) %% loop for group folders
    
    % get strain info ---------------
    strain = strainNames.strain{si};
    pStrain = fullfile(pDataRaster, strain);
    genotype = strainNames.genotype{si};
    groups = {'N2',strain;'N2_400mM',[strain,'_400mM']}';
    % ------------------------------
    
    %% bar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % reload figure
%     p = fullfile(pDataBar,'t1',[strain,'.tif']);
%     I = imread(p);
%     I = I(105:end-200, :,:); % trim figure
    % load line graphs -----------------------------------
    p = fullfile(pDataBar, 't1',[strain,'.tif']);
    I1 = imread(p);
    p = fullfile(pDataBar, 't28_30',[strain,'.tif']);
    I2 = imread(p);
    % -----------------------------------------------------

    % add sidebar -----------------
    [nrow,ncol,nlayer] = size(I1);
    LeftBar = repmat(colorcode,nrow,90,3);
    MiddleBar = repmat(colorcode,nrow,90,3);
    RightBar = repmat(colorcode,nrow,60,3);
    IM = [[I1] [MiddleBar I2]];
    
    [nrow,ncol,nlayer] = size(IM);
    TopSpace = repmat(colorcode,20,ncol,3);
    IM = [TopSpace;IM];
    % ---------------------------


    
    %% make figure -------------
    close all;
    figure1 = figure('Visible','off','Position',[0 0 5 5],'PaperPosition',[0 0 5 5]);
    imshow(IM)
    
%     % y axis label
%     fs = 10; leftalign = 80; 
%     text(leftalign,300,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
%     text(leftalign,700,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
% 
%     % strain names
%     fs = 10;     leftalign = 20;     
%     text(leftalign,300,'wildtype','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
%     text(leftalign,690,genotype,'Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
% 
%     % concentration
%     topalign = 60;     fs = 10;
%     condition = {'0mM','400mM'};
%     text(300,topalign,condition{1},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
%     text(700,topalign,condition{2},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
%     text(1150,topalign,condition{1},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
%     text(1500,topalign,condition{2},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');

    % tap time
    topalign = 0;     fs = 20;
    text(250,topalign,'tap 1','Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
    text(800,topalign,'tap 30','Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
    % -------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % save figure ----------------
    pS = create_savefolder(fullfile(pM,'Figure'));
    savename = strain;
    printfig(savename,pS,'w',10,'h',5); 
    % -----------------------------
end
%% script done

fprintf('\nDONE\n');






