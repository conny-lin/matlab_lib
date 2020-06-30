
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
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/1-N2 EARS/Data/raster per tap ephys';
% ---------------------------

% strains %------
% get group list
[~,~, glist] = dircontent(pData);
glist(regexpcellout(glist,'graffle')) = [];
% strainlist = dircontent(pData);
% get strain info
% strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% settings %--------------------
n_lowest = 10;
timelist = [95:10:29*10+95];
time_baseline = [-0.3 -0.1];
% time_response = [0.1 0.5];
% statsName = 'exclude no response';
% 
% % create time frames
% startList = [98 388];
% endList = startList+assaywindow;
% --------------------------------


%% RESPONSE PROBABILITY: ACC, PAUSE, NO RESPONSE, REVERSAL, DECELLEARTION
Output = struct;
for gi = 1:numel(glist) % cycle through groups
    
    % get .mat file list and time list --------------
    groupname = glist{gi};
    matfilelist = dircontent(fullfile(pData, groupname),'*.mat');
    % create mat file table
    matfileinfo = table;
    matfileinfo.fname = matfilelist;
    a = regexpcellout(matfilelist, '_','split');
    matfileinfo.t1 = cellfun(@str2num,a(:,2));
    matfileinfo.tf = cellfun(@str2num,a(:,3));
    n = a(:,5);
    matfileinfo.n = cellfun(@str2num,regexpcellout(n,'^\d{1,}','match'));
    % ----------------------------------------------
    
    for ti = 1:numel(timelist) % cycle through time choices

        % report progress %------------
        fprintf(''); % separator
        processIntervalReporter(numel(timelist),1,'time',ti);
        % ------------------------------

        % time info -----------------
        time1now = timelist(ti);
%         tname = timelist{ti};
%         tfilename = ['data_ephys_',tname,'.mat'];
        % --------------------------

        % data % -------------
%         strain = strainNames.strain{si}; 
        matfileinfo.fname{matfileinfo.ti == time1now}
        return
        p = fullfile(pData, groupname,'ephys graph',tfilename);
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
% report done --------------
fprintf('\n--- Done ---\n\n' );
return
% --------------------------






























