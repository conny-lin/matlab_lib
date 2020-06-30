
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
strainlist = dircontent(pData);
% get strain info
strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% settings %--------------------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
n_lowest = 10;
timelist = {'t28_30','t1'};
statsName = 'exclude no response';
w = 3;
h = 3;
% --------------------------------


%% RESPONSE PROBABILITY: ACC, PAUSE, NO RESPONSE, REVERSAL, DECELLEARTION
Output = struct;
for ti = 1:numel(timelist) % cycle through time choices
    
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
        % ----------------

        % get assay time % ------------
        t = DataG.time{1}(1,:);
        i_baseline = find(t >= time_baseline(1) & t <= time_baseline(2));
        i_response = find(t >= time_response(1) & t<= time_response(2));
        % --------------------------


        %% plot raster ----------------------------------
        groupname = DataG.name;
        grad1 = 0.5;
        grad2 = -0.4;
        for gi = 3%1:numel(groupname)
            % identify responded worms ---------------
            S = DataG.speedb{gi};
            t = DataG.time{gi}(1,:);
            name = groupname{gi};
            % -----------------------------------------
            
            % get response type summary %--------------
            Baseline = S(:,i_baseline);
            Response = S(:,i_response);
            [~,~,~,RTN,leg] = compute_response_type(Response, Baseline, 'pSave',pM);            
            % ----------------------------------------
            
            % get rid of data without response --------------
            d = S;
            d(:,62:end) = [];
            i = any([any(RTN(:,1:2)==4,2) any(isnan(RTN),2)],2);
            d(i,:) = [];
            % -------------------------------------------
            
            % random select 1000 worms -----------------------
            n = size(d,1);
            r = randi(n,1000,1);
            d = d(r,:);
            % ------------------------------------------------
            
            % create figure ------------------------------
            savename = sprintf('CL white intense %.0fmax %.0fmin %s',grad1*10, grad2*-10,name);
            rasterPlotc(d,t,0,'grad','CL','cmap','white intense',...
                'gradmin',-0.4,'gradmax',0.5,'savelegend',0);
            % -------------------------------------------
            
            % save figure ------------------------------------
            pSaveFig = fullfile(pM,'Figure',timename);
            if ~isdir(pSaveFig); mkdir(pSaveFig); end
            savename = fullfile(pSaveFig, strain );
            print(savename,'-dtiff'); 
            printfig(savename,pM,'w',w+0.5,'h',h+0.5)
            % -----------------------------------
        end
        

        
        % --------------------------------------

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


% report done --------------
fprintf('\n--- Done ---\n\n' );
return
% --------------------------






























