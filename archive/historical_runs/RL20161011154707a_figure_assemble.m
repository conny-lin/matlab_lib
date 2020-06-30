%% INITIALIZING --------------------
clc; clear; close all; % clean memory
% paths
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------



%% SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph setting ---------

% ----------------------

% data path -------------
pDataRaster = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/x-ratser 10sISI by strains RasterNew green/Raster_green_RL20161004';
% get strain data ------------
% get group folders
fn = dircontent(pDataRaster);
a = regexpcellout(fn,'[A-Z]{2,}\d{1,}','match');
a(cellfun(@isempty,a)) = [];
strain_name_list = unique(a);
% --------------------------

% get strain info  -----------
load('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/MWTDatabase/StrainNames.mat');
strainNames(~ismember(strainNames.strain,strain_name_list),:) = [];
strainNames = sortrows(strainNames,{'genotype'});
% -------------------------



for si = 1:numel(strainNames) %% loop for group folders
    
    % get strain info ---------------
    strain = strainNames.strain{si};
    pStrain = fullfile(pDataRaster, strain);
    genotype = strainNames.genotype{si};
    groups = {'N2',strain;'N2_400mM',[strain,'_400mM']}';
    % ------------------------------
    
    % rotate
    tnamelist = {'98_108','388_398'};
    tnamesavelist = {'t1','t30'};
    
    for ti = 1:numel(tnamelist)
        tname = tnamelist{ti};

        % load raster ---------------------
        IM = cell(size(groups,1), size(groups,2));
        for rowi = 1:size(groups,1)
            for col = 1:size(groups,2)
                % vertical list (by 0mM]
                gn = groups{rowi, col};
                praster = fullfile(pStrain, gn,'raster hot');
                p = fullfile(praster, char(dircontent(praster,['rasterPlot_',tname,'*.tif'])));
                I = imread(p);
                I = I(50:end-50, 100:end-500,:); % trim figure
                IM{rowi,col} = I;
            end
        end
        IMM = cell2mat(IM);
        % ----------------------------

        % add header ------------------
        [nrow,ncol,nlayer] = size(IMM);
        Header = repmat(255,300,ncol,3);
        IMMH = [Header;IMM];
        [nrow,ncol,nlayer] = size(IMMH);
        SideBar = repmat(255,nrow,200,3);
        IMMH = [SideBar IMMH];
        % ---------------------------

        % figure ------------------------
        close all;
        figure1 = figure('Visible','on');
        imshow(IMMH)
        % y axis label
        fs = 40; leftalign = 150; 
        text(leftalign,660,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
        text(leftalign,1450,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');

        % strain names
        fs = 50;     leftalign = 40;     
        text(leftalign,660,'wildtype','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
        text(leftalign,1450,genotype,'Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');

        % concentration
        topalign = 250;     fs = 50;
        condition = {'0mM','400mM'};
        text(540,topalign,condition{1},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
        text(1080,topalign,condition{2},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');

        % strain
        topalign = 100;     fs = 60;
        text(800,topalign,['tap ',num2str(ti)],'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
        % --------------------------------

        % save figure ----------------
        pSaveFig = fullfile(pM,tname);
        if ~isdir(pSaveFig); mkdir(pSaveFig); end
        savename = fullfile(pSaveFig, strain );
        printfig(savename,pM,'w',3,'h',3)
        % -------------------------------------------------
        
        return
    end

    

end
%% script done

fprintf('\nDONE\n');






