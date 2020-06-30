function [varargout] = Dance_DrunkPosture_20140206(varargin)

%% INPUT 
varargout = {};
MWTfG = varargin{1};
fnvalidate = varargin{2};
pSaveA = varargin{3};
TimeInputs = varargin{4};
    tinput = TimeInputs(1);
    intinput = TimeInputs(2);
    durinput = TimeInputs(3);
    tfinput = TimeInputs(4);
   
    

%% EXCLUDE CHOR PROBLEM MWT FILES FROM ANALYSIS
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
if isempty(pMWTfC)==1; 
    display 'All files have required Chor outputs';
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
%% IMPORT AND PROCESS CHOR DATA
display(sprintf('Importing %s',fnvalidate{1})); 
A = celltakeout(struct2cell(MWTfG),'multirow');
pMWTfT = A(:,2); MWTfnT = A(:,1);
pMWTf = pMWTfT; MWTfn = MWTfnT;
% tnNslwakb
% drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'speed';5,'length';...
%     6,'width';7,'aspect';8,'kink';9,'bias'};

for p = 1 : numel(pMWTfT);
    %str = 'Importing from [%s]';
    %display(sprintf(str,MWTfnT{p}));
    [~,datevanimport] = dircontentext(pMWTfT{p},fnvalidate{1});  
    A(p,1) = MWTfnT(p);
    A(p,2) = {dlmread(datevanimport{1})};
end
MWTfdrunkposturedat = A;
display(sprintf('Got all the %s',fnvalidate{1}));



%% PREPARE TIME POINTS
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
if tinput ==0 || isempty(tinput)==1 || isnan(tinput) ==1
    ti = valstartime; 
%elseif isempty(tinput)==1; ti = valstartime;
    %tinput = 0; 
elseif tinput > valstartime; ti = tinput; 
end

if isempty(intinput)==1 || isnan(intinput) ==1; 
    int = 10; 
else
    int = intinput;
end
if isempty(tfinput)==1 || isnan(tfinput)==1; 
    tf = valendtime; 
else
    tf = tfinput;
end
if isempty(durinput)==1 || isnan(durinput) ==1; 
    duration = 'all';
else
    duration = 'restricted'; 

end

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


%% STATS
% Stats.MWTfdrunkposturedat
L = {'time';'number';'goodnumber';'Speed';'Length';'Width';...
    'Aspect';'Kink';'Bias';'Curve';'Area';'midline';'morphwidth'};

Raw = MWTfdrunkposturedat;
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

        for m = 4:numel(L)
            Graph.Y.(L{m})(t,p) = nanmean(dataVal(:,m));
            Graph.E.(L{m})(t,p) = nanstd(dataVal(:,m))./sqrt(Nrev);
%             Graph.Y.Length(t,p) = mean(dataVal(:,5));
%             Graph.E.Length(t,p) = std(dataVal(:,5))./sqrt(Nrev);
%             Graph.Y.Width(t,p) = mean(dataVal(:,6));
%             Graph.E.Width(t,p) = std(dataVal(:,6))./sqrt(Nrev);
%             Graph.Y.Aspect(t,p) = mean(dataVal(:,7));
%             Graph.E.Aspect(t,p) = std(dataVal(:,7))./sqrt(Nrev);        
%             Graph.Y.Kink(t,p) = mean(dataVal(:,8));
%             Graph.E.Kink(t,p) = std(dataVal(:,8))./sqrt(Nrev);         
%             Graph.Y.Bias(t,p) = mean(dataVal(:,9));
%             Graph.E.Bias(t,p) = std(dataVal(:,9))./sqrt(Nrev);
        end
    end
end
Graph.YLegend = fieldnames(Graph.Y);
clearvars Y X E;
MWTfnimport = (Graph.MWTfn');
M = Graph.YLegend;
gnameL = fieldnames(MWTfG);  


%% GRAPHING
for m = 1:numel(M);% for each measure
    A = [];
    for g = 1:numel(gnameL);
        gname = gnameL{g};
        pMWTf = MWTfG.(gname)(:,2); 
        MWTfn1 = MWTfG.(gname)(:,1);
        A.MWTfn = MWTfn1;
        [~,i,~] = intersect(MWTfnimport(:,1),MWTfn1);
        Y(:,g) = mean(Graph.Y.(M{m})(:,i),2);
        E(:,g) = std(Graph.Y.(M{m})(:,i)')'./sqrt(sum(i));
        X(:,g) = Graph.X(2:end);
    end        
    % Create figure
    figure1 = figure('Color',[1 1 1]);
    axes1 = axes('Parent',figure1,'FontSize',18);
    box(axes1,'off');
    hold(axes1,'all');
    errorbar1 = errorbar(X,Y,E,'LineWidth',5);
    % create legend        
    gnshow = regexprep(gnameL,'_',' ');
    for g = 1:numel(gnshow)
        set(errorbar1(g),'DisplayName',gnshow{g});
    end
    % set color
    Colorchoice = [];
    Colorchoice(1,1:3) = [0 0 0]; % block
    Colorchoice(2,1:3) = [1 0 0]; % red
    for g = 1:size(Colorchoice,1)
        set(errorbar1(g),'Color',Colorchoice(g,1:3));
    end
    % set legend
    legend1 = legend(axes1,'show');
    set(legend1,'Location','NorthEastOutside',...
        'EdgeColor',[1 1 1],...
        'YColor',[1 1 1],...
        'XColor',[1 1 1]);
    
    ylabel(M{m},'FontName','Arial','FontSize',30); % Create ylabel
    figname = [M{m},'[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),':',num2str(tf,'%.0f'),']'];
    savefigjpeg(figname,pSaveA);
end  



%% STEP6C: SAVE MATLAB
cd(pSaveA); save('matlab.mat');
return

end




%% SUPPLEMENT ANALYSIS


%% Standardize to 0mM
% % Stats.MWTfdrunkposturedat
% drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'Speed';5,'Length';...
%                     6,'Width';7,'Aspect';8,'Kink';9,'Bias'};
% Raw = MWTfdrunkposturedat;
% Graph = [];
% Sum = [];
% % for each plate
% for p = 1:numel(MWTfn);
%     Graph.X = timepoints; Graph.MWTfn = MWTfn';
%     % for each stim
%     for t = 1:numel(timepoints)-1; % for each stim
%         % get timeframe
%         k = Raw{p,2}(:,1)>timepoints(t) & Raw{p,2}(:,1)<=timepoints(t+1); 
%         dataVal = Raw{p,2}(k,:);        
%         % create summary data
%         Sum{p,t} = dataVal;
%     end
% end
% 
% 
% % get legend
% iT = 1; iN = 2; igoodN = 3; iSpeed = 4; iLength = 5; iWidth = 6;
% iAspect = 7; iKink =8; iBias = 9;
% datL = {'time';'number';'goodnumber';'Speed';'Length';...
%                     'Width';'Aspect';'Kink';'Bias'};
% 
% % create controls pair
% %i = celltakeout(regexp(gnameL,'_'),'singlenumber');
% %ctrlN = gnameL(i==0); 
% ctrlN = gnameL(1); 
% %ctrl_N2 = celltakeout(regexp(gnameL,'\<N2\>'),'singlenumber'); % N2 control
% %expN = gnameL(i~=0);
% expN = gnameL(2:end);
% 
% % find pairs
%     Exp = []; Graph = []; 
% for j = 1:numel(ctrlN)
%                       
%     % calculate control mean
%     ctrl = ctrlN{j};
%     m = MWTfG.(ctrl)(:,1);
%     i = ismember(MWTfn,m);
%     A = Sum(i,:);
%     Control = []; B = [];
%     for a = 1:size(datL,1) % for each analysis
%         for t = 1:numel(timepoints)-1; % for each stim
%             for p = 1:size(A,1)   
%                 dataVal = A{p,t};  % get timeframe data
%                 B.(datL{a})(t,p) = mean(dataVal(:,a));
%             end
%         end
%         Control.(datL{a}) = mean(B.(datL{a}),2); 
%     end
% 
%     % standardize to control
%     a = celltakeout(regexp(expN,'_400mM','split'),'split');
%     i = ismember(a(:,1),ctrlN{j});
%     exp = expN{i};
%     m = MWTfG.(exp)(:,1);
%     i = ismember(MWTfn,m);
%     A = Sum(i,:);
% 
%     for a = 1:size(datL,1) % for each analysis
%         for t = 1:numel(timepoints)-1; % for each stim
%             tc = Control.(datL{a})(t); % get control mean
%             for p = 1:size(A,1)   
%                 b = (A{p,t}(:,a))./tc.*100;
%                 Exp.(datL{a})(t,p) = mean(b); % get data
%                 %Graph.N.(datL{a})(t,p) = size(A{p,t}(:,iN),1);
%             end
%         end
%         d = Exp.(datL{a});
%         n = sum(i);
%         Graph.Y.(datL{a})(:,j) = mean(d,2);
%         Graph.E.(datL{a})(:,j) = (std(d')/sqrt(n))';
%         Graph.X.(datL{a})(:,j) = timepoints(2:end)';
%     end
% 
% end
% 
% % graphing 
% X = []; Y = []; E = [];
% for m = 1:numel(M);% for each measure
%     g = numel(expN);
%     Y = Graph.Y.(M{m});
%     E = Graph.E.(M{m});
%     X = Graph.X.(M{m});
%     % Create figure
%     figure1 = figure;
%     axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Calibri');
%     hold(axes1,'all');
%     
%     % create errorbar
%     errorbar1 = errorbar(X,Y,E);       
%     gnshow = regexprep(expN,'_',' ');  
%     % color codes
%     color(1,:) = [0,0,0];
%     color(2,:) = [0.04 0.14 0.42];
%     color(3,:) = [0.847 0.16 0];
%     color(4,:) = [0.168 0.505 0.337];
%     for g = 1:numel(expN)
%         if strcmp(gnshow{g},'N2 400mM')==1;
%              set(errorbar1(g),'DisplayName',gnshow{g},...
%             'MarkerSize',30,'Marker','.','LineWidth',2.5,'Color',[0 0 0]);
%         elseif g == 2||3||4;
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%             'MarkerSize',30,'Marker','.','LineWidth',2.5,'Color',color(g,1:3));
%         end
%     end
%     
%     
%     
%     % Create legend
%     legend1 = legend(axes1,'show');
%     set(legend1,'EdgeColor',[1 1 1],'Location','NorthEastOutside',...
%     'YColor',[1 1 1],...
%     'XColor',[1 1 1],...
%     'FontSize',14);  
%     
%     % Create xlabel
%     xlabel('Time (s)','FontSize',16,'FontName','Calibri');
%     
%     % Create ylabel
%     ylabel(M{m},'FontName','Arial','FontSize',30); 
%     
%     % create 100% line
%     Xmax = max(X); Xmax = Xmax(1);
%     plot(repmat(100,1,round(Xmax)+1),'Parent',axes1,'LineWidth',3,'LineStyle',':',...
%     'DisplayName','100','Color',[0 0 0]);
%     
% % save figure
%     figname = [M{m},'_std[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),':',num2str(tf,'%.0f'),']'];
%     savefigjpeg(figname,pSaveA);
% end
%         % STEP6C: SAVE MATLAB
%         cd(pSaveA); save('matlab.mat');
