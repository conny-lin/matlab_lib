% function ephys_accpeak_graph2_stats(strainT)

%% INITIALIZING
% clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);

%% SETTING
pSF = '/Users/connylin/Dropbox/RL/PubInPrep/PhD Dissertation/4-STH genes/Data/10sIS by strains';

% SEttings
Setting = struct;
Setting.Color = {[0.5 0.5 0.5]; [1 0.5 0.5];[0 0 0];[1 0 0]};
Setting.Marker = {'o' 'o' 'o' 'o'};
Setting.MarkerEdgeColor = Setting.Color;
Setting.MarkerFaceColor = Setting.Color;
Setting.MarkerSize = {2 2 2 2};


%% strains
strainlist = dircontent(pSF);
% if nargin > 0
strainlist(~ismember(strainlist,'NM1968')) = [];
% end


%% load data
for si =1:numel(strainlist)
    % get strain info
    strain = strainlist{si}; fprintf('%d/%d: %s\n',si, numel(strainlist), strain);
    pSave = pM;

    %% graph space out graphs
    timeNameList = {'t1','t28_30'};
    for ti = 1:numel(timeNameList)
        timeName = timeNameList{ti};
        load(sprintf('%s/%s/ephys graph/data_ephys_%s.mat',pSF,strain,timeName));
        
        %% compare first tap curve

        %% graph
        graphEy(DataG,strain,timeName,pSave,Setting)
        
        %% STATS
        % get data 
        D = cell(size(DataG,2),1);
        GN = cell(size(DataG,2),1);
        for gi = 1:size(DataG,2)
            x = DataG(gi).time(1,6:41);
            Y = DataG(gi).speedb(:,6:41);
            Y(:,6) = [];
            x(:,6) = [];
            D{gi} = Y;
            GN{gi} = repmat(G.g(gi),size(Y,1),1);
        end
           
        timeX = x;
        D = cell2mat(D);
        GN= celltakeout(GN);
        
        %% prep for rmanova
        rmfactorName = 't';
        factor1Name = 'groupname';
        pvlimit = 0.001;
        alphanum = 0.05;
        % group name
        a = regexpcellout(GN,'_','split');
        b = a(:,2);
        b(cellfun(@isempty,b)) = {'0mM'};
        s = a(:,1);
        TM = table;
        TM.(factor1Name) = GN;
        TM.strain = s;
        TM.dose = b;
        
        % velocity
        c1 = find(timeX==0)+1;
        c2 = find(timeX==2);
        D1 = D(:,c1:c2);
        n = size(D1,2);
        tpu = (1:n)';
        a = num2cellstr(tpu);
        colNames = strjoinrows([cellfunexpr(a,rmfactorName),a],'');
        tptable = table(tpu,'VariableNames',{rmfactorName});
        T = array2table(D1,'VariableNames',colNames);
        
        % anova table
        T = [TM T];
        return

        %% anova
        factorName = 'strain*dose';
        astring = sprintf('%s1-%s20~%s',rmfactorName,rmfactorName,factorName);
        rm = fitrm(T,astring,'WithinDesign',tptable);
        t = anovan_textresult(ranova(rm),0, 'pvlimit',pvlimit);
        as1 = sprintf('RMANOVA(%s,t:%s):\n%s\n',timeName,factorName,t)

        % run pairwise
        astring = sprintf('%s1-%s20~%s',rmfactorName,rmfactorName,factor1Name);
        rm = fitrm(T,astring,'WithinDesign',tptable);
        t = multcompare(rm,factor1Name);
        t2 = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum);
        as2 = sprintf('Posthoc(Tukey)curve by group):\n%s\n',t2)
        
       

        % comparison by taps
        t = multcompare(rm,factor1Name,'By',rmfactorName);
        %  keep only unique comparisons
%         a = strjoinrows([t.([factor1Name,'_1']) t.([factor1Name,'_2'])],' x ');
%         t(~ismember(a,gpairs),:) =[]; 
        t3 = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum);
%         as3 = sprintf('Posthoc(Tukey)t by %s curve by group):\n%s\n',t3)
%         sprintf('\nPosthoc(Tukey)%s by %s:\n%s\n',rmfactorName,factor1Name,t3); 
        
        
        %% record
        
        %%
        if isempty(t); fprintf(fid,'All comparison = n.s.\n');
        else fprintf(fid,'%s\n',multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum));    
        end
        
        %%
        
        return

        %% do stats
        
        
        return
        
        
    end


end


fprintf('Done\n');
% end


























    
    
    
    
    
    
    
    
    
    
    
    