function [varargout] = Dance_DrunkPosture(varargin)


%% VARAGOUT
varargout = {};



%% VARAGIN 
% requirement
ReqInput = {'MWTfG';'chorfile';'pSaveA';'TimeInputs'};
switch nargin
    case 0
        varargout{1} = ReqInput;
        return
    case 1
        MWTSet = varargin{1};
        names = fieldnames(MWTSet);
        i = ismember(names,ReqInput);
        if numel(ReqInput) == sum(i) == 0
            error('MWTSet does not contain required input for this analysis');
        else
            MWTfG = MWTSet.MWTfG;
            fnvalidate = MWTSet.chorfile;
            pSaveA = MWTSet.pSaveA;
            TimeInputs = MWTSet.TimeInputs;
            tinput = TimeInputs(1);
            intinput = TimeInputs(2);
            durinput = TimeInputs(3);
            tfinput = TimeInputs(4);
        end
end




%% [MOVED] EXCLUDE CHOR PROBLEM MWT FILES FROM ANALYSIS
% RE-CHECK CHOR OUTPUTS
% display ' '; display 'Double checking chor outputs...'
% % prepare pMWTf input for validation
% A = celltakeout(struct2cell(MWTfG),'multirow');
% pMWTfT = A(:,2); MWTfnT = A(:,1);
% pMWTf = pMWTfT; MWTfn = MWTfnT;
% % check chor ouptputs
% pMWTfC = {}; MWTfnC = {}; 
% for v = 1:size(fnvalidate,1);
%     [valname] = cellfunexpr(pMWTf,fnvalidate{v});
%     [fn,path] = cellfun(@dircontentext,pMWTf,valname,'UniformOutput',0);
%     novalfn = cellfun(@isempty,fn);
%     if sum(novalfn)~=0;
%         pMWTfnoval = pMWTf(novalfn); MWTfnoval = MWTfn(novalfn);
%         pMWTfC = [pMWTfC;pMWTfnoval]; MWTfnC = [MWTfnC;MWTfnoval];
%     end
% end
% pMWTfC = unique(pMWTfC); MWTfnC = unique(MWTfnC);
% 
% % reporting
% if isempty(pMWTfC)==1; 
%     display 'All files have required Chor outputs';
% elseif isempty(pMWTfC)==0;
%     str = 'Chore unsuccessful in %d MWT files';
%     display(sprintf(str,numel(pMWTfC)));disp(MWTfnC);
%     % STEP3F: EXCLUDE PROBLEM MWT FILES
%     display 'Excluding problem MWT from analysis';
%     gname = fieldnames(MWTfG);
%     for x = 1:numel(MWTfnC) % each problem folders
%         for g = 1:numel(gname)
%             A = MWTfG.(gname{g})(:,1);
%             i = logical(celltakeout(regexp(A,MWTfnC{x}),'singlenumber'));
%             if sum(i)>0; 
%                 str = '>removing [%s]';
%                 display(sprintf(str,MWTfnC{x}));
%                 MWTfG.(gname{g})(i,:)=[]; % remove that from analysis
%             end
%         end
%     end
% end
pMWTfC = MWTSet.pMWTchorpass;
[~,MWTfnC] = cellfun(@fileparts,pMWTfC,'UniformOutput',0);

 
%% get pMWT
pMWTf = MWTSet.pMWTchorpass;
[~,MWTfn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);

%% IMPORT AND PROCESS CHOR DATA
display(sprintf('Importing %s',fnvalidate{1})); 
% A = celltakeout(struct2cell(MWTfG),'multirow');
% pMWTfT = A(:,2); MWTfnT = A(:,1);
% pMWTf = pMWTfT; 
% MWTfn = MWTfnT;
% tnNslwakb
% drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'speed';5,'length';...
%     6,'width';7,'aspect';8,'kink';9,'bias'};


% import
for p = 1 : numel(pMWTf);
    [~,datevanimport] = dircontentext(pMWTf{p},fnvalidate{1});  
    A(p,1) = MWTfn(p);
    A(p,2) = {dlmread(datevanimport{1})};
end
MWTfdrunkposturedat = A;
display(sprintf('Got all the %s',fnvalidate{1}));



%% PREPARE TIME POINTS
% prepare universal timepoints limits
% timepoints
% find smallest starting time and smallest ending time
% MWTfdrunkposturedatL = {1,'MWTfname';2,'Data';3,'time(min)';4,'time(max)'};
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
        timeN = numel(timepoints)-1;
        display(sprintf(str,timeN));
        
    case 'restricted'
        display 'Under construction';% need coding
end       



%% STATS: N = PLATES
% Stats.MWTfdrunkposturedat
L = {'time';'number';'goodnumber';'Speed';'Length';'Width';...
    'Aspect';'Kink';'Bias';'Curve';'Area';'midline';'morphwidth'};

Raw = MWTfdrunkposturedat;
Graph = [];
for p = 1:numel(MWTfn);
    Graph.X = timepoints(2:end)'; 
    Graph.MWTfn = MWTfn';
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
        end
    end
end



%% [MOVED] GRAPHING OUTPUT
% M = fieldnames(Graph.Y);
% gnameL = fieldnames(MWTfG);  
% A = [];
% for m = 1:numel(M);% for each measure
% 
%     for g = 1:numel(gnameL);
%         gname = gnameL{g};
%         pMWTf = MWTfG.(gname)(:,2); 
%         MWTfn1 = MWTfG.(gname)(:,1);
%         [~,i,~] = intersect(MWTfn',MWTfn1);
%         A.(M{m}).Y(:,g) = nanmean(Graph.Y.(M{m})(:,i),2);
%         A.(M{m}).E(:,g) = nanstd(Graph.Y.(M{m})(:,i)')'./sqrt(sum(i));
%         A.(M{m}).X(:,g) = Graph.X(2:end);
%     end
% end
% 
% GraphA = A;


%% VARARGOUT
varargout{1} = Graph;




%% STEP6C: SAVE MATLAB
cd(pSaveA); save('matlab.mat');


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
