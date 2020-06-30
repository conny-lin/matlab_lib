%% STEP1: PATHS [Need flexibility] 
clearvars -except option pData
pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
pRose = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811';
pFun = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs';
pSet = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs/MatSetfiles';
pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
pSave = '/Users/connylinlin/Documents/Work/MWT Data Analysis';
pIronMan = '/Volumes/IRONMAN';
addpath(genpath(pFun));



%% DRUNK POSTURE
%% STEP3E: EXCLUDE CHOR PROBLEM MWT FILES FROM ANALYSIS
% RE-CHECK CHOR OUTPUTS
display ' '; display 'Double checking chor outputs...'
% prepare pMWTf input for validation
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1);
pMWTf = pMWTfT; MWTfn = MWTfnT;
% check chor ouptputs
pMWTfC = {}; MWTfnC = {}; 
for v = 1:size(fnvalidate,1);
    [valname] = cellfunexpr(pMWTf,fnvalidate{v});
    [fn,path] = cellfun(@dircontentext,pMWTf,valname,'UniformOutput',0);
    novalfn = cellfun(@isempty,fn);
    if sum(novalfn)~=0;
        pMWTfnoval = pMWTf(novalfn); MWTfnoval = MWTfn(novalfn);
        pMWTfC = [pMWTfC;pMWTfnoval]; MWTfnC = [MWTfnC;MWTfnoval];
    end
end
pMWTfC = unique(pMWTfC); MWTfnC = unique(MWTfnC);
% reporting
if isempty(pMWTfC)==1; display 'All files have required Chor outputs';
elseif isempty(pMWTfC)==0;
    str = 'Chore unsuccessful in %d MWT files';
    display(sprintf(str,numel(pMWTfC)));disp(MWTfnC);
    % STEP3F: EXCLUDE PROBLEM MWT FILES
    display 'Excluding problem MWT from analysis';
    gname = fieldnames(MWTfG);
    for x = 1:numel(MWTfnC) % each problem folders
        for g = 1:numel(gname)
            A = MWTfG.(gname{g})(:,1);
            i = logical(celltakeout(regexp(A,MWTfnC{x}),'singlenumber'));
            if sum(i)>0; 
                str = '>removing [%s]';
                display(sprintf(str,MWTfnC{x}));
                MWTfG.(gname{g})(i,:)=[]; % remove that from analysis
            end
        end
    end
end
%% STEP5: IMPORT AND PROCESS CHOR DATA
display 'Importing drunkposture.dat';
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1); pMWTf = pMWTfT; MWTfn = MWTfnT;
% tnNslwakb
% drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'speed';
% 5,'length'; 6,'width';7,'aspect';8,'kink';9,'bias'};
for p = 1 : numel(pMWTfT);
    str = 'Importing from [%s]';
    display(sprintf(str,MWTfnT{p}));
    [~,datevanimport] = dircontentext(pMWTfT{p},'*drunkposture.dat');  
    A(p,1) = MWTfnT(p);
    A(p,2) = {dlmread(datevanimport{1})};
end
MWTfdrunkposturedat = A;
display 'Got all the drunkposture.dat.';
%% STEP6: GRAPHING
%% STEP6A: PREPARE TIME POINTS
% prepare universal timepoints limits
% timepoints
% find smallest starting time and smallest ending time
MWTfdrunkposturedatL = {1,'MWTfname';2,'Data';3,'time(min)';4,'time(max)'};
Raw = MWTfdrunkposturedat;    
for p = 1:numel(MWTfn)
Raw{p,3} = min(Raw{p,2}(:,1)); 
Raw{p,4} = max(Raw{p,2}(:,1));
end
valstartime = max(cell2mat(Raw(:,3)));
valendtime = min(cell2mat(Raw(:,4)));
str = 'Earliest time tracked (MinTracked): %0.1f';
display(sprintf(str,valstartime));
str = 'Max time tracked  (MaxTracked): %0.1f';
display(sprintf(str,valendtime));
% processing inputs
if tinput ==0; ti = valstartime; 
elseif isempty(tinput)==1; ti = valstartime; tinput = 0; 
elseif tinput>valstartime; ti = tinput; 
end
if isempty(intinput)==1; int = 10; else int = intinput; end
if isempty(tfinput)==1; tf = valendtime; else tf = tfinput; end
if isempty(durinput)==0; duration = 'restricted'; else duration = 'all'; end

% reporting
str = 'Starting time: %0.0fs';
display(sprintf(str,ti));
switch duration
case 'all'
timepoints = [0,ti+int:int:tf];
str = 'Time points: %0.0f ';
timeN = numel(timepoints);
display(sprintf(str,timeN));
case 'restricted'
display 'Under construction';% need coding
end
%% STEP6B: STATS
Raw = MWTfdrunkposturedat;
% Stats.MWTfdrunkposturedat
% drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'Speed';5,'Length';...
%     6,'Width';7,'Aspect';8,'Kink';9,'Bias'};
Graph = [];
for p = 1:numel(MWTfn);
Graph.X = timepoints; Graph.MWTfn = MWTfn';
% summary 
for t = 1:numel(timepoints)-1; % for each stim
% get timeframe
k = Raw{p,2}(:,1)>timepoints(t) & Raw{p,2}(:,1)<timepoints(t+1); 
dataVal = Raw{p,2}(k,:);
% create Graph.N
Nrev = size(dataVal(:,2),1);
Graph.N.Ndatapoints(t,p) = Nrev;
Graph.N.NsumN(t,p) = sum(dataVal(:,2));
Graph.N.NsumNVal(t,p) = sum(dataVal(:,3));
Graph.Y.Speed(t,p) = mean(dataVal(:,4));
Graph.E.Speed(t,p) = std(dataVal(:,4))./sqrt(Nrev);
Graph.Y.Length(t,p) = mean(dataVal(:,5));
Graph.E.Length(t,p) = std(dataVal(:,5))./sqrt(Nrev);
Graph.Y.Width(t,p) = mean(dataVal(:,6));
Graph.E.Width(t,p) = std(dataVal(:,6))./sqrt(Nrev);
Graph.Y.Aspect(t,p) = mean(dataVal(:,7));
Graph.E.Aspect(t,p) = std(dataVal(:,7))./sqrt(Nrev);        
Graph.Y.Kink(t,p) = mean(dataVal(:,8));
Graph.E.Kink(t,p) = std(dataVal(:,8))./sqrt(Nrev);         
Graph.Y.Bias(t,p) = mean(dataVal(:,8));
Graph.E.Bias(t,p) = std(dataVal(:,8))./sqrt(Nrev);
end
end
Graph.YLegend = fieldnames(Graph.Y);
clearvars Y X E;
MWTfnimport = (Graph.MWTfn');
M = Graph.YLegend;
gnameL = gnamechose;
for m = 1:numel(M);% for each measure
for g = 1:numel(gnameL);
gname = gnameL{g};
pMWTf = MWTfG.(gname)(:,2); 
MWTfn = MWTfG.(gname)(:,1);
A.MWTfn = MWTfn;
[~,i,~] = intersect(MWTfnimport(:,1),MWTfn);
Y(:,g) = mean(Graph.Y.(M{m})(:,i),2);
E(:,g) = std(Graph.Y.(M{m})(:,i)')'./sqrt(sum(i));
X(:,g) = Graph.X(2:end);
end
errorbar(X,Y,E);
figname = [M{m},'[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),':',num2str(tf,'%.0f'),']'];
savefig(figname,pSaveA);
end  
%% STEP6C: SAVE MATLAB
cd(pSaveA); save('matlab.mat');