
function Dance_GraphPlugIn(pSaveA)


%% STEP1: PATHS [Need flexibility] 
a = regexp(userpath,':','split'); cd(a{:,1}); PathCommonList; clearvars a;
pFunMWT = '/Users/connylinlin/Documents/MATLAB/MATLAB MWT'; addpath(genpath(pFunMWT));
pFunMWTG = '/Users/connylinlin/Documents/MATLAB/MATLAB MWT/SubFun_Graph';

'ShaneSpark_Std20mM';
%% OPTOIN: STANDARDIZE RAW DATA TO 0mM
%% LOAD FILES
cd(pSaveA);
load('matlab.mat','Graph','MWTfnImport','MWTfG');
% get measure names
M = fieldnames(Graph.Y);

% get seqence of group names
gnameL = fieldnames(MWTfG);

% define control group names
i = celltakeout(regexp(gnameL,'_'),'singlenumber');
ctrlN = gnameL(i==0); % 0mM control = no _
ictrl = find(i==0);
%ctrlN2 = celltakeout(regexp(gnameL,'\<N2\>'),'singlenumber'); % N2 control

% define Exp group name
i = celltakeout(regexp(gnameL,'_'),'singlenumber');
expN = gnameL(i~=0);


%% get raw data from experimental groups
for g = 1:numel(expN) 
    % get index to exp files
    MWTfn = MWTfG.(expN{g})(:,1); % get MWT filenames from grouped index
    [~,iexp,~] = intersect(MWTfnImport(:,1),MWTfn); % get index to exp files
    A = MWTfnImport(iexp,1:2);

% check if file number the same
if size(MWTfG.(expN{g}),1) == size(A,1)
    % record sample size of exp
    N = size(MWTfG.(expN{g}),1);
    % report # of exp MWT files
    str = 'N of Exp group [%s] = %d';
    display(sprintf(str,expN{g},size(A,1)));
else error 'something wrong with experiment file number'; 
end


% %% get raw data for exp groups
B = []; % reset B
for p = 1:size(MWTfn,1);
    B.X.TapTime(:,p) = A{p,2}(:,1); % get Tap time
    B.N.NoResponse(:,p) = A{p,2}(:,3); 
    B.N.Reversed(:,p) = A{p,2}(:,4); 
    B.N.TotalN(:,p) = B.N.Reversed(:,p)+B.N.NoResponse(:,p);
    B.Y.RevFreq(:,p) = B.N.Reversed(:,p)./B.N.TotalN(:,p);
    B.Y.RevDist(:,p) = A{p,2}(:,5); 
    B.Y.RevDistStd(:,p) = B.Y.RevDist(:,p)/B.Y.RevDist(1,p);
    B.Y.RevFreqStd(:,p) = B.Y.RevFreq(:,p)/B.Y.RevFreq(1,p); % freqStd
end
D.(expN{g}) = B;
end



%% repeat cal for each measure
for m = 1:numel(M);  
    
    % get control mean
    Ctrl = Graph.Y.(M{m})(:,ictrl); 
    
    %% get raw data for exp groups    
    X = []; Y = []; E = [];
    for g = 1:numel(expN)   
        N = size(MWTfG.(expN{g}),1);
        % standardize to control
        a = (D.(expN{g}).Y.(M{m}))./repmat(Ctrl,1,N)*100; % divided by control mean
        Y(:,g) = nanmean(a,2); % get mean of exp group
        E(:,g) = nanstd(a')'/sqrt(N); % get SE
        X(:,g) = (1:1:size(a,1))'; % get x axis
    end
    
    
    %% graphing
    % Create figure
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Calibri');
    hold(axes1,'all');
    
    % graph control
    CtrlE = Graph.Y.(M{m})(:,ictrl);
    x = (1:1:30)';
    y = repmat(100,1,30);
    errorbar(x,y,CtrlE,'Parent',axes1,'LineWidth',3,...
            'DisplayName',ctrlN{ictrl},'Color',[0.8 0.8 0.8]); 

    % create errorbar
    errorbar1 = errorbar(X,Y,E);       
    gnshow = regexprep(expN,'_',' ');  

    % preset color codes
    color(1,:) = [0,0,0];
    color(2,:) = [0.04 0.14 0.42];
    color(3,:) = [0.847 0.16 0];
    color(4,:) = [0.168 0.505 0.337];

    %% create errorbar lines
    for g = 1:numel(expN)
        if g ==1;
            %if strcmp(gnshow{g},'N2 400mM')==1;
             set(errorbar1(g),'DisplayName',gnshow{g},...
            'MarkerSize',30,'Marker','.','LineWidth',2.5,'Color',[0 0 0]);
        elseif g>1; 
            %elseif %g == 2||3||4;
            set(errorbar1(g),'DisplayName',gnshow{g},...
            'MarkerSize',30,'Marker','.','LineWidth',2.5,'Color',color(g,1:3));
        end
    end

    %% Create legend
    legend1 = legend(axes1,'show');
    set(legend1,'EdgeColor',[1 1 1],'Location','NorthEastOutside',...
    'YColor',[1 1 1],'XColor',[1 1 1],'FontSize',14);  

    % Create xlabel
    xlabel('Stim','FontSize',16,'FontName','Calibri');

    % Create ylabel
    ylabel([M{m},' (% Sober)'],'FontName','Arial','FontSize',30); 

    % create x and y limit
    xlim(axes1,[0 31.5]);
    if m == (1||4);     
        ylim(axes1,[20 120]);
    elseif m == (2||3);
        ylim(axes1,[50 180]);
    end

    % save figure
    figname = [M{m},'_std0mM'];
    savefigjpeg(figname,pSaveA);
        

end 