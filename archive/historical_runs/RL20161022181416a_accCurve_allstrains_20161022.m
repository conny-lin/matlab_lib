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
    Data = Dance_rType(pData);
    
    
    
    
    % DESCRIPTIVE STATS & RMANOVA N=PLATES ==================================
    % anova +++++++++++++++++
    msrlist = {'AccProb'};
    rmName = 'tap';
    fName = {'dose','strain'};
    fNameInd = 'groupname';
    fNameS = strjoin(fName,'*');
    idname = 'mwtpath';

    for msri = 1:numel(msrlist)

        msr = msrlist{msri};


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

    end


    % get graphic data +++++++++++
    Data1 = Data(:,[{'groupname','tap'},msrlist]);
    G = statsByGroup(Data, msrlist,'tap','groupname');
    % -------------------------

    % save data ++++++++++++
    cd(pSave);
    save('data.mat','Data','G','textout');
    % ----------------------
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


