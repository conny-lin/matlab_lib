
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
for ti = 1:numel(timelist) % cycle through time choices
    
    tname = timelist{ti};
    tfilename = ['data_ephys_',tname,'.mat'];
    
    for si = 1:size(strainNames,1) % cycle through strains

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

        % save result % ------------------
        pSaveFig = fullfile(pM,'Data',tname);
        if ~isdir(pSaveFig); mkdir(pSaveFig); end
        savename = fullfile(pSaveFig, [strain, ' ', tname, ' ',statsName] );
        save(savename, 'R','leg','plateinfo')
        % ---------------------------------

        % calculate response type (acceleration) --------------
        % summarize response type by plate
        [A,N,NV,mwtidlist] = responseType_pct_plate(plateinfo,R,'accelerate forward');
        % rid of N lower than n limist
        RespNv = A;
        RespNv(~any(any(N < n_lowest,2)),:) = NaN;
        % summarize response type by group
        [accAvg, accSem, accN, tt] = sum_RType_byGroup(MWTDB, mwtidlist,A,NV);
        % ---------------------------------------

        % figure ---------------------------------------
        % sort by N2
        accAvg = sortN2first(gnlist, accAvg); 
        accSem = sortN2first(gnlist, accSem); 
        % prepare time
        time = [time_response(1):0.1:time_response(2)];
        time = repmat(time,size(accAvg,1),1);
        % prepare genotype
        genotype = strainNames.genotype{si};
        % make figure
        figure1 = createfigure(time', accAvg', accSem', gnlist, genotype);
        % save figure ----------------
        pSaveFig = fullfile(pM,'Figure',tname);
        if ~isdir(pSaveFig); mkdir(pSaveFig); end
        savename = fullfile(pSaveFig, [strain, ' ', tname, ' ',statsName] );
        printfig(savename,pM,'w',3,'h',3)
        % -------------------------------------------------

        %% statistics --------------------------------
        [StatOut,textfile] = RType_stats(T);
        
        
        return
% get n
StatOut.n_sample = nan(size(DataG,2),1);
for gi = 1:size(DataG,2)
StatOut.n_sample(gi) = size(DataG(gi).speedb,1);
end
% save
pS = fullfile(pSave,'mat files');
if ~isdir(pS); mkdir(pS); end
cd(pS);
save(strain,'StatOut');

    end

end
fprintf('\n--- Done ---' );
return






























