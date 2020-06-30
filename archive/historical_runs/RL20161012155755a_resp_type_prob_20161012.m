
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Dance/Dance_RespType');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/1-N2 EARS/Data/raster per tap ephys_201602281723';
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
% construct output array -------------
a = 0:0.2:1;
b = repmat(a',1,numel(timelist));
c = repmat((timelist+5),numel(a),1);
d = b+c;
timecolname = reshape(d,numel(d),1)';
ncol = numel(timecolname);
nrow = numel(glist);
MEAN = struct; SEM = struct; N = struct;
for gi = 1:numel(glist)
    MEAN.(glist{gi}) = nan(nrow,ncol);
    SEM.(glist{gi}) = MEAN;
    N.(glist{gi}) = MEAN;
end
% -----------------------------

    
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
    
    
    %% -----------------------------------
    for ti = 1:numel(timelist) % cycle through time choices

        % report progress %------------
        fprintf(''); % separator
        processIntervalReporter(numel(timelist),1,'time',ti);
        % ------------------------------

        % time info -----------------
        time1now = timelist(ti);
        taptimenow = time1now + 5;
%         tname = timelist{ti};
%         tfilename = ['data_ephys_',tname,'.mat'];
        % --------------------------

        % data % -------------
        f = matfileinfo.fname{matfileinfo.t1 == time1now};
        p = fullfile(pData, groupname,f);
        load(p);
        % find tap time column
        i = find(rTime(1,:) >= taptimenow & rTime(1,:) <= taptimenow+1);
        i = i(1);
        % get data before tap Baseline
        Baseline = Data(:,i-3:1:i-1);
        Response = Data(:,i:1:i+5); % 10 s after the tap
        % ----------------

        % get response type summary %--------------
        [~,~,R,~,leg] = compute_response_type(Response, Baseline);
        R = cell2table(R);
        % ---------------------------------

        % add plate info % --------------
        MWTDB = parseMWTinfo(pMWT);
        plateinfo = table;
        plateinfo.mwtid = mwtid;
        plateinfo.mwtpath = pMWT(mwtid);
        % ---------------------------------


        % calculate response type (acceleration) --------------
        % summarize response type by plate
        [A,N,NV,mwtidlist] = responseType_pct_plate(plateinfo,R,'accelerate forward');
        % rid of data with NaN ouputs
        invalid = any(N < n_lowest,2) & any(isnan(A),2);
        % rid of N lower than n limist
        RespNv = A;
        RespNv(invalid,:) = NaN;        
        % descriptive stats 
        [d,leg] = statsBasic(RespNv);
        m = d(:,3);
        se = d(:,5);
        n = d(:,1);
        t = taptimenow:0.2:(taptimenow+(5*0.2));
        % place data in output array
        [i,j] = ismember(t,timecolname);
        MEAN.(groupname)(1,j) = m;
        SEM.(groupname)(1,j) = se;
        N.(groupname)(1,j) = n;
        % ------------------------------------
        
        % calculate response type (reversal) --------------
        % summarize response type by plate
        [A,N,NV,mwtidlist] = responseType_pct_plate(plateinfo,R,'reversal');
        % rid of data with NaN ouputs
        invalid = any(N < n_lowest,2) & any(isnan(A),2);
        % rid of N lower than n limist
        RespNv = A;
        RespNv(invalid,:) = NaN;        
        % descriptive stats 
        [d,leg] = statsBasic(RespNv);
        m = d(:,3);
        se = d(:,5);
        n = d(:,1);
        t = taptimenow:0.2:(taptimenow+(5*0.2));
        % place data in output array
        [i,j] = ismember(t,timecolname);
        MEAN.(groupname)(2,j) = m;
        SEM.(groupname)(2,j) = se;
        N.(groupname)(2,j) = n;
        % ------------------------------------
        
    end
end

cd(pM);
save('matlab.mat','MEAN','SEM','N');

%%
%% plot errorbar across time
% get variables
x = repmat(timecolname,size(MEAN.N2,1),1)';
y = MEAN.N2';
e = SEM.N2';
errorbar(x,y,e)


return
% --------------------------------



% prepare time---------------------
time = [time_response(1):0.1:time_response(2)];
time = repmat(time,size(Mean,1),1);
% prepare genotype
genotype = strainNames.genotype{si};

% figure ---------------------------------------
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




% report done --------------
fprintf('\n--- Done ---\n\n' );
return
% --------------------------






























