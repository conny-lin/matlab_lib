function [varargout] = Dance_ShaneSpark(MWTSet, varargin)
%% INFORMATION
% statistics = per group by plates 
% organize output by groups


%% VARAGOUT
varargout{1} = {};

%% SETTINGS
choreversion = 'Chore_1.3.0.r1035.jar';

%% INPUT validation
% check if chor is inside
pFun = MWTSet.PATHS.pFun;
[~,p] = dircontent(MWTSet.PATHS.pFun);
if ismember([pFun,'/',choreversion],p) == true
    pJava = pFun;
else
    error('no %s found in function folder',choreversion);
end

%% CHOR:
%% GENERATE SCRIPTS
% GENERAL CHOR JAVA SETTINGS
javapath = pJava;
chor = ['''',javapath,'/',choreversion,'''']; % call chor 
b = blanks(1); % blank
javacall = 'java -jar'; javaRAM = '-Xmx7G'; javaRAM7G = '-Xmx7G';
beethoven = ['''',javapath,'/Beethoven_v2.jar','''']; % call beethoven 
map = '--map';
pixelsize = '-p 0.027'; speed = '-s 0.1'; 
mintime = '-t 20'; minmove = '-M 2'; shape = '--shadowless -S';
preoutline = '--plugin Reoutline::exp';  prespine = '--plugin Respine';

% ANALYSIS SPECIFIC SCRIPTS
oshanespark = '-O shanespark -o nNss*b12M'; % standard for Beethoven
revbeethoven_trv = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';

% CREATE CHOR JAVA SCRIPTS
chorscript = {};
chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
    mintime,b,minmove,b,shape,b,oshanespark,b,preoutline,b,...
    prespine,b,revbeethoven_trv,b]; 
fval = {'*.trv';'*shanespark.dat'};
MWTSet.chor.chorscript = chorscript;
MWTSet.chor.chor_fileoutputnames = fval;

% RUN CHOR
[pMWTc] = chormaster2(MWTSet);
      


%% GET MWT CHOR RESULTS FILE PATH
pMWTf = regexprep(...
    regexprep(MWTSet.pMWT,'.zip',''),...
    MWTSet.PATHS.pData,MWTSet.PATHS.pAnalysis);
[~,MWTfn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
MWTSet.pMWTchor = pMWTf;

%% IMPORT .TRV % revised 20150412
A = MWTfn;
for m = 1:size(pMWTf,1);
    display(sprintf('processing[%d/%d]: %s',m,numel(pMWTf),MWTfn{m}));
    [~,p] = dircontent(pMWTf{m},'*.trv'); 
    % if there is no .trv
    if isempty(p) == 1
        A{m,2} = {};     
    else       
        % validate trv output format
        pt = p{1};
        fileID = fopen(pt,'r');
        d = textscan(fileID, '%s', 2-1, 'Delimiter', '', 'WhiteSpace', '');
        fclose(fileID);
        % read trv
        if strcmp(d{1}{1}(1),'#') ==1 % if trv file is made by Beethoven
            a = dlmread(pt,' ',5,0); 
        else % if trv file is made by Dance
            a = dlmread(pt,' ',0,0);

        end
        A{m,2} = a(:,[1,3:5,8:10,12:16,19:21,23:27]); % index to none zeros
    end
end
MWTfnImport = A;
MWTSet.Data.Import = MWTfnImport;

% legend
% L = {'time','N?','N_NoResponse','N_Reversed','?','RevDist'    };
%% CHECK TAP CONSISTENCY
[r,c] = cellfun(@size,MWTfnImport(:,2),'UniformOutput',0);
rn = celltakeout(r,'singlenumber');
rfreq = tabulate(rn);
rcommon = rfreq(rfreq(:,2) == max(rfreq(:,2)),1);
str = 'Most common tap number = %d';
display(sprintf(str,rcommon));
rproblem = rn ~= rcommon;

if sum(rproblem)~=0;
    MWTfnP = MWTfn(rproblem); 
    pMWTfP = pMWTf(rproblem);

    str = 'The following MWT did not have the same tap(=%d)';
    display(sprintf(str,rcommon)); disp(MWTfnP);
    display 'Removing from analysis...'; 
    MWTSet.RawBad = MWTfnImport(rproblem,:);
    MWTfnImport = MWTfnImport(~rproblem,:);
    MWTfn = MWTfn(~rproblem);
    pMWTf = pMWTf(~rproblem);    
    
    % reconstruct
    [MWTSet.MWTfG] = reconstructMWTfG(pMWTf);

end

%% MAKING SENSE OF TRV 
% .TRV OUTPUT LEGENDS
% output legends
% time
% # worms already moving backwards (can't score) 
% # worms that didn't reverse in response 
% # worms that did reverse in response 
% mean reversal distance (among those that reversed) 
% standard deviation of reversal distances 
% standard error of the mean 
% minimum 
% 25th percentile 
% median 
% 75th percentile 
% maximum 
% mean duration of reversal (also among those that reversed 
% standard deviation of duration 
% standard error of the mean 
% minimum 
% 25th percentile 
% median 
% 75th percentile 
% maximum

% indexes of .trv
ind.RevDur = 13;
ind.RevDist = 5;
% calculation
B = [];
B.MWTfn = MWTfn;
A = MWTfnImport;
for m = 1:size(pMWTf,1);
    % X = tap time
    % B.X.TapTime(:,m) = A{m,2}(:,1);
    B.X(:,m) = A{m,2}(:,1);   
    % basic caluations
    B.N.NoResponse(:,m) = A{m,2}(:,3);
    B.N.Reversed(:,m) = A{m,2}(:,4);  
    B.N.TotalN(:,m) = B.N.Reversed(:,m)+B.N.NoResponse(:,m);
    
    %% N
    n = B.N.TotalN(:,m);
    N = B.N.TotalN(:,m);
    N(n < 3) = NaN;
    
    %% Frequency
    B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./N;
    % variance can not be calculated at this point
    B.E.RevFreq(:,m) = NaN(size(B.N.Reversed(:,m))); %  can only be zero
    B.SD.RevFreq(:,m) = NaN(size(B.N.Reversed(:,m)));
    % B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./B.N.TotalN(:,m);
    % B.Y.RevFreqStd(:,m) = B.Y.RevFreq(:,m)/B.Y.RevFreq(1,m);
    
    %% Distance
    B.Y.RevDist(:,m) = A{m,2}(:,ind.RevDist); 
    B.SD.RevDist(:,m) = A{m,2}(:,ind.RevDist+1);
    B.E.RevDist(:,m) = A{m,2}(:,ind.RevDist+1)./B.N.Reversed(:,m);
    % B.Y.RevDistStd(:,m) = B.Y.RevDist(:,m)/B.Y.RevDist(1,m);
    % B.Y.SumRevDist(:,m) = B.Y.RevDist(:,m).*B.N.Reversed(:,m);     
    
    %% Reversal Duration
    B.Y.RevDur(:,m) = A{m,2}(:,ind.RevDur);
    B.E.RevDur(:,m) = A{m,2}(:,ind.RevDur+1)./B.N.Reversed(:,m);
    B.SD.RevDur(:,m) = A{m,2}(:,ind.RevDur+1)./B.N.Reversed(:,m);

    
    %% Reversal Speed = RevDist/RevDur
    B.Y.RevSpeed(:,m) = B.Y.RevDist(:,m)./B.Y.RevDur(:,m); 
    % variance can not be calculated at this point
    B.E.RevSpeed(:,m) = NaN(size(B.Y.RevSpeed(:,m))); 
    B.SD.RevSpeed(:,m) = NaN(size(B.Y.RevSpeed(:,m)));
end


Raw = B;
MWTSet.Data.ByPlates = Raw;


%% STATISTICS

names = {'MWTfG','Raw','MWTfn'};


MWTfG = MWTSet.MWTfG;
Graph = MWTSet.Raw;
MWTfn = Graph.MWTfn;

%% process
M = fieldnames(Graph.Y);
gnameL = fieldnames(MWTfG);  
A = [];
for m = 1:numel(M);% for each measure
    
    tapN = size(Graph.Y.(M{m}),1);
    
    for g = 1:numel(gnameL);
        gname = gnameL{g};
        pMWTf = MWTfG.(gname)(:,2); 
        MWTfn1 = MWTfG.(gname)(:,1);
        [~,i,~] = intersect(MWTfn',MWTfn1);
        A.(M{m}).Y(1:tapN,g) = nanmean(Graph.Y.(M{m})(:,i),2);
        A.(M{m}).E(1:tapN,g) = nanstd(Graph.Y.(M{m})(:,i)')'./sqrt(numel(i));
        A.(M{m}).SD(1:tapN,g) = nanstd(Graph.Y.(M{m})(:,i)')';
        A.(M{m}).X(1:tapN,g) = Graph.X(1:end,1);
    end
end

MWTSet.Graph = A;
MWTSet.GraphGroup = gnameL;

%% PROGRAM CODING RETURN

return
%% VARARGOUT

varargout{1} = MWTSet;





end