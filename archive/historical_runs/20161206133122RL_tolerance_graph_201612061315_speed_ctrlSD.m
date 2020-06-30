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
strainlist = {'DA609','MT14480','RB1025','RB1347'};
nLim = 0;
msr = 'speed';
linedata = 'sd';

for si = 1:numel(strainlist)
    % prepare data ++++++++++++++++++++++
    strain= strainlist{si};
    p = fullfile(pDataHome, strain,'Dance_RapidTolerance','raw.csv');
    % import
    Raw = readtable(p);

    straingrouplist = {'N2',strain};

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
        % N
        Data(Data.goodnumber < nLim,:) = [];
         
        % curve (only to N2)
%         if strcmp(straingroup,'N2')
%             c = min(Data.curve(ismember(Data.group,'0mM 0mM')));
%             i = ismember(Data.group,{'0mM 200mM','200mM 200mM'}) & ...
%                 Data.curve > c;
%             Data(i,:) = [];
%         end
%         
        % get rid of 20150104 for MT14480 exp
%         if strcmp(strain,'MT14480')
%             i = Data.expdate == 20150104;
% 
%             Data(i,:) = [];
%         end
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
        % dot (exclude 0-0)
        fig1 = clusterDotsErrorbar(Y,DataG.group,...
                'markersize',6,...
                'groupseq',{'200mM 0mM','0mM 200mM','200mM 200mM'},...
                'yname',msr,'xname','','visible','off',...
                'fontsize',12,'scatterdotcolor',[0.5 0.5 0.5]);

        setting = get(fig1);
        hold all

        % add line (0-0) max min
        linec = [0 0 0];

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
        
        
        %% ==============================================================
    end

end









































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%