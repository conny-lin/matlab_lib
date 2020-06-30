%% STEP5: IMPORT CHOR OUTPUTS
        % STEP5A: Import and process Chor generated data
        % MWTfevandat
        % note: this take a long time
        display 'Importing evan.dat';
        % evandat legends (%tnNss*b12)
        evandatL = {1,'time';2,'number';3,'goodnumber';4,'speed';5,'speedStd';...
        6,'bias';7,'tap';8,'puff'};
        MWTfevandatL = {1,'MWT filename';2,'Data';3,'mintime';4,'maxtime';...
        5,'mean number tracked';6,'mean good number';7,'mean percent N valid';...
        8,'mean speed';9,'min speed';10,'max speed';11,'mean bias'};
        % import
        MWTfevandat = {}; 
        for p = 1:numel(pMWTf); % for each mwt
        [~,datevanimport] = dircontentext(pMWTf{p},'*evan.dat');  
        MWTfevandat(p,1) = MWTfn(p);
        MWTfevandat(p,2) = {dlmread(datevanimport{1})};
        end
        % summarize
        for x = 1:size(MWTfevandat,1)
        MWTfevandat{x,3} = min(MWTfevandat{x,2}(:,1)); % min time
        MWTfevandat{x,4} = max(MWTfevandat{x,2}(:,1)); % max time
        MWTfevandat{x,5} = mean(MWTfevandat{x,2}(:,2)); % mean number tracked
        MWTfevandat{x,6} = mean(MWTfevandat{x,2}(:,3)); 
        MWTfevandat{x,7} = MWTfevandat{x,6}/MWTfevandat{x,5}*100; 
        MWTfevandat{x,8} = mean(MWTfevandat{x,2}(:,4)); 
        MWTfevandat{x,9} = min(MWTfevandat{x,2}(:,4)); 
        MWTfevandat{x,10} = max(MWTfevandat{x,2}(:,4)); 
        MWTfevandat{x,11} = mean(MWTfevandat{x,2}(:,6)); 
        end
        display 'done.';
        % sprevs
        display 'Importing *.sprevs, this will take a while...';
        % sprevs legends
        MWTfsprevsL = {1,'MWT filename'; 2,'Data';3,'mintime';4,'maxtime';...
        5,'objects tracked';6,'mean reversal';7,'minreversal'; ...
        8,'max reversal'};
        sprevsL = {1,'object ID'; 2,'time'; 3,'reversal'; 4,'trackduration?'};
        % import data
        MWTfsprevs = {};
        for p = 1 : numel(pMWTf); 
        [~,ps] = dircontentext(pMWTf{p},'*.sprevs');
        A = []; for k = 1:size(ps,1); a = dlmread(ps{k}); A = [A;a]; end
        MWTfsprevs(p,1) = MWTfn(p); MWTfsprevs(p,2) = {A};
        end 
        % summarize sprevs
        for x = 1:size(MWTfsprevs,1)
        MWTfsprevs{x,3} = min(MWTfsprevs{x,2}(:,2));
        MWTfsprevs{x,4} = max(MWTfsprevs{x,2}(:,2)); 
        MWTfsprevs{x,5} = numel(unique(MWTfsprevs{x,2}(:,1))); 
        MWTfsprevs{x,6} = mean(MWTfsprevs{x,2}(:,3)); 
        MWTfsprevs{x,7} = min(MWTfsprevs{x,2}(:,3)); 
        MWTfsprevs{x,8} = max(MWTfsprevs{x,2}(:,3)); 
        end
        display 'done';
        % summary Data
        Data.MWTfsprevs = MWTfsprevs;
        Data.MWTfsprevsL= MWTfsprevsL;
        Data.MWTfevandat = MWTfevandat;
        Data.MWTfevandatL = MWTfevandatL;
        Data.evandatL = evandatL;
        Data.sprevsL = sprevsL;
        %% STEP6: DESCRIPTIVE STATS
        % STEP6A: PREPARE TIME POINTS
        % prepare groups
        gnameL = fieldnames(MWTfG);
        % prepare universal timepoints limits
        % find smallest starting time and smallest ending time
        t = max(cell2mat(Data.MWTfsprevs(:,3)));
        t = str2num(num2str(t,'%.0f'));
        MWTfsprevStartTime = t;
        t = min(cell2mat(Data.MWTfsprevs(:,4)));
        t = str2num(num2str(t,'%.0f'));
        MWTfsprevEndTime = t;
        str = 'Earliest time tracked (MinTracked): %0.1f';
        display(sprintf(str,MWTfsprevStartTime));
        str = 'Max time tracked  (MaxTracked): %0.1f';
        display(sprintf(str,MWTfsprevEndTime));
        % processing inputs
        if tinput ==0; ti = MWTfsprevStartTime; 
        elseif isempty(tinput)==1; ti = MWTfsprevStartTime; tinput = 0; 
        elseif tinput>MWTfsprevStartTime; ti=tinput; end
        if isempty(intinput)==1; int = 10; else int = intinput; end
        if isempty(tfinput)==1; tf = MWTfsprevEndTime; else tf = tfinput; end
        if isempty(durinput)==0; duration = 'restricted'; else duration = 'all'; end
        % reporting
        str = 'Starting time: %0.0fs';
        display(sprintf(str,ti));
        switch duration
        case 'all'
        timepoints = [ti:int:tf];
        str = 'Time points: %0.0f ';
        timeN = numel(timepoints);
        display(sprintf(str,timeN));
        case 'restricted'
        % need coding
        end

        % STEP6B: DESCRIPTIVE STATS BY GROUPS
        % summarize group data
        G = [];
        for g = 1:numel(gnameL);
        % get group info
        A = [];
        gname = gnameL{g};    
        pMWTf = MWTfG.(gname)(:,2);
        MWTfn = MWTfG.(gname)(:,1);
        A.MWTfn = MWTfn;
        [~,i,~] = intersect(Data.MWTfsprevs(:,1),MWTfn);
        MWTfsprevs = Data.MWTfsprevs(i,:);
        [~,i,~] = intersect(Data.MWTfevandat(:,1),MWTfn);
        MWTfevandat = Data.MWTfevandat(i,:);

        %% MWTfsprevsum summary
        for p = 1:numel(MWTfn); % for each MWT plate
        A.X(:,p) = timepoints';
        for t = 1:numel(timepoints)-1; % for each stim
            % get data durint time frame 
            k = MWTfsprevs{p,2}(:,2)>timepoints(t) ....
                & MWTfsprevs{p,2}(:,2)<timepoints(t+1);
            %%
            sprevsValid = MWTfsprevs{p,2}(k,:);
            m = MWTfevandat{p,2}(:,1)>timepoints(t) ...
                & MWTfevandat{p,1}(:,1)<timepoints(t+1);
            evandatValid = MWTfevandat{p,2}(m,:);
            %% get N.Min
            if isempty(evandatValid)==1; % if no valid times
                A.N.Minimum(t,p) = 0; 
            else A.N.Minimum(t,p) = min(evandatValid(:,3)); 
            end
            % get N.Max
            if isempty(evandatValid)==1; 
                A.N.Maximum(t,p) = 0; 
            else A.N.Maximum(t,p) = max(evandatValid(:,3)); 
            end
            Nrev = size(sprevsValid(:,2),1);
            A.Y.RevIncidents(t,p) = Nrev;
            A.Y.RevWorm(t,p) = size(unique(sprevsValid(:,1)),1);
            A.Y.RevDist(t,p) = mean(sprevsValid(:,3));
            A.E.RevDist(t,p) = std(sprevsValid(:,3))./sqrt(Nrev);
            A.Y.RevDur(t,p) = mean(sprevsValid(:,4));
            A.E.RevDur(t,p) = std(sprevsValid(:,4))./sqrt(Nrev);
            % calculate total duration reversed
            RevEndTime = sprevsValid(:,2)+sprevsValid(:,4); % time start+time end
            overTimei = RevEndTime(:,1)>timepoints(t+1); % time tracked till after the end of timepoint
            RevEndTime(overTimei,1) = timepoints(t+1);
            RevDur = RevEndTime(:,1)-sprevsValid(:,2);
            A.Y.TotalTimeRev(t,p) = sum(RevDur);
        end % end of loop timepoints
        end % end of loop MWT
        % summarize group data
        Ytype = fieldnames(A.Y);
        B.X(:,g) = mean(A.X,2);
        for y = 1:numel(Ytype)
        Stat = Ytype{y};
        B.Y.(Stat)(:,g) = mean(A.Y.(Stat),2);
        B.E.(Stat)(:,g) = (std(A.Y.(Stat)')')./sqrt(size(A.Y.(Stat),2));
        end
        B.MWTf.(gname) = MWTfn;
        end % end of loop for group
        Graph = B;
        Graph.GroupName = gnameL;
        %% STEP7: GRAPH GROUPED DATA
        MeasureType = fieldnames(Graph.Y);
        for a = 1:numel(MeasureType);
        X = Graph.X(2:end,:);
        Y = Graph.Y.(MeasureType{a});
        E = Graph.E.(MeasureType{a});
        errorbar(X,Y,E);
        figname = [(MeasureType{a}),'[',num2str(ti,'%.0f'),':',num2str(int,'%.0f'),':',num2str(tf,'%.0f'),']'];
        savefig(figname,pSaveA);
        end  
        %% STEP6C: SAVE MATLAB
        cd(pSaveA); save('matlab.mat');