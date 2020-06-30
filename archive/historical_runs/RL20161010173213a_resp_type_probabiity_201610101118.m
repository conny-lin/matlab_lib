
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% GLOBAL INFORMATION
% paths & settings
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/Data/10sIS by strains';
strainlist = dircontent(pData);
% get strain info
strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% settings %--------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
n_lowest = 10;
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

for si = 19%:size(strainNames,1) % cycle through strains
    
    % report progress %------------
    fprintf('\n\n\n');
    processIntervalReporter(numel(strainlist),1,'strain',si);
    % ------------------------------
    
    % data % -------------
    strain = strainNames.strain{si}; 
    p = fullfile(pData, strain,'ephys graph','data_ephys_t28_30.mat');
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
   
    
    %% GET RESPONSE TYPE SUMMARY
    % flatten data
    S = cell2mat(DataG.speedb);
    % input data -----------------
    Baseline = S(:,i_baseline);
    Response = S(:,i_response);
    [~,~,R,~,leg] = compute_response_type(Response, Baseline, 'pSave',pM);
    R = cell2table(R);
    
    % plate info
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
    
    
    %% SUMMARIZE RESPONSE TYPE PER TIME PER GROUP PER PLATE
    plateidu = unique(plateinfo.mwtid);
    A = [];
    N = [];
    B = {};
    NV = [];
    rowN = 1;
    plateidlist = [];


    for plateidi = 1:numel(plateidu)
        pid = plateidu(plateidi);
        i_plate = plateinfo.mwtid == pid;

        R1 = R(i_plate,:);
        R1 = table2cell(R1);
        R1 = regexprep(R1,'','no data');
        R1 = categorical(R1);

        a = countcats(R1);

        leg = categories(R1);
        b = a(ismember(leg, 'accelerate forward'),:);
        if isempty(b)
           b = zeros(1, size(R1,2));
        end
        c = a(ismember(leg, 'baseline'),:);
        
        n = sum(a,1);
        N(rowN,:) = n;
        
        if ~isempty(c)
            n = (n - c);
        end
        p=  b./n;
        
        A(rowN,:) = p;
        NV(rowN,:) = n;
        plateidlist(rowN) = pid;
        rowN = rowN +1;
    end
 

    %% summary
    [i,j] = ismember(plateidlist, MWTDB.mwtid);
    plateidu = j(i);
    MWD = MWTDB(plateidu,:);
    
    %%
    accAvg = nan(numel(gnlist),size(NV,2));
    accSem = accAvg;
    for gi = 1:numel(gnlist) % cycle through groups
        gn = gnlist{gi}; % get gname
        
        i = ismember(MWD.groupname,gn);
        if ~isempty(i)
            a = A(i,:);
            n = N(i,:);
            j = ~any(n < n_lowest,2);

            aa = a(j,:);

            ap = mean(aa);
            apse = std(aa);
            nn = size(aa,1);
            apsem = apse./sqrt(nn-1);

            accAvg(gi,:) = ap;
            accSem(gi,:) = apsem;
        end
        
    end
    
    t = accAvg;
    t = array2table(t);
    tt = table;
    tt.gname = gnlist;
    tt = [tt t];
    
    %% sort by N2
    i = regexpcellout(gnlist,'N2');
    i = [find(i) ;find(~i)];
    gnlist = gnlist(i);
    
    
    time = [time_response(1):0.1:time_response(2)];
    time = repmat(time,size(accAvg,1),1);
    
    genotype = strainNames.genotype{si};
    figure1 = createfigure(time', accAvg(i,:)', accSem(i,:)', gnlist, genotype);
    pSaveFig = fullfile(pM,'Figure');
    if ~isdir(pSaveFig); mkdir(pSaveFig); end
    savename = fullfile(pSaveFig, strain);
    printfig(savename,pM,'w',3,'h',3)
    
end

fprintf('\n--- Done ---' );
return






























