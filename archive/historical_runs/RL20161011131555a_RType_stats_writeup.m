% function RType_stats_writeup(savepath,pData,varargin)

%% INITIALIZING --------------------
clc; clear; close all; % clean memory
% paths
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);
% ---------------------------

% settings --------------------
% iv
pvlimit = 0.001;
alpha = 0.05;
baselinetime = -0.1;
responseT1 = 0.1;
responseT2 = 1;
phenotypeName = 'probability of acceleration response';
% data path
pDataM = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/4-EARS/3-Results/2-Genes EARS/x-response type probability/resp_type_probabiity_201610101118/Data';
% get times 
timelist = flip(dircontent(pDataM));
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
    savepath = fullfile(pM,'stats writeup.txt');
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

    for si = 51%1:size(strainNames,1) % cycle through strains
        
        %% LOAD STRAIN SPECIFIC FILES %%%%%%%%%%%%%%%%%%%%
        % strain + sample size ----------------
        % get strain
        strain = strainNames.strain{si};  
        % get genotype
        genotype = strainNames.genotype{si}; 
        mutation_type = strainNames.mutation{si};
        % state genotype
        fprintf('For %s, ',genotype);
        % ----------------------------------

        % load data files ---------------------------------------------------
        load(sprintf('%s/%s',pData,strain));
        % get common variables
        STMASTER = ST;
        S = STMASTER.ranova;
        SG = STMASTER.mcomp_g;
        ST = STMASTER.mcomp_t_g;
        STG = STMASTER.mcomp_g_t;
        
        GraphData = Mean;
%         readtable(sprintf('%s/%s graph values.csv',pData,strain));
    %     xtime = GraphData.N2_x;
    %     rtime = GraphData.N2_x(GraphData.N2_x >= responseT1 & ...
    %         GraphData.N2_x <= responseT2);
        % -----------------------------------
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% REPORTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% rANOVA -------------------------
        % starting sentence
        fprintf('An rANOVA evaluating the effect of %s and dose on %s ', genotype, phenotypeName)
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
                fprintf(', dose, F(%d,%d)tap = %.3f, %s',df1, df2,f,pvaluestr);
            else
                nonsig = [nonsig,{'dose'}];
            end

            % anova dose/strain
            rowName = 'strain:dose:t';
            pvalue = S.pValue(rowName);
            if pvalue < alpha
                fprintf(', and interaction between strain and dose, ');
                df1 = S.DF(rowName);
                df2 = S.DF('Error(t)');
                f = S.F(rowName);
                pvaluestr = print_pvalue(pvalue,pvlimit,alpha);
                fprintf('F(%d,%d)tap = %.3f, %s',df1, df2,f,pvaluestr);
            else
                nonsig = [nonsig,{'strain*dose'}];
            end
            
            %% deal with non significatn factors
            
        else
            fprintf('revealed no significant effects');
        end
        % -----------------------------------------------
        return
        % sample size -----------------------------
        fprintf(', %s',sample_size_text(strain));
        fprintf('. ');
        % -----------------------------------------

        %% wildtype 0mM pairwise time
        fprintf('Velocity of the wildtype 0mM group ');
        gname = 'N2';
        % pairwise
%         fprintf('%s',taptime_result(GraphData,ST,gname,'decreased'));
%         fprintf(', and %s',taptime_result(GraphData,ST,gname,'reversed'));

        % determine normality in wt response
%         [rq,rd] = response_data2(GraphData,gname);
%         conditions = [rq.rev(1) == false;
%                       any(rq.rev(2:3) == true)];
%         if all(conditions)
%            fprintf(', showing normal wildtype response kinetics');
%         end
        fprintf('. ');




        %% mutant 0mM vs wt 0mM
        % mutant 0mM pairwise description
        fprintf('Velocity of the %s 0mM group ',genotype);
        gname = strain; 
        [str,passed] = taptime_result(GraphData,ST,gname,'decreased');
        if passed; fprintf('%s',str); end
        [str,passed] = taptime_result(GraphData,ST,gname,'reversed');
        if passed; 
            fprintf(', and %s',str); 
        else
            fprintf(', but did not decrease below zero');
        end
        [str,passed] = taptime_result(GraphData,ST,gname,'increased');
        if passed; fprintf(', but %s',str); end

        % determine normality in wt response
        [rq,rd] = response_data2(GraphData,gname);
        conditions = [rq.rev(1) == false;all(rq.rev(2:3) == true)];
        if all(conditions)
           fprintf(', showing response kinetics similar to wildtype');
        end
        fprintf(' ');

        % compare with 0mM curve 
        fprintf(', and ', genotype);
        % get curve stats
        pvalue = SG.pValue(ismember(SG.groupname_1,strain) & ismember(SG.groupname_2,'N2'));
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        if pvalue < alpha
            mut_vs_wt_d = true;
        else
            mut_vs_wt_d = false;
        end

        % comparison of wt 0mM and mt 0mM
        % get curve stats
        pvalue_curve = SG.pValue(ismember(SG.groupname_1,strain) & ismember(SG.groupname_2,'N2'));
        pstr = print_pvalue(pvalue_curve,pvlimit,alpha);
        if pvalue < alpha
            fprintf('differed from the wildtype 0mM group (curve, wildtype 0mM vs 400mM, %s)',pstr);
        else
            fprintf('was not different from the wildtype 0mM group'); 
        end

        if mut_vs_wt_d
            pv = STG.pValue(ismember(STG.groupname_1,'N2') & ismember(STG.groupname_2,strain) & ismember(STG.t,1:10));
            rval = pv(1:end) < alpha;
            [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
            if ~isempty(tv)
                s = taptime_pvalue(tv,pstr);
                fprintf(' %s',s)
                fprintf(', suggesting %s altered responses in the absence of ethanol. ',genotype);
            end
        else
            fprintf(', indicating %s had no effect on response velocity. ', genotype)
        end





        %% wildtype 400mM 
        gname = 'N2_400mM'; gnametext = 'wildtype 400mM'; fn = [gname,'_y'];
        % title sentence
        fprintf('For the ethanol groups, velocity of the %s group ', gnametext);

         % wildtype 400mM pairwise time
        [str,passed] = taptime_result(GraphData,ST,gname,'increased');
        if ~passed
            fprintf('%s', str);
            wtEARS_failed = true;
        else
            fprintf('%s', str);
            wtEARS_failed = false;
        end

        % linker
        fprintf(', and ');

        % vs 0mM wildtype curve
        pvalue = SG.pValue(ismember(SG.groupname_1,'N2') & ismember(SG.groupname_2,'N2_400mM'));
        pstr = print_pvalue(pvalue,pvlimit,alpha);
        if pvalue < alpha
            fprintf('differed from the wildtype 0mM group (curve, %s)',pstr);
        else
            fprintf('did not differ from the wildtype 0mM group');

        end
        if ~wtEARS_failed 
            if pvalue < alpha
                fprintf(', indicating wildtype showed EARS');
            else
                fprintf(', indicating wildtype failed to show effect of ethanol on response velocity');
            end
        else
            fprintf(', indicating wildtype failed to show EARS');
            if pvalue < alpha
                fprintf(' but retained some effect of ethanol on response velocity');
            else
                fprintf(' and disrupted effect of ethanol on response velociyt');
            end


        end


        % linker
        fprintf('. ');





        %% mutant 400mM vs mutant 0mM
        % mutant 400mM pairwise time
        fprintf('Velocity of the %s 400mM group ', genotype);
        gname = [strain,'_400mM']; gnametext = [genotype, ' 400mM'];
        % increased
        [str,passed] = taptime_result(GraphData,ST,gname,'increased');
        if passed
            fprintf('%s', str);
            mutEars = true;
        else
            fprintf('did not increase above baseline');
            mutEars = false;
        end
        % decreased
        [str,passed] = taptime_result(GraphData,ST,gname,'decreased');
        fprintf(', %s',str);
        % reversed
        [str,passed] = taptime_result(GraphData,ST,gname,'reversed');
        fprintf(', %s',str);

        fprintf(', ');

        % compare with 0mM curve 
        pvalue = SG.pValue(ismember(SG.groupname_1,[strain,'_400mM']) & ismember(SG.groupname_2,strain));
        if pvalue < alpha
            M0M4same = false;
            fprintf('was different from the %s 0mM group (curve, %s)',genotype, pstr);

            % pairwise
            pv = STG.pValue(ismember(STG.groupname_1,strain) & ismember(STG.groupname_2,[strain,'_400mM']) & ismember(STG.t,1:10));
            rval = pv(1:end) < alpha;
            [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
            if ~isempty(tv)
                s = taptime_pvalue(tv,pstr);
                fprintf(' %s',s)
            end


        else
            M0M4same = true;
            fprintf('was not different from the %s 0mM group',genotype);
        end

        fprintf(', ');

        pvalue2 = SG.pValue(ismember(SG.groupname_1,[strain,'_400mM']) & ismember(SG.groupname_2,'N2_400mM'));
        if pvalue2 < alpha
            M4W4same = false;
            pstr = print_pvalue(pvalue2,pvlimit,alpha);
            fprintf('and was different from the wildtype 400mM group (curve, %s)',pstr);

            % pairwise
            pv = STG.pValue(ismember(STG.groupname_1,'N2_400mM') & ismember(STG.groupname_2,[strain,'_400mM']) & ismember(STG.t,1:10));
            rval = pv(1:end) < alpha;
            [pstr,~,tv] = pvaluestring(rtime,rval,pv,alpha,pvlimit);
            if ~isempty(tv)
                s = taptime_pvalue(tv,pstr);
                fprintf(' %s',s)
            end

        else
            M4W4same = true;
            fprintf('but was not different from the wildtype 400mM group');
        end

        fprintf(', indicating %s ', genotype);

        if M0M4same
            fprintf('eliminated ');
        else
            fprintf('retained ')  
        end
        fprintf('effects of ethanol on response velocity');

        fprintf(', ');

        if mutEars
            if ~M4W4same
                fprintf('and retained EARS');
            else
                fprintf('and had wildtype EARS');
            end
        else
            fprintf('but disrupted EARS');
            if M4W4same
                fprintf('but wildtype also did not show EARS');            
            end
        end



        fprintf('. ');





        %% mutant 400mM vs wt 400mM
        % compare with 0mM curve 
    %     fprintf('Velocity curve of %s 400mM ', genotype);
    %     i = ismember(SG.groupname_1,[strain,'_400mM']) & ismember(SG.groupname_2,'N2_400mM');
    %     pvalue = SG.pValue(i);
    %     if pvalue < alpha
    %         pstr = print_pvalue(pvalue,pvlimit,alpha);
    %         fprintf('was significantly different from wildtype 400mM (%s), ',pstr);
    %         m4vsw4sig = true;
    %         fprintf('suggesting %s mutation changed response velocity on ethanol. ',genotype);
    %     else
    %         fprintf('was similar to that of wildtype 400mM, ');
    %         fprintf('suggesting %s had no effect on response velocity on ethanol. ', genotype)
    %         m4vsw4sig = false;
    %     end





        %% final conclusion
        if wtEARS_failed
         fprintf('Since wildtype did not show EARS, more experiment is required to confirm this finding. ');
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



