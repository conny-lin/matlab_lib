%% OBJECTIVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get comparison between time within group 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SETTINGS
msrlist = {'curve','speed'};


%% DATA
pDataFolder = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/2-Wildtype/3-Results/Figures & Data/Fig2-1 Body Curve 60m 3 4 5 do/AssayAge/Dance_DrunkMoves';
datafilename = 'Dance_DrunkMoves.mat';
pData = fullfile(pDataFolder,datafilename);
load(pData,'MWTSet');
Data = MWTSet.Data_Plate;
% VarRef_groupname = MWTSet.Info.VarIndex.groupname;
% 
% 
% %% DATA TRANSFORMATION
% %% combine data into one table
% uniqueIDRef = {'groupname','mwtname','timeind'};
% 
% for msri = 1:numel(msrlist)
%     
%     msr = msrlist{msri}; % get variable name
% 
%     % set up first table
%     D = Data.(msr)(:,{'groupname','mwtname','timeind','frame_N','mean'}); % get data
%     D.Properties.VariableNames(ismember(D.Properties.VariableNames,'mean')) = {msr};
%     % combine with previous table
%     if msri == 1
%        D1 = D;
%     else
%        if size(D)==size(D1)
%            if ~isequal(D1(:,uniqueIDRef),D(:,uniqueIDRef))
%                error('two tables does not have the same reference id');
%            else
%                D1.(msr) = D.(msr);
%            end
%        else
%            error('two tables not the same size');
%        end
%     end
% end
% D = D1; 
% clear D1 msr msri
% 
% %% replace varaible to text
% D.groupname = VarRef_groupname(D.groupname); % replace groupname index to text



%% rmANOVA, tukey between time
DataMaster = MWTSet.Data_Plate;
MWTDB = parseMWTinfo(MWTSet.PATHS.pMWT);
VarRef = MWTSet.Info.VarIndex;
for msri = 1:numel(msrlist)
    % get msr name
    msr = msrlist{msri};
    % get data
    Data = DataMaster.(msr);
    m = VarRef.mwtname(Data.mwtname);
    g = VarRef.groupname(Data.groupname);
    e = VarRef.expname(Data.expname);
    a = cellfun(@fullfile,e,g,m,'UniformOutput',0);
    MWTDB =parseMWTinfo(a);
    MWTDBU = parseMWTinfo(unique(a));
    [~,j] = ismember(MWTDB.mwtpath, MWTDBU.mwtpath);
    Data.mwtname = j;
    
    %% modify time 
    Data.timeind(Data.timeind ==1) = 0;
    tt = [0:10:60];
    Data(~ismember(Data.timeind,tt),:) = [];
    Data.timeind = (Data.timeind./10)+1;
    
    
    %% RM ANOVA ==========================================================
    % convert data to rmANOVA format
    % get dose
    g = MWTDBU.groupname;
    a = regexpcellout(g,'\d{1,}(?=mM)','match');
    a(cellfun(@isempty,a)) = {'0'};
    dose = cellfun(@str2num,a);
    
    % get age
    a = regexpcellout(g,'\d{1,}(?=d)','match');
    a(cellfun(@isempty,a)) = {'4'};
    age = cellfun(@str2num,a);
    
    % get rm variables
    mwtid = unique(Data.mwtname);
    timeid = unique(Data.timeind);
    
    A = nan(max(mwtid),max(timeid));
    i = sub2ind(size(A), Data.mwtname, Data.timeind);
    A(i) = Data.mean;
    a = cellfun(@num2str,num2cell(timeid),'UniformOutput',0);
    b = cellfunexpr(a,'t');
    c = strjoinrows([b a],'');
    t = array2table(A,'VariableNames',c);
    
    
    %% combine all
    T = table;
    T.gname = g;
    T.age = age;
    T.dose = dose;
    T = [T t];
    
    % exclude no data or zero data
    T(any(isnan(A),2),:) = [];
    T(any(A==0,2),:) = [];
    
    % within design table
    withinDesignT = table;
    withinDesignT.t = unique(Data.timeind);
    
    % get unique pairwise
    gpairs = pairwisecomp_getpairs(unique(T.gname));
    gpairs = strjoinrows(gpairs,' x ');

    % rmanova settigns +++
    pvlimit = 0.001;
    alpha = 0.05;
    rmName = 't';    
    gFactorName = 'dose*age';
    % ------------------
    
    %% rmanova multi-factor +++++++
    rmTerm = sprintf('%s1-%s7~%s',rmName,rmName,gFactorName);
    rm = fitrm(T,rmTerm,'WithinDesign',withinDesignT);
    t = anovan_textresult(ranova(rm), 0, 'pvlimit',pvlimit);
    textout = sprintf('RMANOVA(%s:%s):\n%s\n',rmName,gFactorName,t);
    % ----------------------------

    % rmanova pairwise by group ++++++++
    compName = 'gname';
    rm = fitrm(T,'t1-t7~gname','WithinDesign',withinDesignT);
    t = multcompare(rm,compName);
    %  keep only unique comparisons
    a = strjoinrows([t.([compName,'_1']) t.([compName,'_2'])],' x ');
    save(fullfile(pM,[msr ,' by group.mat']),'t');
    t(~ismember(a,gpairs),:) =[];
    t(t.pValue > alpha,:) = [];
    % text output
    textout = sprintf('%s\nPosthoc(Tukey) by %s:\n',textout,compName);
    if isempty(t)
        textout = sprintf('%s\nAll comparison = n.s.\n',textout);
    else
        t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alpha);
        textout = sprintf('%s\n%s\n',textout,t);
    end
    % ----------------------------------

    
    return



    % comparison by time +++++++++++
    compName = 'gname';
    t = multcompare(rm,compName,'By',rmName);
    
    %  keep only unique comparisons
    a = strjoinrows([t.([compName,'_1']) t.([compName,'_2'])],' x ');
    save(fullfile(pM,[msr ,' by time.mat']),'t');
    t(~ismember(a,gpairs),:) =[];
    t(t.pValue > alpha,:) = [];
    % record
    textout = sprintf('%s\n\nPosthoc(Tukey)%s by %s:\n',textout,rmName,compName); 
    if isempty(t); 
        textout = sprintf('%s\nAll comparison = n.s.\n',textout);
    else
        t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alpha);
        textout = sprintf('%s\n%s\n',textout,t);
    end
    % --------------------------------
    %% RM ANOVA END ========================================================

    
    %% write text output ++++++++++
    fid = fopen(fullfile(pM,[msr, ' rmANOVA.txt']),'w');
    fprintf(fid,'%s',textout);
    fclose(fid);
    %% ---------------------------
    
end







































