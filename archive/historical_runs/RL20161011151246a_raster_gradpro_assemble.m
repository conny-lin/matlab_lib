%% INITIALIZING --------------------
clc; clear; close all; % clean memory
% paths
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------



%% SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% iv
% pvlimit = 0.001;
% alpha = 0.05;
% baselinetime = -0.1;
% responseT1 = 0.1;
% responseT2 = 1;
% phenotypeName = 'acceleration response probability';
% phenotypeNameCap = 'Acceleration response probabilty';
% rtime = [0.1:0.1:0.5]';
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
    raster2name = char(dircontent(praster,'rasterPlot_388_398*.tif'));
    groups = {'N2',strain;'N2_400mM',[strain,'_400mM']}';
    % ------------------------------
    
    % time = 1 ----------------------
    tname = '98_108';
    IM = cell(size(groups,1), size(groups,2)+1);
    coln = 1;
    ti = 1;
    for col = 1:size(groups,2)+1
        % vertical list (by 0mM]
        gn = 'N2';
        praster = fullfile(pStrain, gn,'raster hot');
        p = fullfile(praster, char(dircontent(praster,['rasterPlot_',tname,'*.tif'])));
        I = imread(p);
%         p = fullfile(praster,char(dircontent(praster,'rasterPlot_388_398*.tif')));
%         IW0tf = imread(p);
        % trim figure
        I = I(50:end-50,100:end-100,:);
        IM{ti,col} = I;
    end
    imshow(I)
    return
    
    
    gn = 'N2_400mM';
    praster = fullfile(pStrain, gn,'raster hot');
    p = fullfile(praster, char(dircontent(praster,'rasterPlot_98_108*.tif')));
    IW4t1 = imread(p);
    p = fullfile(praster,char(dircontent(praster,'rasterPlot_388_398*.tif')));
    IW4tf = imread(p);
    
    gn = strain;
    praster = fullfile(pStrain, gn,'raster hot');
    p = fullfile(praster, char(dircontent(praster,'rasterPlot_98_108*.tif')));
    IMut0t1 = imread(p);
    p = fullfile(praster,char(dircontent(praster,'rasterPlot_388_398*.tif')));
    IMut0tf = imread(p);
    
    gn = [strain,'_400mM'];
    praster = fullfile(pStrain, gn,'raster hot');
    p = fullfile(praster, char(dircontent(praster,'rasterPlot_98_108*.tif')));
    IMut4t1 = imread(p);
    p = fullfile(praster,char(dircontent(praster,'rasterPlot_388_398*.tif')));
    IMut4tf = imread(p);
    % -----------------------------------------
    
    %%
    I = IW4t1(50:end-50,100:end-100,:);
    imshow(IW4t1)


    % add header
    [nrow,ncol,nlayer] = size(IMM);
    Header = repmat(255,300,ncol,3);
    IMMH = [Header;IMM];
    [nrow,ncol,nlayer] = size(IMMH);
    SideBar = repmat(255,nrow,200,3);
    IMMH = [SideBar IMMH];
    
    
    
    
    %% assemble pictures -----------------------------------------------------
    timenames = {'98-128','238-268','368-398'};
    targetfigureName = {'speed dir proportion plot','raster gradient'};

    [~,gname] = cellfun(@fileparts,pG,'UniformOutput',0);

    % find strain sets
    a = regexpcellout(gname,'_','split');
    i = cellfun(@isempty,a(:,2));
    strain = a(i,1);
    strain_condition = gname(~i);
    group_condition = [strain strain_condition];
    condition = a(~i,2);
    pGCI = [pG(i) pG(~i)];
    for tfni = 1:numel(targetfigureName);
        figureprefix = targetfigureName{tfni};
        for gci = 1:size(group_condition,1)
            gname = group_condition(gci,:);
            IM = cell(numel(timenames),numel(gname));
            pgc = pGCI(gci,:);
            for si = 1:numel(gname)
                pg = pgc{si};
                [~,gn] = fileparts(pg);

                pfolder = sprintf('%s/%s',pg,figureprefix);
                [figurename,pfigure] = dircontent(pfolder);
                pfigure(~regexpcellout(pfigure,'[.]tif\>')) = [];
                % get images
                for ti = 1:numel(timenames)
                    p = pfigure{regexpcellout(pfigure,timenames{ti})};
                    [~,fn] = fileparts(p);
                    fprintf('loading file: %s/%s\n',gn,fn);
                    
                    I = imread(p);
                    % trim figure
                    I = I(50:end-50,100:end-100,:);
                    IM{ti,si} = I;
                end
            end

            IMM = cell2mat(IM);

            % add header
            [nrow,ncol,nlayer] = size(IMM);
            Header = repmat(255,300,ncol,3);
            IMMH = [Header;IMM];
            [nrow,ncol,nlayer] = size(IMMH);
            SideBar = repmat(255,nrow,200,3);
            IMMH = [SideBar IMMH];
            
            % figure 
            figure1 = figure('Visible','off');
            imshow(IMMH)
            % y axis
            fs = 15; leftalign = 185;
            text(leftalign,700,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
            text(leftalign,1500,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
            text(leftalign,2300,'% total','Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
            % time names
            fs = 20;     leftalign = 80;     
            text(leftalign,700,timenames{1},'Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
            text(leftalign,1500,timenames{2},'Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
            text(leftalign,2300,timenames{3},'Rotation',90,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');

            % concentration
            topalign = 220; fs = 20;
            text(750,topalign,'0mM','Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
            text(1700,topalign,condition{gci},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');
            % strain
            topalign = 100; fs = 20;
            text(1200,topalign,gname{1},'Rotation',0,'FontSize',fs,'HorizontalAlignment','center','VerticalAlignment','middle');

            % save
            cd(pData);
            titlename = sprintf('%s/%s composit %s',pData,figureprefix,gname{1});
            print(figure1,'-depsc', titlename); % save as (r600 will give better resolution)
            print(figure1,'-dtiff', titlename); % save as (r600 will give better resolution)
            close;
        end
    end

end
%% script done

fprintf('\nDONE\n');






