function drunkposterdotdat(pExpfT)
%% Process drunkposture
% *drunkposture.dat'};
% produced by '-O drunkposture -o nNslwakb'
% so tnNslwakb

% [NOTE] .ssr was formally .trv, should change it back!!!


%% STEP5: Import and process Chor generated data

% tnNslwakb
drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'speed';5,'length';...
    6,'width';7,'aspect';8,'kink';9,'bias'};
display 'Importing drunkposture.dat...';
for e = 1:numel(pExpfT)
    str = 'Looking in Exp %s';
    display(sprintf(str,ExpfnT{e}));
    pExp = pExpfT{e};
    % check if already processed
    [data,pd] = dircontentext(pExpfT{e},'drunkposturedat.mat');
    if isempty(data)==0; % if not
    % import data        
        [MWTfn,pMWTf] = dircontentmwt(pExpfT{e});
        A = {};
        for p = 1 : numel(pMWTf);
            str = 'Importing from [%s]';
            display(sprintf(str,MWTfn{p}));
            [~,datevanimport] = dircontentext(pMWTf{p},'*drunkposture.dat');  
            A(p,1) = MWTfn(p);
            A(p,2) = {dlmread(datevanimport{1})};
        end
        MWTfdrunkposturedat = A;
        cd(pExp);
        save('drunkposturedat.mat','MWTfdrunkposturedat');
    end
end
display 'Got all the drunkposture.dat.';


%% STEP6: Run Graphing
for e = 1:numel(pExpfT)
    %% import raw data
    pExp = pExpfT{e}; % get paths
    cd(pExp);
    load('drunkposturedat.mat','MWTfdrunkposturedat');
    [MWTfn,pMWTf] = dircontentmwt(pExpfT{e});
    
    %% timepoints
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
    elseif isempty(tinput)==1; ti = valstartime; tinput = 0; end
    if isempty(intinput)==1; int = 10; else int = intinput; end
    if isempty(tfinput)==1; tf = valendtime; else tf = tfinput; end
    if isempty(durinput)==0; duration = 'restricted'; else duration = 'all'; end

    % reporting
    str = 'Starting time: %0.0fs';
    display(sprintf(str,ti));
    switch duration
        case 'all'
            timepoints = [ti,tinput+int:int:tf];
            str = 'Time points: %0.0f ';
            timeN = numel(timepoints);
            display(sprintf(str,timeN));
        case 'restricted'
            display 'Under construction';% need coding
    end

    %% Stats.MWTfdrunkposturedat
    % drunkposturedatL = {1,'time';2,'number';3,'goodnumber';4,'Speed';5,'Length';...
    %     6,'Width';7,'Aspect';8,'Kink';9,'Bias'};
    Graph = [];
    Graph.YLegend = {'Speed','Length','Width','Aspect','Kink','Bias'};
    for p = 1:numel(MWTfn);
        Graph.X = timepoints;
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
end

%% group data
for e = 1:numel(pExpfT)
    pExp = pExpfT{e};
cd(pExp)
load('Groups_1Set.mat','Groups')
% get group code from MWT
[~,~,MWTfsn,~,~] = getMWTrunamefromHomepath(pExp);
[groupcode] = getMWTgcode3(MWTfsn);
M = Graph.YLegend;
clearvars Y X E;
for m = 1:numel(M);% for each measure
    for g = 1:size(Groups,1)% each group
        i = logical(celltakeout(regexp(groupcode,Groups{g,1}),'singlenumber')); 
        Y(:,g) = mean(Graph.Y.(M{m})(:,i),2);
        E(:,g) = std(Graph.Y.(M{m})(:,i)')'./sqrt(sum(i));
        X(:,g) = Graph.X(2:end);
    end
    errorbar(X,Y,E);
    figname = [M{m},'[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),':',num2str(tf,'%.0f'),']'];
    cd(pExp)
    savefig(figname,pExp);
end   
end





