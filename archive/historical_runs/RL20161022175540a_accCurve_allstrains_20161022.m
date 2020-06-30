%% raster plot data all strains

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
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
% get strain info
s = dircontent(pData);
strainNames = DanceM_load_strainInfo(s);
pathwayseq = {'VGK'
    'neuropeptide'
    'Synaptic'
    'Neuroligin'
    'Gluamate'
    'Dopamine'
    'G protein'
    'Gai'
    'Gaq'
    'Gas'
    'TF'};
strainNames.seq = zeros(size(strainNames,1),1);
y = 1;
for x = 1:numel(pathwayseq)
    i = ismember(strainNames.pathway,pathwayseq{x});
    
    k = sum(i);
    strainNames.seq(i) = y:y+k-1;
    y = y+k;
end
strainNames = sortrows(strainNames,{'seq'});
strainlist = strainNames.strain;
%----------------

% time settings
taptimes = [100:10:(10*29+100)];
time_tap_col = 6;
time_baseline_col = 3:5;
time_response_col = 7:10;
rTarget = 'accelerate forward';
rTargetName = 'acceleration';
n_lowest = 10;

% ------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% check incomplete =======================================================
% needDance = true(size(strainNames,1),1);
% for si = 1:size(strainNames.strain,1)
%     % strain info +++++
%     strain = strainNames.strain{si};
%     genotype = strainNames.genotype{si};
%     % ------------------
%     
%     % report progress %------------
% %     fprintf(''); % separator
% %     processIntervalReporter(numel(strainlist),1,'*** strain ****',si);
%     % ------------------------------
%    
%     % create save path +++++++++++++++++++
%     prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
%     suffix = 'Raster/Dance_Raster';
%     pSave = fullfile(prefix,strain,suffix);
%     % -----------------------------------
% 
%     % check if has dance result +++++++++++
%     if isdir(pSave)
%         
%         % load data +++++++++++++++++++
%         prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
%         suffix = 'MWTDB.mat';
%         p = fullfile(prefix,strain,suffix);
%         load(p);
%         % ---------------------------------
%         
%         %% check if last group has raster plot 389
%         gnlist = unique(MWTDB.groupname);
%         gnlast = gnlist{end};
%         p = fullfile(pSave,gnlast);
%         if isdir(p)
%             a = dircontent(p);
%             i = regexpcellout(a,'rasterPlot_389');
%             k = sum(i)==1;
%             if k
%                needDance(si) = false;
%                fprintf('%s done\n',strain)
%             end
%         end
%     end
%     % -----------------------------------
% 
% end
% strainNames = strainNames(needDance,:);
% % =========================================================================




%% cycle through strain ===================================================
for si = 1:size(strainNames.strain,1)
    % strain info +++++
    strain = strainNames.strain{si};
    genotype = strainNames.genotype{si};
    % ------------------
    
    % report progress %------------
    fprintf(''); % separator
    processIntervalReporter(size(strainNames.strain,1),1,'*** strain ****',si);
    % ------------------------------
   
    % create save path +++++++++++++++++++
    prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
    suffix = 'TAR';
    pSave = fullfile(prefix,strain,suffix);
    % -----------------------------------

    % get MWTDB +++++++
%     prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
%     suffix = 'MWTDB.mat';
%     pMWTDB = fullfile(prefix,strain,suffix);
%     load(pMWTDB);
    % ---------------
    
    % data path +++++++++++++++++++
    prefix = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/3-Genes/3-Results/0-Data/10sIS by strains';
    suffix = 'Raster/Dance_Raster';
    pData = fullfile(prefix,strain,suffix);
    % ------------------------------
    
    % get data per tap per group ++++++++++++++
    [~,~,groupnames] = dircontent(pData);
    
    MeanMaster = cell(numel(groupnames),1);
    NMaster = MeanMaster;
    TimeMaster = MeanMaster;
    pMWTMaster = MeanMaster;
    
    for gi =1:numel(groupnames)
        
        gn = groupnames{gi};
        p = fullfile(pData,gn);
        rasterfiles = dircontent(p,'*mat');
        
        %% find t1
        a = regexpcellout(rasterfiles,'(_)|\s','split');
        t1 = cellfun(@str2num,a(:,2));
        tf = cellfun(@str2num,a(:,3));
        n = cellfun(@str2num,a(:,5));
        
        [c,seq] = sort(t1);
        rasterfiles = rasterfiles(seq);
        

        MeanSum = cell(numel(rasterfiles),1);
        SESum = MeanSum;
        NSum = MeanSum;
        MWTPATH = MeanSum;
        TimeSum = MeanSum;
        
        for ri = 1:numel(rasterfiles)
            % get data -------------------------
            p = fullfile(pData, gn,rasterfiles{ri});
            Data = load(p);
            D = Data.Data;
            rTime = Data.rTime(1,:);
            mwtid = Data.mwtid;
            pMWT = Data.pMWT;
            MWTDB = parseMWTinfo(pMWT);
            % -----------------------------------
            
 
            % get response type summary %--------------
            % input data 
            Baseline = D(:,time_baseline_col);
            Response = D(:,time_response_col);
            [T1, RTclean, R, RN,leg] = compute_response_type(Response, Baseline, 'pSave',pM);
            R = cell2table(R);
            % ---------------------------------
            
            % add plate info % --------------
            plateinfo = table;
            plateinfo.mwtid = mwtid;
            plateinfo.timeid = repmat(ri,size(mwtid,1),1);
            plateinfo.wormid = (1:numel(mwtid))';
            % ---------------------------------


            % calculate response type (acceleration) --------------
            % summarize response type by plate
            [A,N,NV,mwtidlist] = responseType_pct_plate(plateinfo,R,rTarget,'Type','any');
            % rid of data with NaN ouputs
            invalid = any(N < n_lowest,2) & any(isnan(A),2);
            % rid of N lower than n limist
            RespNv = A;
            RespNv(invalid,:) = NaN;
            % summarize response type by group
%             [Mean, SEM, SampleSize, tt,MWTDBv] = sum_RType_byGroup(MWTDB, mwtidlist,RespNv,NV);
            % ---------------------------------------

            MWTPATH{ri} = pMWT(mwtidlist);
            MeanSum{ri} = RespNv;
            NSum{ri} = N;
            TimeSum{ri} = repmat(ri,size(A,1),1);
        end
        
        %% take out cell
        MeanSum = cell2mat(MeanSum);
        NSum = cell2mat(NSum);
        TimeSum = cell2mat(TimeSum);
        MWTPATH = celltakeout(MWTPATH);
        
        MeanMaster{gi} = MeanSum;
        NMaster{gi} = NSum;
        TimeMaster{gi} = TimeSum;
        pMWTMaster{gi} = MWTPATH;
    
    end
    
    
    MeanMaster = cell2mat(MeanMaster);
    NMaster = cell2mat(NMaster);
    TimeMaster = cell2mat(TimeMaster);
    pMWTMaster = celltakeout(pMWTMaster);
    
    %% put in table
    M = parseMWTinfo(pMWTMaster);
    D = table;
    D.mwtpath = M.mwtpath;
    D.groupname = M.groupname;
    D.time = TimeMaster;
    D.mean = MeanMaster;
    D.n = NMaster;
    
    return
    %% ===================================================================
    
    
    

    % sort by N2 ---------------------------
    Mean = sortN2first(gnlist, Mean); 
    SEM = sortN2first(gnlist, SEM); 
    gnlist = sortN2first(gnlist,gnlist);
    % --------------------------------------

    % figure ---------------------------------------
    % prepare time
    time = [time_response(1):0.1:time_response(2)];
    time = repmat(time,size(Mean,1),1);
    % prepare genotype
    genotype = strainNames.genotype{si};
    % make figure
    figure1 = createfigure_rType(time', Mean', SEM', gnlist, genotype,rTargetName);
    % ------------------------------------------------

    % save figure ----------------
    pSaveFig = create_savefolder(fullfile(pM,'Figure'),tname);
    savename = fullfile(pSaveFig, strain );
    printfig(savename,pM,'w',3,'h',3)
    % -------------------------------------------------

    % statistics -------------------
    T = table;
    T.gname = MWTDBv.groupname;
    t = RespNv;
    T = [T array2table(t)];
    % rid of nan output
    T(any(isnan(RespNv),2),:) = [];
    [ST,textfile] = RType_stats(T);
    % ------------------------------

    % save result % ------------------
    pS = create_savefolder(fullfile(pM,'Data'),tname);
    savename = fullfile(pS, strain);
    gname = sortN2first(gnlist,gnlist);
    save(savename, 'R','leg','plateinfo','ST','RN',...
        'textfile','Mean', 'SEM', 'A','N','NV',...
        'mwtidlist','MWTDB','SampleSize','gname','RespNv');
    % ---------------------------------

    % save text result ---------------
    pS = create_savefolder(fullfile(pM,'Stats'),tname);
    savename = fullfile(pS, [strain,'.txt'] );
    fid = fopen(savename,'w');
    fprintf(fid,'%s',textfile);
    fclose(fid);
    % -------------------------------


    return
    %% ----------------------------
    
%     suffix = 'MWTDB.mat';
    
    load(p);
    % ---------------------------------

    % check if all MWTDB are dir ++++++++++
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
    
    % clear command window +++++++
    clc;
    % -----------------------------------

end
% =========================================================================


