

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
addpath('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Graphs/ephys');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% GLOBAL INFORMATION
% paths & settings -----------
pSave = fileparts(pM);
addpath(fileparts(pM));
pData = '/Volumes/COBOLT/MWT';
% ---------------------------

% strains %------
pData = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/rType_fig_bar/Data';
timelist = dircontent(pData);
% get strain info
pStrain = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/1-response type probability/resp_type_probabiity_acc_201610101118/raster_RespondOnly_20161013/Figure/t1';
[~,~,strainlist] = dircontent(pStrain);
strainNames = DanceM_load_strainInfo(strainlist);
%----------------

% settings %--------------------
time_baseline = [-0.3 -0.1];
time_response = [0.1 0.5];
n_lowest = 10;

statsName = 'exclude no response';
% --------------------------------


%% effect size
Output = struct;
% col name
cpn = {'W0W4','W0M0','M0M4','W4M4'}';

c = {};
for ti= 1:numel(timelist)
    a = repmat(timelist(ti),size(cpn,1),1);
    b = strjoinrows([a cpn],'_');
    c = [c;b];
end
colNames = c;
% effect sizse master
ESMaster = nan(size(strainNames,1),numel(colNames)); 
PVALUE = ESMaster;
% ----------------------

for si = 1:size(strainNames,1) % cycle through strains
    
    Stats = struct;
    col1 = 1;
    
    for ti = 1:numel(timelist) % cycle through time choices
        % time ------------------
        tname = timelist{ti};
        ES = nan(numel(strainlist),3);  
        col2 = col1+numel(cpn)-1;
        % -----------------------    

        % report progress %------------
        fprintf(''); % separator
        processIntervalReporter(size(strainNames,1),1,'strain',si);
        % ------------------------------

        % data % -------------
        strain = strainNames.strain{si}; 
        p = fullfile(pData, tname,[strain,'by plate.csv']);
        Data = readtable(p);
        d = Data.pct;
        group_plate = Data.groupname;
        Stats.data = d;
        Stats.group = group_plate;
        % ----------------

        % stats -----------------------------------------------
        [text,T,p,s,t,ST] = anova1_autoresults(d,group_plate);
        Stats.anova = ST;
        Stats.anovaS = s;
        Stats.descriptive_stats = T;
        Stats.anova_text = text;
        
        [tt,gnames] = multcompare_convt22016v(s);
        Stats.multcomp = tt;
        Stats.gnames = gnames;
        
        result = multcompare_text2016b(tt,'grpnames',gnames);
        Stats.multcomp_text = result;
        % ----------------------------------------------------
        
        % comparison pairs ----------------------------------
        gpairs = {'N2','N2_400mM'; 'N2',strain; strain,[strain,'_400mM'];'N2_400mM',[strain,'_400mM']};
        % --------------------------------------------------
        
        % pct summary  ----------------------------------
        A = nan(1,size(gpairs,1));
        
        for gi = 1:size(gpairs,1)
            g1 = gpairs{gi,1};
            g2 = gpairs{gi,2};
            % data
            xm1 = d(ismember(group_plate,g1));
            xm2 = d(ismember(group_plate,g2));
            % mean
            x1 = mean(d(ismember(group_plate,g1)));
            x2 = mean(d(ismember(group_plate,g2)));
            % summary
            pct = x2/x1;
            A(gi) = pct;
        end 
        ESMaster(si,col1:col2) = A;
        % -----------------------------------------------------
               
        % summarize comparison -------------------------------
        A = nan(1,size(gpairs,1));
        S = Stats.multcomp;
        
        DS = Stats.descriptive_stats;
        rownames = DS.gnames;
        DS = DS(:,2:end);
        DS.Properties.RowNames = rownames;
        
        for gi = 1:size(gpairs,1)
            % get group names
            g1 = gpairs{gi,1};
            g2 = gpairs{gi,2};
            % get p value
            pv = S.pValue(ismember(S.gname_1,g1) & ismember(S.gname_2,g2));
            if isempty(pv)
                pv = S.pValue(ismember(S.gname_1,g2) & ismember(S.gname_2,g1));
            end
            % get sign (increase or decrease)
            negative_value = (DS.mean(g2) - DS.mean(g1)) < 0;
            if negative_value
               pv = -pv; 
            end
            % put in summary
            A(gi) = pv;
        end
        PVALUE(si,col1:col2) = A;

        % ---------------------------------------------------
        

        
        % save -----------------------------------------------
        pS = create_savefolder(fullfile(pM,'Stats'),tname);
        svname = fullfile(pS,[strain,'.mat']);
        save(svname,'Stats');
        % ----------------------------------------------------
        
        col1 = col1+numel(cpn);

    end
end

%% save table
T = table;
T.strain = strainNames.strain;
T.genotype = strainNames.genotype;

ES = array2table(ESMaster,'VariableNames',colNames);
T2 = [T ES];
writetable(T2,fullfile(pM,'PCT.csv'));

ES = array2table(PVALUE,'VariableNames',colNames);
T2 = [T ES];
writetable(T2,fullfile(pM,'pvalue.csv'));
% report done --------------
beep on;
beep;
beep;
fprintf('\n--- Done ---\n\n' );
return
% --------------------------












