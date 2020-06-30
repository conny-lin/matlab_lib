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
% ----------------------

% data path -------------
pDataRaster = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/raster_RespondOnly_20161013/Figure';
pDataLine = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/rType_acc_fig_2color/Figure';
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


for si = 1:numel(strainNames) %% loop for group folders
    
    % get strain info ---------------
    strain = strainNames.strain{si};
    pStrain = fullfile(pDataRaster, strain);
    genotype = strainNames.genotype{si};
    groups = {'N2',strain;'N2_400mM',[strain,'_400mM']}';
    % ------------------------------
    
%     for ti = 1:numel(tnamelist)
    % time info ---------------
    tname = 't1'; %tnamelist{ti};
    tnamesave = tname; %tnamesavelist{ti};
    % --------------------------
    % create 4x4 raster ---------------------
    IM = cell(size(groups,1), size(groups,2));
    trimleft = 40;
    trimtop = 30;
    for rowi = 1:size(groups,1)
        for col = 1:size(groups,2)
            % vertical list (by 0mM]
            gn = groups{rowi, col};
            p = fullfile(pDataRaster, tname,strain,[gn,'.tif']);
            I = imread(p);
            I = I(trimtop:end-trimtop, trimleft:end-trimleft,:); % trim figure
            IM{rowi,col} = I;
        end
    end
    IM1 = cell2mat(IM);
    % ----------------------------

    % time info ---------------
    tname = 't28_30'; %tnamelist{ti};
    tnamesave = tname; %tnamesavelist{ti};
    % --------------------------
    % create 4x4 raster ---------------------
    IM = cell(size(groups,1), size(groups,2));
    trimleft = 40;
    trimtop = 30;
    for rowi = 1:size(groups,1)
        for col = 1:size(groups,2)
            % vertical list (by 0mM]
            gn = groups{rowi, col};
            p = fullfile(pDataRaster, tname,strain,[gn,'.tif']);
            I = imread(p);
            I = I(trimtop:end-trimtop, trimleft:end-trimleft,:); % trim figure
            IM{rowi,col} = I;
        end
    end
    IM2 = cell2mat(IM);
    % ----------------------------


    % space ----------------------
    leftspace = 100;
    topspace = 100;
    midspace = 150;
    colorcode = 225;
    % ---------------------------
    % add sidebar -----------------
    [nrow,ncol,nlayer] = size(IM1);
    SideBar = repmat(colorcode,nrow,leftspace,3);
    % ---------------------------

    IMMH = [[SideBar IM1], [SideBar IM2]];

    % add header ------------------
    [nrow,ncol,nlayer] = size(IMMH);
    Header = repmat(colorcode,topspace,ncol,3);
    % ----------------------------
    % add bottom space -----------
    [nrow,ncol,nlayer] = size(IMMH);
    IMmid = repmat(colorcode,midspace,ncol,3);
    % ---------------------------

    IMMH = [Header;IMMH;IMmid];


    % figure ------------------------
    close all;
    figure1 = figure('Visible','on','Position',[0 0 5 5],'PaperPosition',[0 0 5 5]);
    imshow(IMMH)
    % y axis label
    fs = 10; leftalign = 80; 
    text(leftalign,300,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
    text(leftalign,750,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');

    % strain names
    fs = 10;     leftalign = 20;     
    text(leftalign,300,'wildtype','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
    text(leftalign,750,genotype,'Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');

    % concentration
    topalign = 60;     fs = 10;
    condition = {'0mM','400mM'};
    text(300,topalign,condition{1},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
    text(700,topalign,condition{2},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
    text(1150,topalign,condition{1},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
    text(1500,topalign,condition{2},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');

    % strain
    topalign = 0;     fs = 10;
    text(500,topalign,'tap 1','Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
    text(1350,topalign,'tap 30','Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');

    % --------------------------------


    % save figure ----------------
    pSaveFig = fullfile(pM,tname);
    if ~isdir(pSaveFig); mkdir(pSaveFig); end
    savename = fullfile(pSaveFig, strain);
    print(savename,'-dtiff'); 
    % -----------------------------

%% reload figure
I = imread([savename,'.tiff']);
imshow(I)
size(I)

return
  
%% load line graphs -----------------------------------
p = fullfile(pDataLine, 't1',[strain,'.tif']);
I1 = imread(p);
p = fullfile(pDataLine, 't28_30',[strain,'.tif']);
I2 = imread(p);
% -----------------------------------------------------

IMline = [I1 I2];
imshow(IMline)

%%
[nrow,ncol,nlayer] = size(IMMH);
    % add sidebar -----------------
    [nrow,ncol,nlayer] = size(I1);
    SideBar = repmat(colorcode,nrow,leftspace,3);
    MiddleBar = repmat(colorcode,nrow,500,3);
    % ---------------------------
IM = [[SideBar I1] [MiddleBar I2] SideBar];
imshow(IM);
size(IM)  

end
%% script done

fprintf('\nDONE\n');






