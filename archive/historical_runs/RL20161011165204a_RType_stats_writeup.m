% function RType_stats_writeup(savepath,pData,varargin)

%% INITIALIZING --------------------
clc; clear; close all; % clean memory
% paths
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

%% settings --------------------
% iv
pvlimit = 0.001;
alpha = 0.05;
baselinetime = -0.1;
responseT1 = 0.1;
responseT2 = 1;
phenotypeName = 'acceleration response probability';
phenotypeNameCap = 'Acceleration response probability';
% data path
pDataM = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/x-response type probability/resp_type_probabiity_201610101118/Data';
% get times 
timelist = flip(dircontent(pDataM));
timeText = {'last 3 taps','first tap'};
rtime = [0.1:0.1:0.5]';

% -------------------


%% cycle through time
for ti = 1:numel(timelist)
    
    %% LOAD FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get data path --------------
    tname = timelist{ti};
    pData = fullfile(pDataM,tname);
    % --------------------
    
    % get shared data -----------------------
    % get strains
    fn = dircontent(pData);
    a = regexpcellout(fn,'[A-Z]{2,}\d{1,}','match');
    a(cellfun(@isempty,a)) = [];
    strain_name_list = unique(a);
    % get strain info 
    load('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/MWTDatabase/StrainNames.mat');
    strainNames(~ismember(strainNames.strain,strain_name_list),:) = [];
    strainNames = sortrows(strainNames,{'genotype'});
    % -------------------------


    % generate output files ---------------------
    savepath = fullfile(pM,['stats writeup ',tname,'.txt']);
    diaryfile = sprintf(savepath);
    if exist(diaryfile,'file')
        diaryfile_archive =sprintf('writeup diary %s.txt', generatetimestamp);
        movefile(diaryfile, diaryfile_archive);
    end
    fid = fopen(diaryfile,'w');
    fclose(fid);
    diary(diaryfile);
    % --------------------------------------
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for si = 1:size(strainNames,1) % cycle through strains
        
        %% LOAD STRAIN SPECIFIC FILES %%%%%%%%%%%%%%%%%%%%
        % strain + sample size ----------------
        % get strain
        strain = strainNames.strain{si};  
        % get genotype
        genotype = strainNames.genotype{si}; 
        mutation_type = strainNames.mutation{si};
        % state genotype
        fprintf('For responses to the %s, ',timeText{ti});
        % ----------------------------------

        % load data files ---------------------------------------------------
        load(sprintf('%s/%s',pData,strain));
        % get common variables
        STMASTER = ST;
        S = STMASTER.ranova;
        SG = STMASTER.mcomp_g;
        ST = STMASTER.mcomp_t_g;
        STG = STMASTER.mcomp_g_t;
        GNAME= gname;
        GraphData = Mean;
        % -----------------------------------
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %% REPORTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% rANOVA -------------------------
        % starting sentence
        fprintf('an rANOVA evaluating the effect of %s and dose on %s ', genotype, phenotypeName)
        if any(S.pValue(2:end) < alpha)
            % prefix
            fprintf('revealed significant effect of ');
            nonsig = {};
            
            % anova strain
            rowName = 'strain:t';
            pvalue = S.pValue(rowName);
            if pvalue < alpha
                df1 = S.DF(rowName);
                df2 = S.DF('Error(t)');
                f = S.F(rowName);
                pvaluestr = print_pvalue(pvalue,pvlimit,alpha);
                fprintf('strain, F(%d,%d)tap = %.3f, %s',df1, df2,f,pvaluestr);
            else
                nonsig = [nonsig,{'strain'}];
            end

            % anova dose
            rowName = 'dose:t';
            pvalue = S.pValue(rowName);
            if pvalue < alpha
                df1 = S.DF(rowName);
                df2 = S.DF('Error(t)');
                f = S.F(rowName);
                pvaluestr = print_pvalue(pvalue,pvlimit,alpha);
                if ~isempty(nonsig)
                    fprintf(', ');
                end
                fprintf('dose, F(%d,%d)tap = %.3f, %s',df1, df2,f,pvaluestr);
            else
                nonsig = [nonsig,{'dose'}];
            end

            % anova dose/strain
            rowName = 'strain:dose:t';
            pvalue = S.pValue(rowName);
            if pvalue < alpha
                if ~isempty(nonsig)
                    fprintf(', ');
                end
                fprintf('and interaction between strain and dose, ');
                df1 = S.DF(rowName);
                df2 = S.DF('Error(t)');
                f = S.F(rowName);
                pvaluestr = print_pvalue(pvalue,pvlimit,alpha);
                fprintf('F(%d,%d)tap = %.3f, %s',df1, df2,f,pvaluestr);
            else
                nonsig = [nonsig,{'strain*dose'}];
            end
            
            % deal with non significatn factors
            n = numel(nonsig);
            if n>0
                fprintf(', but not ');
                if n==1
                    fprintf('%s',char(nonsig));
                else
                    if n==2
                        fprintf('%s nor %s',nonsig{1},nonsig{2});
                    else
                        a = strjoin(nonsig(1:end-1),', ');
                        b = fprintf('%s nor %s',a, nonsig{end});
                    end
                end
            end
        else
            fprintf('revealed no significant effects');
        end
        % -----------------------------------------------
        
        %% sample size -----------------------------
        fprintf(', %s',sample_size_text2(GNAME,SampleSize));
        fprintf('. ');
        % -----------------------------------------

        %% mutant effect: mutant 0mM vs wt 0mM --------------------------
        % mutant 0mM pairwise description
        fprintf('In the absence of ethanol, %s of the %s group ',phenotypeName, genotype);
        gname = strain; 
        % compare between groups
        [pstr, tv] = pairwisetime_comp('N2', strain, STG, rtime, alpha, pvlimit);
        if ~isempty(tv)
            fprintf('was different from the wildtype 0mM group');
            s = taptime_pvalue(tv,pstr);
            fprintf(' %s',s)
            fprintf(', indicating %s altered %s',genotype, phenotypeName);
        else
            fprintf('was similar to the wildtype 0mM group');
            fprintf(', indicating %s had no effect on %s', genotype, phenotypeName)
        end
        fprintf(' in the absence of ethanol. ');
        % ----------------------------------------------------------------

        
        %% wildtype 0mM vs wiltype 400m -------------------------------
        % mutant 0mM pairwise description
        fprintf('In the presence of ethanol, %s of the wildtype 400mM group ',phenotypeName);
        % compare between groups
        [pstr, tv] = pairwisetime_comp('N2', 'N2_400mM', STG, rtime, alpha, pvlimit);
        if ~isempty(tv)
            fprintf('was different from the wildtype 0mM group');
            s = taptime_pvalue(tv,pstr);
            fprintf(' %s',s)
            fprintf(', indicating ethanol altered %s. ', phenotypeName);
            wtEARS_failed = false;

        else
            fprintf('was similar to the wildtype 0mM group');
            fprintf(', indicating ethanol failed to alter %s', phenotypeName);
            wtEARS_failed = true;

        end
        % ----------------------------------------------------------------

        
        %% mutant 0mM vs mutant 400m -------------------------------
        fprintf('%s of the %s 400mM group ',phenotypeNameCap, genotype);
        % compare between groups
        [pstr, tv] = pairwisetime_comp(strain, [strain '_400mM'], STG, rtime, alpha, pvlimit);
        if ~isempty(tv)
            fprintf('was different from the %s 0mM group',genotype);
            s = taptime_pvalue(tv,pstr);
            fprintf(' %s',s);
            M0M4sig = true;
        else
            M0M4sig = false;
            fprintf('was similar to the %s 0mM group',genotype);
        end
        fprintf('. ');
        % ----------------------------------------------------------------




        %% mutant 400mM vs wiltype 400m -------------------------------
        fprintf('%s ofthe  %s 400mM group ',phenotypeNameCap, genotype);
        % compare between groups
        [pstr, tv] = pairwisetime_comp('N2_400mM', [strain '_400mM'], STG, rtime, alpha, pvlimit);
        if ~isempty(tv)
            fprintf('was different from the wildtype 400mM group');
            s = taptime_pvalue(tv,pstr);
            fprintf(' %s',s)
%             fprintf(', suggesting %s changed some effects of ethanol on %s. ', genotype, phenotypeName);
        else
            fprintf('was similar to the wildtype 400mM group');
%             fprintf(', suggesting %s retained wildtype effect of ethanol on %s. ',genotype, phenotypeName);
        end
        fprintf(', ');
        % ----------------------------------------------------------------




        %% mutant 400mM vs wiltype 0m -------------------------------
%         fprintf('%s of %s 400mM group ',phenotypeNameCap, genotype);
        % compare between groups
        [pstr, tv] = pairwisetime_comp('N2', [strain '_400mM'], STG, rtime, alpha, pvlimit);
        fprintf('and ');
        if ~isempty(tv)
            fprintf('was different from the wildtype 0mM group');
            s = taptime_pvalue(tv,pstr);
            fprintf(' %s',s)
%             fprintf(', suggesting %s retained some effects of ethanol on %s. ', genotype, phenotypeName);
        else
            fprintf('was similar to the wildtype 0mM group');
%             fprintf(', suggesting %s lost the effect of ethanol on %s. ',genotype, phenotypeName);

        end
        fprintf(', ');
        % ----------------------------------------------------------------




        %% final conclusion ---------------------------------------------
        if M0M4sig
           fprintf('suggesting %s retained the effect of ethanol on %s', genotype, phenotypeName);
        else
           fprintf('suggeting %s disrupted the effect of ethanol on %s', genotype, phenotypeName);
        end
        fprintf(' to the %s. ',timeText{ti});
            
        if wtEARS_failed
         fprintf('Since wildtype did not show ethanol''s effect on %s, more experiment is required to confirm this finding. ', phenotypeName);
        end




        %% finish
        fprintf('\n\n');
        
    end
    fprintf('\n');
    diary(diaryfile);
    diary off

end

% report done --------------
fprintf('\n--- Done ---' );
return
% --------------------------


return



