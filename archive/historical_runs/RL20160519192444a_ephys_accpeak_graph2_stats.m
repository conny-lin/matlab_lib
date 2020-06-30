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

rmfactorName = 't';
factor1Name = 'groupname';
pvlimit = 0.001;
alphanum = 0.05;
        
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
    timeNameList = {'t28_30','t1'};
    statString = '';
    StatOut = struct;
    savename = sprintf('%s/%s',pSave,strain);
    fid1 = fopen([savename,' Stats.txt'],'w');
    for ti = 1:numel(timeNameList)
        timeName = timeNameList{ti};
        
        fprintf('*** %s ***\n',timeName);
        load(sprintf('%s/%s/ephys graph/data_ephys_%s.mat',pSF,strain,timeName));
        

        %% graph
        graphEy(DataG,strain,timeName,pSave,Setting)
        
        %% STATS
        % get data 
        D = cell(size(DataG,2),1);
        GN = cell(size(DataG,2),1);
        for gi = 1:size(DataG,2)
            x = DataG(gi).time(1,6:41);
            Y = DataG(gi).speedb(:,6:41);
            Y(:,x==0) = NaN;
%             x(:,x==0) = [];
            D{gi} = Y;
            GN{gi} = repmat(G.g(gi),size(Y,1),1);
        end
           
        timeX = x;
        D = cell2mat(D);
        GN= celltakeout(GN);
        
        %% prep for rmanova
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
        c3 = find(timeX==0)-1;
        c2 = find(timeX==2);
        D1 = D(:,[c3 c1:c2]);
        n = size(D1,2);
        tpu = (0:n-1)';
        a = num2cellstr(tpu);
        colNames = strjoinrows([cellfunexpr(a,rmfactorName),a],'');
        tptable = table(tpu,'VariableNames',{rmfactorName});
        T = array2table(D1,'VariableNames',colNames);
        
        % anova table
        T = [TM T];
        
        

        %% anova
        factorName = 'strain*dose';
        astring = sprintf('%s0-%s20~%s',rmfactorName,rmfactorName,factorName);
        rm = fitrm(T,astring,'WithinDesign',tptable);
        StatOut.(timeName).fitrm = rm;
        t = ranova(rm); 
        StatOut.(timeName).ranova = t;
        t = anovan_textresult(t,0, 'pvlimit',pvlimit);
        fprintf(fid1,'RMANOVA(%s,t:%s):\n%s\n',timeName,factorName,t);
       
        % run pairwise
        astring = sprintf('%s0-%s20~%s',rmfactorName,rmfactorName,factor1Name);
        rm = fitrm(T,astring,'WithinDesign',tptable);
        StatOut.(timeName).fitrmg = rm;
        t = multcompare(rm,factor1Name);
        StatOut.(timeName).mcomp_g = t;
        t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum);
        fprintf(fid1,'\nPosthoc(Tukey)curve by group:\n%s\n',t);
        
       
        % comparison by taps
        t = multcompare(rm,factor1Name,'By',rmfactorName);
        StatOut.(timeName).mcomp_g_t = t;
        t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum);
        fprintf(fid1,'\nPosthoc(Tukey)%s by %s:\n%s\n',factor1Name,rmfactorName,t);

        % comparison within group bewteen time
        t = multcompare(rm,rmfactorName ,'By',factor1Name);
        StatOut.(timeName).mcomp_t_g = t;
        t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alphanum);
        fprintf(fid1,'\nPosthoc(Tukey)%s by %s:\n%s\n',rmfactorName,factor1Name,t);

        
        
        
    end
    
%     cd(pSave);
%     save(sprintf('%s/%s.mat',pSave,strain),'StatOut');

end


fprintf('Done\n');
% end


























    
    
    
    
    
    
    
    
    
    
    
    