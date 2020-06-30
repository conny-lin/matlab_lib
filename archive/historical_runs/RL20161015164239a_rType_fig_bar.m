%% OBJECTIVE:
% make bar graph for acceleration phenotype

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------                        

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = fileparts(pM);
% ---------------------------

% data ------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/Data';
rTarget = 'accelerate forward';
rTargetName = 'acceleration';
% get strain info
strainlist = dircontent(fullfile(pData,'t1'));
strainNames = DanceM_load_strainInfo;
timelist = dircontent(pData);
%----------------

%% graphic setting --------
color = [0 0 0; 0 0 0; 1 0 0; 1 0 0];
colorface = {'none';[0 0 0];'none';[1 0 0]};
marker = {'o','o','o','o'};
linestyle = {'--','-','--','-'};
time = 0.1:0.1:0.5;
w = 2.2;
h = 2.2;
% ------------------------

%% get strain and time specific data

for ti = 1:numel(timelist) % cycle through time
    
    % get time specific info ------------
    tname = timelist{ti};
    strainlist = dircontent(fullfile(pData,tname),'*.mat');
    strainlist = regexprep(strainlist,'[.]mat','');
    % ---------------------------
    
    for si =1:numel(strainlist)
    
        % get strain specific info ----------
        strain = strainlist{si};
        gn = {'N2','N2_400mM',strain,[strain,'_400mM']};
        genotype = strainNames.genotype(ismember(strainNames.strain,strain));
        % ----------------------------
        
        % load time and strain specific files ------------
        p =fullfile(pData,tname,[strain,'.mat']);
        load(p);
        % -----------------------------------------------

        %% summarize data by plate ------------------------
        rID = leg.id(ismember(leg.name,rTarget));
        RN_any = any(RN == rID,2);
        % get total n per plate
        [n,mwtid] = grpstats(RN_any,plateinfo.mwtid,{'numel','gname'}); 
        mwtid =cellfun(@str2num,mwtid);
        % get n of rTarget per plate
        i = RN_any == true;
        a = RN_any(i); 
        p = plateinfo.mwtid(i);
        [nv,mwtidv] = grpstats(a,p,{'numel','gname'});
        mwtidv =cellfun(@str2num,mwtidv);
        % join data
        T = table;
        T.mwtid = mwtid;
        [i,j] = ismember(T.mwtid,MWTDB.mwtid);
        T.groupname = MWTDB.groupname(j(i));
        T.n = n;
        T2 = table;
        T2.mwtid = mwtidv;
        T2.nv = nv;
        T3 = outerjoin(T,T2,'MergeKey',1);
        T3.nv(isnan(T3.nv)) = 0;
        T3.pct = T3.nv./T3.n;
        % save data
        pS = create_savefolder(fullfile(pM,'Data'),tname);
        svname = fullfile(pS,[strain, 'by plate.csv']);
        writetable(T3,svname);
        % ---------------------------------------

        %  summarize by group --------------
        [n,g,m,se] = grpstats(T3.pct,T3.groupname,{'numel','gname','mean','sem'});
        T = table;
        T.gname = g;
        T.n = n;
        T.mean = m;
        T.se = se;
        T = sortN2first(T.gname,T);
        GroupSum = T;
        % save data
        pS = create_savefolder(fullfile(pM,'Data'),tname);
        svname = fullfile(pS,[strain, ' by group.csv']);
        writetable(GroupSum,svname)
        % ---------------------------------------
        

        %% get graph data ---------------------------
        X = (1:size(GroupSum,1));
        Y = GroupSum.mean';
        E = GroupSum.se';
        GN = GroupSum.gname;
        respType = 'acceleration';
        % -----------------------------------------
        
        %% plot bar graphs ----------------------
        
        % save figure ------------------------------------
        pS = fullfile(pM,'Figure',tname,strain);
        yname = sprintf('P (%s / responses)',rTargetName);
        fig_bar(X,Y,E,GN,{'wildtype', genotype},pS,'yname',yname)
    end
end

% report done --------------
beep; beep;
fprintf('\n--- Done ---\n\n' );
return
% --------------------------





%%  old code --------------------------------------

% settings %--------------------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
n_lowest = 10;
timelist = {'t28_30','t1'};
statsName = 'exclude no response';
% frameInt = 0.2; %(ed20161004)
% assaywindow = 10;
% NWORMS = Inf;
% expLimit = 'N2 within';
% 
% % create time frames
% startList = [98 388];
% endList = startList+assaywindow;
% --------------------------------




%% RESPONSE PROBABILITY: ACC, PAUSE, NO RESPONSE, REVERSAL, DECELLEARTION
Output = struct;
for ti = 1%:numel(timelist) % cycle through time choices
    
    tname = timelist{ti};
    tfilename = ['data_ephys_',tname,'.mat'];
    
    for si = 46%1:size(strainNames,1) % cycle through strains

        % report progress %------------
        fprintf(''); % separator
        processIntervalReporter(numel(strainlist),1,'strain',si);
        % ------------------------------

        % data % -------------
        strain = strainNames.strain{si}; 
        p = fullfile(pData, strain,'ephys graph',tfilename);
        load(p,'DataG','MWTDB');
        DataG = struct2table(DataG);
        gnlist = DataG.name; % get unique groups 
        % sort by N2 first
        % ----------------

        % get assay time % ------------
        t = DataG.time{1}(1,:);
        i_baseline = find(t >= time_baseline(1) & t <= time_baseline(2));
        i_response = find(t >= time_response(1) & t<= time_response(2));
        % --------------------------

        % get response type summary %--------------
        % flatten data
        S = cell2mat(DataG.speedb);
        % input data 
        Baseline = S(:,i_baseline);
        Response = S(:,i_response);
        [~,~,R,~,leg] = compute_response_type(Response, Baseline, 'pSave',pM);
        R = cell2table(R);
        % ---------------------------------

        % add plate info % --------------
        id = cell(size(gnlist,1),1);
        for gi = 1:numel(gnlist)
            id{gi} = table2array(DataG.id{gi});
        end
        plateinfo = cell2mat(id);
        plateinfo = array2table(plateinfo,'VariableNames',{'mwtid','timeid','wormid'});
        [i,j] = ismember(plateinfo.mwtid, MWTDB.mwtid);
        i = j(i);
        plateinfo.groupname = MWTDB.groupname(i);
        plateinfo.mwtpath = MWTDB.mwtpath(i);
        % ---------------------------------


        % calculate response type (acceleration) --------------
        % summarize response type by plate
        [A,N,NV,mwtidlist] = responseType_pct_plate(plateinfo,R,'accelerate forward');
        % rid of data with NaN ouputs
        invalid = any(N < n_lowest,2) & any(isnan(A),2);
        % rid of N lower than n limist
        RespNv = A;
        RespNv(invalid,:) = NaN;
        % summarize response type by group
        [Mean, SEM, SampleSize, tt,MWTDBv] = sum_RType_byGroup(MWTDB, mwtidlist,RespNv,NV);
        % ---------------------------------------

        % figure ---------------------------------------
        % sort by N2
        Mean = sortN2first(gnlist, Mean); 
        SEM = sortN2first(gnlist, SEM); 
        
        % prepare time
        time = [time_response(1):0.1:time_response(2)];
        time = repmat(time,size(Mean,1),1);
        % prepare genotype
        genotype = strainNames.genotype{si};
        % make figure
        figure1 = createfigure(time', Mean', SEM', gnlist, genotype);
        % ------------------------------------------------
        
        % save figure ----------------
        pSaveFig = fullfile(pM,'Figure',tname);
        if ~isdir(pSaveFig); mkdir(pSaveFig); end
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
        pSaveFig = fullfile(pM,'Data',tname);
        if ~isdir(pSaveFig); mkdir(pSaveFig); end
        savename = fullfile(pSaveFig, strain);
        gname = sortN2first(gnlist,gnlist);
        save(savename, 'R','leg','plateinfo','ST','textfile','Mean', 'SEM', 'SampleSize','gname');
        % ---------------------------------
        
        % save text result ---------------
        pSaveFig = fullfile(pM,'Stats',tname);
        if ~isdir(pSaveFig); mkdir(pSaveFig); end
        savename = fullfile(pSaveFig, [strain,'.txt'] );
        fid = fopen(savename,'w');
        fprintf(fid,'%s',textfile);
        fclose(fid);
        % -------------------------------
        
        
    end

end





























