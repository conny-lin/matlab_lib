% calculate rapid tolerance index
% group name translation: specific for rapid tolerance
msrlist = {'speed','curve'};

MWTDB = MWTSet.Info.MWTDB;
MWTDB = parseToleranceName(MWTDB);
D = MWTSet.Data_Plate;
D = innerjoin(MWTSet.Info.MWTDB,D,'Keys','mwtid');


% k preset for withdrawal
k_withdrawal = {'speed',-1;'curve',1};

%% calculate EI
for msri = 1:numel(msrlist)
    %% output start
    fprintf(fid1,'-- %s --\n',msrlist{msri});  
    % get WI, TI
    EM = MWTSet.Data_Exp.(msrlist{msri});
    %% get exp mean
    expstrain = strjoinrows([EM.expname EM.strain]);
    expstrainu = unique(expstrain);
    cond = strjoinrows([EM.predose EM.postdose]);
    condu = unique(cond);
    A = nan(numel(expstrainu),numel(condu));
    for ei = 1:numel(expstrainu)
        i = ismember(expstrain, expstrainu{ei});
        ED = EM(i,:);
        [i,j] = ismember(condu,cond(i));
        A(ei,i) = ED.mean(j(i));
    end
    RefT = table;
    RefT.group = expstrainu;
    a = regexpcellout(RefT.group,' ','split');
    RefT.a = A(:,1);
    RefT.c = A(:,2);
    RefT.b = A(:,3);
    RefT.d = A(:,4);
    RefT.A = RefT.c - RefT.a;
    
    %% get 200mM 200mM data (d, by plate)
    d = D(ismember(D.postdose,'200mM') & ismember(D.predose,'200mM'),:);
    t = table;
    t.group = strjoinrows([d.expname d.strain]);
    t.plate = d.mwtname;
    t.strain = d.strain;
    t.d = d.(msrlist{msri});
    DT = innerjoin(t,RefT(:,{'group','a','c','A'}));
    % calculate tolerance
    DT.B = DT.d-DT.a;
    DT.TI = (DT.A-DT.B)./DT.A;
    writetable(DT,sprintf('%s/%s TI raw.csv',pSave,msrlist{msri}));
    
    
    %% calculate Withdrawal
    % get 200-0mM data
    d = D(ismember(D.postdose,'0mM') & ismember(D.predose,'200mM'),:);
    t = table;
    t.group = strjoinrows([d.expname d.strain]);
    t.plate = d.mwtname;
    t.strain = d.strain;
    t.b = d.(msrlist{msri});
    DW = innerjoin(t,RefT(:,{'group','a','c'}));
    % calculate withdrawal
    % determine k
    k = k_withdrawal{ismember(k_withdrawal(:,1),msrlist{msri}),2};
    DW.WI = ((DW.b- DW.a)./DW.a).*k;
    
    %% write
    writetable(DT,sprintf('%s/%s TI raw.csv',pSave,msrlist{msri}));
    writetable(DW,sprintf('%s/%s WI raw.csv',pSave,msrlist{msri}));
    %% save to MWTSET
    MWTSet.EI.(msrlist{msri}).TI = DT;
    MWTSet.EI.(msrlist{msri}).WI = DW;
end


%% stats
% settings
fid1 = fopen(sprintf('%s/Effect Ind.txt',pSave),'w');
TAll = table;
TAllExp = table;
posthocname = 'bonferroni';
pv = 0.05;

% get data
Data = MWTSet.EI;
msrlist = fieldnames(Data);

% calculation
for msri = 1:numel(msrlist)
    EI = Data.(msrlist{msri});
    eiu = fieldnames(EI);
    for ei =1:numel(eiu)
        %% get data
        einame = eiu{ei};
        %% N= plates
        fprintf(fid1,'N(plates)\n');
        % tolerance
        T = grpstatsTable(EI.TI, EI.strain);
        i = ismember(T.gnameu,'N2');
        T = T([find(i) find(~i)],:);
        T1 = table;
        T1.Index = repmat({'TI'},size(T,1),1);
        T1 = [T1 T];
        if numel(unique(EI.strain)) > 1
            [atextTI,phtextTI] = anova1_std(EI.TI,EI.strain);
            % anova
            fprintf(fid1,'%s:\nANOVA(strain): %s\n',einame,atextTI);
            fprintf(fid1,'posthoc(%s) a=%.2f\n',posthocname,pv);
            fprintf(fid1,'%s\n',phtextTI);
        end

        % t test
        fprintf(fid1,'t test(right tail)\n');
        gnu = unique(EI.strain);
        gnu = [gnu(ismember(gnu,'N2')) gnu(~ismember(gnu,'N2'))];
        for gi = 1:numel(gnu)
            d = EI.TI(ismember(EI.strain,gnu(gi)));
            [~,p,~,STATS] = ttest(d,0,'tail','right');
            str = statTxtReport('t',STATS.df,STATS.tstat,p);
            fprintf(fid1,'%s, %s\n',gnu{gi},str);
        end    
        fprintf(fid1,'\n');


        % withdrawal
        T = grpstatsTable(DW.WI, DW.strain);
        i = ismember(T.gnameu,'N2');
        T = T([find(i) find(~i)],:);
        T2 = table;
        T2.Index = repmat({'WI'},size(T,1),1);
        T2 = [T2 T];
        T3 = [T1;T2];
        if numel(unique(EI.strain)) > 1
            [atextWI,phtextWI] = anova1_std(DW.WI,DW.strain);
            % export anova
            fprintf(fid1,'Withdrawal Index:\nANOVA(strain): %s\n',atextWI);
            fprintf(fid1,'posthoc(%s) a=%.2f\n',posthocname,pv);
            fprintf(fid1,'%s\n',phtextWI);
        end

        % t test
        fprintf(fid1,'t test(right tail)\n');
        gnu = unique(DW.strain);
        gnu = [gnu(ismember(gnu,'N2')) gnu(~ismember(gnu,'N2'))];
        for gi = 1:numel(gnu)
            d = DW.WI(ismember(DW.strain,gnu(gi)));
            [~,p,~,STATS] = ttest(d,0,'tail','right');
            str = statTxtReport('t',STATS.df,STATS.tstat,p);
            fprintf(fid1,'%s, %s\n',gnu{gi},str);
        end 
        fprintf(fid1,'\n');

        % add to all table
        T = table;
        T.msr = repmat(msrlist(msri),size(T3,1),1);
        T3 = [T T3];
        TAll = [TAll;T3];



        %% N=exp
        fprintf(fid1,'N(exp)\n');
        % calculate stats summary
        T = grpstatsTable(EI.TI, EI.group);
        a = regexpcellout(T.gnameu,' ','split');
        T.strain = a(:,2);
        if numel(unique(EI.strain)) > 1
            [atextTI,phtextTI] = anova1_std(T.mean, T.strain);
            % export anova
            fprintf(fid1,'Tolerance Index:\nANOVA(strain): %s\n',atextTI);
            fprintf(fid1,'posthoc(%s) a=%.2f\n',posthocname,pv);
            fprintf(fid1,'%s\n',phtextTI);
        end
        % t test
        fprintf(fid1,'t test(right tail)\n');
        gnu = unique(T.strain);
        gnu = [gnu(ismember(gnu,'N2')) gnu(~ismember(gnu,'N2'))];
        for gi = 1:numel(gnu)
            d = T.mean(ismember(T.strain,gnu(gi)));
            [h,p,~,STATS] = ttest(d,0,'tail','right');
            str = statTxtReport('t',STATS.df,STATS.tstat,p);
            fprintf(fid1,'%s, %s\n',gnu{gi},str);
        end 
        fprintf(fid1,'\n');
        % table
        T = grpstatsTable(T.mean, T.strain);
        T.Properties.VariableNames(ismember(T.Properties.VariableNames,'gnameu')) = {'strain'};
        i = ismember(T.strain,'N2');
        T = T([find(i) find(~i)],:);
        T1 = table;
        T1.Index = repmat({'TI'},size(T,1),1);
        T1 = [T1 T];

        % withdrawal
        T = grpstatsTable(DW.WI, DW.group);
        a = regexpcellout(T.gnameu,' ','split');
        T.strain = a(:,2);
        if numel(unique(EI.strain)) > 1
            [atextWI,phtextWI] = anova1_std(T.mean, T.strain);
            fprintf(fid1,'Withdrawal Index:\nANOVA(strain): %s\n',atextWI);
            fprintf(fid1,'posthoc(%s) a=%.2f\n',posthocname,pv);
            fprintf(fid1,'%s\n',phtextWI);
        end
        % t test
        fprintf(fid1,'t test(right tail)\n');
        gnu = unique(T.strain);
        gnu = [gnu(ismember(gnu,'N2')) gnu(~ismember(gnu,'N2'))];
        for gi = 1:numel(gnu)
            d = T.mean(ismember(T.strain,gnu(gi)));
            [~,p,~,STATS] = ttest(d,0,'tail','right');
            str = statTxtReport('t',STATS.df,STATS.tstat,p);
            fprintf(fid1,'%s, %s\n',gnu{gi},str);
        end 
        fprintf(fid1,'\n');

        % table
        T = grpstatsTable(T.mean, T.strain);
        T.Properties.VariableNames(ismember(T.Properties.VariableNames,'gnameu')) = {'strain'};
        i = ismember(T.strain,'N2');
        T = T([find(i) find(~i)],:);
        T2 = table;
        T2.Index = repmat({'WI'},size(T,1),1);
        T2 = [T2 T];
        T3 = [T1;T2];
        % add to all table
        T = table;
        T.msr = repmat(msrlist(msri),size(T3,1),1);
        T3 = [T T3];
        TAllExp = [TAllExp;T3];
    end

end
fclose(fid1);
cd(pSave);
writetable(TAll,'Effect Index Nplate.csv');
writetable(TAllExp,'Effect Index Nexp.csv');