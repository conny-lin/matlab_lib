

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
% effect sizse master
GroupMaster = {};
ESMaster = [];  
% ----------------------


for ti = 1:numel(timelist) % cycle through time choices
    % time ------------------
    tname = timelist{ti};
    ES = nan(numel(strainlist),3);  
    % -----------------------
    
    for si = 1:size(strainNames,1) % cycle through strains

        % report progress %------------
        fprintf(''); % separator
        processIntervalReporter(size(strainNames,1),1,'strain',si);
        % ------------------------------

        % data % -------------
        strain = strainNames.strain{si}; 
        p = fullfile(pData, tname,[strain,'by plate.csv']);
        Data = readtable(p);
        % ----------------

        % pct summary ----------------------------------
        d = Data.pct;
        group_plate = Data.groupname;
        gpairs = {'N2','N2_400mM'; 'N2',strain; strain,[strain,'_400mM']};
        A = nan(1,size(gpairs,1));
        [text,T,p,s,t,ST] = anova1_autoresults(d,group_plate);

        return
        for gi = 1:size(gpairs,1)
            g1 = gpairs{gi,1};
            g2 = gpairs{gi,2};
            % data
            xm1 = d(ismember(group_plate,g1));
            xm2 = d(ismember(group_plate,g2));
            % anova
%             ssum = table;
%             for dvi =1:numel(dvname)
%                 dv = dvname{dvi};
%                 x= TM.(dv);
%                 group = TM.gname;
%                 [text,T,p,s,t,ST] = anova1_autoresults(x,group);
%                 [tt,gnames] = multcompare_convt22016v(s);
% 
%                 result = multcompare_text2016b(tt,'grpnames',gnames,'prefix',[dv,'*']);
%                 textfile = sprintf('%s%s\n',textfile,result);
% 
%                 t2 = table;
%                 a = str2num(regexprep(dv,'t',''));
%                 t2.t = repmat(a,size(tt,1),1);
%                 tt2 = [t2 tt];
%                 ssum = [ssum ; tt2];
%             end
%             StatOut.mcomp_g_t = ssum;
            
            %% mean
            x1 = mean(d(ismember(group_plate,g1)));
            x2 = mean(d(ismember(group_plate,g2)));
            % summary
            pct = x2/x1;
            A(gi) = pct;
        end      
        
        ES(si,:) = A;
    end
    ESMaster = [ESMaster ES];
end

%% save table
cd(pM);
ES = ESMaster;
ES = array2table(ESMaster);
T = table;
T.strain = strainNames.strain;
T.genotype = strainNames.genotype;
T = [T ES];
writetable(T,'PCT.csv');
% report done --------------
beep on;
beep;
beep;
fprintf('\n--- Done ---\n\n' );
return
% --------------------------












