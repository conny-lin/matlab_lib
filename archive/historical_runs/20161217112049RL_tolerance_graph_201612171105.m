%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GLOBAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paths ++++++++++++++
pDataHome = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/5-Tolerance/3-Results/0-Data/200mM 24h 200mM Chronic';
% --------------------

% settings ++++++
pvsig = 0.05;
pvlim = 0.001;
strainNames = DanceM_load_strainInfo;
% ---------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strainlist = {'DA609','MT14480','RB1025','RB1347','N2'};
nLim = 0; % no exclusion critiera
msr = 'speed';
linedata = 'sd';

for si = 1:numel(strainlist)
    % prepare data ++++++++++++++++++++++
    strain= strainlist{si};
    p = fullfile(pDataHome, strain,'Dance_RapidTolerance','raw.csv');
    % import
    Raw = readtable(p);
    
    straingrouplist = {'N2',strain};
    if strcmp(strain,'N2')
        straingrouplist = {strain};
    end

    for sgi= 1:numel(straingrouplist)
        
        % get strain group --------------
        straingroup = straingrouplist{sgi};
        i = ismember(Raw.strain,straingroup);
        Raw2 = Raw(i,:);
        % -------------------------------
        % get variables --------------------
        Data = table;
        Data.group = Raw2.condition_short;
        Data.speed = Raw2.speed;
        Data.midline = Raw2.midline;
        Data.curve = Raw2.curve;
        Data.goodnumber = Raw2.goodnumber;
        Data.speed_midline = Data.speed ./ Data.midline;
        Data.expdate = Raw2.exp_date;
        % ----------------------------------
        

        % filter conditions -----------------
        Data(Data.goodnumber < nLim,:) = [];
        % ------------------------------------

        % get data -----------------
        ictrl = ismember(Data.group,'0mM 0mM');
        DataC = Data(ictrl,:);
        DataG = Data(~ictrl,:);
        % ----------------------------

        % get data for lines ----
        d = DataC.(msr);
        n = numel(unique(DataG.group));
        [x,leg] = statsBasic(d,'outputtype','table');
        m1 = x.min;
        m2 = x.max;
        se1 = x.mean+x.se;
        se2 = x.mean-x.se;
        sd1 = x.mean+x.sd;
        sd2 = x.mean-x.sd;
        % -----------------------

        %% FIGURE ========================================================
        % settings
        Y = DataG.(msr);
        
        %% set scatter color
        switch linedata
            case 'range'
                lim_upper = m2;
                lim_lower = m1;
            case 'se'
                lim_upper = se1;
                lim_lower = se2;
            case 'sd'
                lim_upper = sd1;
                lim_lower = sd2;
        end
        
        
        color_upper = [0.5 0.5 0.5];
        color_lower = [1 0 1];
        colorlist = repmat(color_upper,numel(Y),1);
        for i = 1:size(colorlist,2)
            colorlist(Y < lim_upper,i) = color_lower(i);
        end

        % dot (exclude 0-0)
        fig1 = clusterDotsErrorbar(Y,DataG.group,...
                'markersize',6,...
                'groupseq',{'200mM 0mM','0mM 200mM','200mM 200mM'},...
                'yname',msr,'xname','','visible','on',...
                'fontsize',12,'scatterdotcolor',colorlist);

        setting = get(fig1);
        hold all

        return
        % add line (0-0) max min
        linec = [0 0 0];

        if strcmp(strain,'N2')
            linedata = 'range';
        end
        switch linedata
            case 'range'
                plot([0.5 n+0.5],[m1 m1],'Color',linec,'LineStyle','--')
                plot([0.5 n+0.5],[m2 m2],'Color',linec,'LineStyle','--')
            case 'se'
                plot([0.5 n+0.5],[se1 se1],'Color',linec,'LineStyle',':')
                plot([0.5 n+0.5],[se2 se2],'Color',linec,'LineStyle',':')
            case 'sd'
                plot([0.5 n+0.5],[sd2 sd2],'Color',linec,'LineStyle','--')
                plot([0.5 n+0.5],[sd1 sd1],'Color',linec,'LineStyle','--')
        end
        title(straingroup);
        % print 
        pSave = create_savefolder(fullfile(pM,'Graph Scatter'));

        printfig([strain ' ',straingroup],pSave,'w',5,'h',3)
        % ==============================================================

        %% Stats ========================================================
        %% stats differences ANOVA
        x = Data.(msr);
        group = Data.group;
        [text,T,p,s,t,ST] = anova1_autoresults(x,group);
        [txt] = anova1_multcomp_auto(x,group);
        create_savefolder(fullfile(pM,'ANOVA'));
        p = fullfile(pM,'ANOVA',[strain, ' ', straingroup,'.txt']);
        fid = fopen(p,'w');
        fprintf(fid,txt);
        fclose(fid);
        
        
        
        %% percentage overlap with control
        vnames = {'group','N'};
        
        % write in text
        pSave = create_savefolder(fullfile(pM,'PCT below control SD max'));
        
        TMaster = table;
        
        p = fullfile(pSave,[strain, ' ', straingroup,'.txt']);
        fid = fopen(p,'w');
        
        refnum1 = sd1;
        refnum2 = sd2;
        if strcmp(strain,'N2')
            refnum1 = m2;
            refnum2 = m1;
        end
        
        fprintf(fid, 'percent above 0mM 0mM mean+SD = %.3f\n\n',refnum1);
        i = DataG.speed > refnum1;
        T1 = tabulate(DataG.group(i));
        T1 = cell2table(T1(:,1:2),'VariableNames',vnames);
        T2 = tabulate(DataG.group);
        T2 = cell2table(T2(:,1:2),'VariableNames',vnames);
        T3 = outerjoin(T2,T1,'Keys','group','MergeKeys',1);
        T3.N_T1(isnan(T3.N_T1)) = 0;
        T3.pct = T3.N_T1./T3.N_T2;
        for x = 1:size(T3,1)
            fprintf(fid,'%s, %d/%d, %.3f\n',T3.group{x}, T3.N_T1(x), T3.N_T2(x), T3.pct(x));        
        end
        
        TMaster.group = T3.group;
        TMaster.above = T3.pct;
        


        fprintf(fid, '\n\npercent between 0mM 0mM mean+/-SD\n\n');
        i = DataG.speed < refnum1 & DataG.speed > refnum2;
        T1 = tabulate(DataG.group(i));
        T1 = cell2table(T1(:,1:2),'VariableNames',vnames);
        T2 = tabulate(DataG.group);
        T2 = cell2table(T2(:,1:2),'VariableNames',vnames);
        T3 = outerjoin(T2,T1,'Keys','group','MergeKeys',1);
        T3.N_T1(isnan(T3.N_T1)) = 0;
        T3.pct = T3.N_T1./T3.N_T2;
        for x = 1:size(T3,1)
            fprintf(fid,'%s, %d/%d, %.3f\n',T3.group{x}, T3.N_T1(x), T3.N_T2(x), T3.pct(x));        
        end
        
        TMaster.between = T3.pct;

        
        fprintf(fid, '\n\npercent below 0mM 0mM mean-SD = %.3f\n\n',refnum2);
        i = DataG.speed < refnum2;
        T1 = tabulate(DataG.group(i));
        T1 = cell2table(T1(:,1:2),'VariableNames',vnames);
        T2 = tabulate(DataG.group);
        T2 = cell2table(T2(:,1:2),'VariableNames',vnames);
        T3 = outerjoin(T2,T1,'Keys','group','MergeKeys',1);
        T3.N_T1(isnan(T3.N_T1)) = 0;
        T3.pct = T3.N_T1./T3.N_T2;
        for x = 1:size(T3,1)
            fprintf(fid,'%s, %d/%d, %.3f\n',T3.group{x}, T3.N_T1(x), T3.N_T2(x), T3.pct(x));        
        end
        
        TMaster.below = T3.pct;

        fclose(fid);
        
        p = fullfile(pSave,[strain, ' ', straingroup,'.csv']);

        writetable(TMaster, p);
        
        
        
        
        %% ==============================================================
    end

end









































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%