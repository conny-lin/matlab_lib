

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
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/rType_fig_bar/Data';
% get strain info
strainlist = dircontent(pData);
strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% settings %--------------------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
n_lowest = 10;
timelist = {'t28_30','t1'};
statsName = 'exclude no response';
% --------------------------------


%% effect size
Output = struct;
for ti = 1:numel(timelist) % cycle through time choices
    
    % effect sizse master
    GroupMaster = {};
    ESMaster= [];
    % ----------------------
    
    % time ------------------
    tname = timelist{ti};
    tfilename = ['data_ephys_',tname,'.mat'];
    % -----------------------
    
    for si = 1:size(strainNames,1) % cycle through strains

        % report progress %------------
        fprintf(''); % separator
        processIntervalReporter(numel(strainlist),1,'strain',si);
        % ------------------------------

        % data % -------------
        strain = strainNames.strain{si}; 
        p = fullfile(pData, tname,[strain,' by plate.csv']);
        T = readtable(p)
        
        return
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


        % effect size ----------------------------------
        Data = RespNv;
        group_plate = MWTDB.groupname(ismember(mwtidlist,MWTDB.mwtid));
        group_unique = unique(group_plate);
        group_unique = output_sortN2first(group_unique);
        group = pairwisecomp_getpairs(group_unique);

        ES_t = nan(size(group,1),size(Data,2));
        for tii = 1:size(Data,2)
            for gi = 1:size(group,1)

                X = cell(2);

                for c = 1:size(group,2)
                    gn = group{gi,c};
                    i = ismember(group_plate,gn);
                    d = Data(i,tii);
                    X{c} = d;
                end

                cohend = effectsize_cohend(X{2},X{1});
                ES_t(gi,tii) = cohend;

            end
        end

        a = array2table(ES_t);
        b = cell2table(group);
        ES = [b a];
        pS = fullfile(pM,'Effect Size');
        if ~isdir(pS); mkdir(pS); end
        savename = fullfile(pS, [strain,' ',tname,'.csv']);
        writetable(ES,savename);
        % --------------------------------
        
        
        % save result % ------------------
        pSaveFig = fullfile(pM,'Data',tname);
        if ~isdir(pSaveFig); mkdir(pSaveFig); end
        savename = fullfile(pSaveFig, strain);
        gname = sortN2first(gnlist,gnlist);
        save(savename, 'mwtidlist','MWTDB','RespNv','ES');
        % ---------------------------------
        
        % append to master ----------------
        GroupMaster = [GroupMaster;group];
        ESMaster = [ESMaster;ES_t];
        % -------------------------------        
        
    end
    
    % save master ES -----------------
    group = GroupMaster; 
    ES_t = ESMaster;
    a = array2table(ES_t);
    b = cell2table(group);
    ES = [b a]; 
    savename = fullfile(pM, ['Effect size ',tname,'.csv']);
    writetable(ES,savename);
    % ---------------------------------

end

% report done --------------
fprintf('\n--- Done ---\n\n' );
return
% --------------------------












