%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSaveM = setup_std(mfilename('fullpath'),'RL','genSave',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%

% define measures
msrlist = {'RevFreq','RevSpeed','RevDur'};
pData = fullfile(fileparts(pSaveM),'Data');



%% GET STRAIN INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%
% get group names
[fn,p] = dircontent(pData);
% minus archive code folder
p(regexpcellout(fn,'[_]')) = [];
% get gene names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
p = celltakeout(p);
% get strain names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
pstrains = celltakeout(p);
strainnames = celltakeout(fn);
% get gene name
p = cellfun(@fileparts,pstrains,'UniformOutput',0);
[p,genenames] = cellfun(@fileparts,p,'UniformOutput',0);
% get groupname
[p,groupnames] = cellfun(@fileparts,p,'UniformOutput',0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%


%% GET AREA UNDER THE CURVE ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
for si = 1:numel(strainnames)
    sn = strainnames{si};
    loopreporter(si,sn,1,numel(strainnames))
    %% GET REVERESAL DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
    dancename = 'Dance_ShaneSpark4';
    pdata = fullfile(pstrains{si},'TWR',dancename,[dancename,'.mat']);
    if ~exist(pdata,'file')
        dancename = 'Dance_ShaneSpark5';
        pdata = fullfile(pstrains{si},dancename,[dancename,'.mat']);
        if ~exist(pdata,'file')
            error('missing file');
        end
    end
    if exist(pdata,'file')
        load(pdata);
        pSave = create_savefolder(pstrains{si},'TWR_Area');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%

        %% ANALYZE AREA UNDER THE CURVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
        % transform data -------------------------------------------------20170721-
        % individual plate line data
        Raw = MWTSet.Raw;
        ru =unique(Raw.mwtid);
        rn = numel(ru); % get number of mwtid
        cu = unique(Raw.tap);
        cn = numel(cu); % get number of taps
        % create structure array output
        S = struct; 
        S.mwtid = ru;
        S.taps = cu;
        for msri = 1:numel(msrlist)
            msr = msrlist{msri}; % get msr name
            A = nan(rn,cn); % create output array (r=mwtid, c=taps)
            % get index from sub
            [~,r] = ismember(Raw.mwtid,ru);
            c = Raw.tap;
            i = sub2ind(size(A),r,c);
            % locate data into output array, go by measures
            A(i) = Raw.(msr);
            % put into struct
            S.(msr) = A;
        end
        MWTSet.Data_transformed.plate_tap = S;
        %-----------------------------------------------------------------20170721-

        % calculations ---------------------------------------------------20170721-
        % calculate area under the curve  -------------------------------20170721-
        caltype = 'area';
        SS = struct;

        x = S.taps; % get x (tap)
        % create output table
        T = table;
        T.mwtid = S.mwtid;
        for msri = 1:numel(msrlist) % repeat by meausre 
            msr = msrlist{msri}; % get msr name
            D = S.(msr); % get data from the measure
            % create output array
            A = nan(size(D,1),1);
            for mwtidi = 1:size(D,1) % repeat by mwtid
                % get y per mwtid (response)
                y = D(mwtidi,:);
                % calculate area under the curve (taprz)
                A(mwtidi) = trapz(x,y);
            end
            T.(msr) = A; % put data in summary
        end
        % get mwtid info from database
        M = MWTSet.MWTDB;
        T = outerjoin(T,M,'LeftVariable',T.Properties.VariableNames,...
            'RightVariable',{'mwtid','expname','strain','groupname','rx'},...
            'MergeKey',1);

        % anova
        for msri = 1:numel(msrlist) 
            msr = msrlist{msri}; % get msr name
            % anova for difference between groups - area under the curve 
            [txt,anovastats,multstats,T2] = anova1_std_v2(T.(msr),T.groupname, 'plate');
            % put in central array
            SS.(msr).raw = T;
            SS.(msr).anovatext = txt;
            SS.(msr).anovastats = anovastats;
            SS.(msr).multstats = multstats;
            SS.(msr).descriptive = T2;
        end

        % export
        for msri = 1:numel(msrlist) 
            msr = msrlist{msri}; % get msr name
            % export anova text in text file
            str = SS.(msr).anovatext;
            p = fullfile(pSave, sprintf('%s %s.txt',msr,caltype)); % create file name
            fid = fopen(p,'w');
            fprintf(fid,'%s',str);
            fclose(fid);
            % export graph excel csv
            p = fullfile(pSave, sprintf('%s %s.csv',msr,caltype)); % create file name
            writetable(SS.(msr).descriptive, p);
        end

        % final put back in Cal
        MWTSet.(caltype) = SS;
        %-----------------------------------------------------------------20170721-


        % percent difference from 0mM control %---------------------------20170721-
        caltype = 'area_pctctrl';
        SS = struct;

        ctrl_rx = {'NA'}; % define control
        Raw = MWTSet.area.(msrlist{msri}).raw; % get data
        % exclude none 0mM data
        C = Raw(ismember(Raw.rx,ctrl_rx),:);
        % calculate 0mM control by experiment
        A = grpstats(C,{'expname','strain','groupname'},{'numel','mean','sem'},'DataVars',msrlist);
        % get only 400mM data
        E = Raw(~ismember(Raw.rx,ctrl_rx),:);
        % create msrlist names
        rv = strjoinrows([cellfunexpr(msrlist','mean') msrlist'],'_');
        % match up control data exp data
        C = outerjoin(E,A,'RightVariables',rv,'Key',{'expname','strain'},'Type','left');
        % calculate percent difference from 0mM control
        A = E;
        for msri = 1:numel(msrlist)
            msr = msrlist{msri};
            cmsr = sprintf('mean_%s',msr);
            e = E.(msr); % get exp data, 
            c = C.(cmsr); % get control data
            p = e./c; % exp divided by control data
            A.(msr) = p; % put result in array CM
        end
        T = A;

        % anova
        for msri = 1:numel(msrlist) 
            msr = msrlist{msri}; % get msr name
            % anova for difference between groups - area under the curve 
            [txt,anovastats,multstats,T2] = anova1_std_v2(T.(msr),T.groupname, 'plate');
            % put in central array
            SS.(msr).raw = T;
            SS.(msr).anovatext = txt;
            SS.(msr).anovastats = anovastats;
            SS.(msr).multstats = multstats;
            SS.(msr).descriptive = T2;
        end

        % export
        for msri = 1:numel(msrlist) 
            msr = msrlist{msri}; % get msr name
            % export anova text in text file
            str = SS.(msr).anovatext;
            p = fullfile(pSave, sprintf('%s %s.txt',msr,caltype)); % create file name
            fid = fopen(p,'w');
            fprintf(fid,'%s',str);
            fclose(fid);
            % export graph excel csv
            p = fullfile(pSave, sprintf('%s %s.csv',msr,caltype)); % create file name
            D = SS.(msr).descriptive;
            writetable(D, p);
        end
        
        % ttest against zero
        % open text file
        fid = fullfile(pSave, sprintf('%s ttest against 0.txt',caltype),'w'); % open file
        fprintf(fid,'*** ttest against 0 ***\n');
        for msri = 1:numel(msrlist) 
            msr = msrlist{msri}; % get msr name
            gu = unique(T.groupname);
            B = struct;
            for gi = 1:numel(gu)
                x = T.(msr)(ismember(T.groupname,gu{gi}));
                [text,p,ci,st] = ttest_auto(x,0);
                
                % put in struct
                B.(gu{gi}).text = text;
                B.(gu{gi}).p = p;
                B.(gu{gi}).ci = ci;
                B.(gu{gi}).stats = st;
                
                % export
                fprintf(fid,'%s, %s\n',gu{gi},text);
            end
            SS.(msr).ttest_against0 = B;
        end
        fclose(fid);

        
        % final put back in Cal
        MWTSet.(caltype) = SS;

        %-----------------------------------------------------------------20170721-

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%


        %% SAVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
        save(fullfile(pSave,'TWR.mat'),'MWTSet');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
    end
    
end




%% SUMMARIZE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
A = nan(numel(strainnames),1);
T = table;
T.wt_mean = A;
T.mut_mean = A;
T.wt_se = A;
T.mut_se = A;
S = struct;
for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    S.(msr) = T;
end
for si = 1:numel(strainnames)
    sn = strainnames{si};
    p = fullfile(pstrains{si},'TWR.mat');
    load(p);
    
    for msri = 1:numel(msrlist)
        msr = msrlist{msri};

        % get percent graph 
        destats = MWTSet.area_pctctrl.(msr).descriptive;
        m = sortN2first(destats.group, destats.mean);
        s = sortN2first(destats.group, destats.se);
        S.(msr).wt_mean(si) = m(1);
        S.(msr).mut_mean(si) = m(2);
        S.(msr).wt_se(si) = s(1);
        S.(msr).mut_se(si) = s(2);

        
    end
end


%% make table
p = '/Volumes/COBOLT/MWT/MWTDB.mat';
M = load(p,'strain');
s = M.strain;
i = cellfun(@isempty,s.genotype_shorthand);
s.genotype_shorthand(i) = s.strain(i);
TS = s;
T = table;
T.strainnames = strainnames;
T.strain = regexprep(strainnames,' New','');
T = outerjoin(T,TS,'Type','left','MergeKey',1,'RightVariables',{'strain','genotype','genotype_shorthand'});
Legend = T;


for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    D = S.(msr);
    T1 = [T D];
    S.(msr) = T1;
    writetable(T1,fullfile(pSaveM,sprintf('%s area pctctrl all strains.csv',msr)));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%

%% GRAPH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
G =S;

for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    D = G.(msr);
    % sort results
    D = sortrows(D,{'mut_mean','wt_mean','genotype'});
    gnames = D.strain;
    
    % plot errorbar
    y = [D.wt_mean D.mut_mean];
    e = [D.wt_se D.mut_se];
    % graph
    close all
    figID = figure;
    axes1 = axes('Parent',figID);
    graphID = errorbar(y,e);
    % set graph settings 
    graphID(1).Color = [0 0 0]; % wildtype as black
    graphID(2).Color = [1 0 0]; % mut as red
    graphID(1).LineStyle = 'none'; 
    graphID(2).LineStyle = 'none'; 
    graphID(1).Marker = '.'; 
    graphID(2).Marker = '.';  
    
    axes1.XTick = 1:size(y,1);
    axes1.XTickLabel(:) = gnames;
    axes1.YLim = [0 2.5];
    ylabel(msr);

    xticklabel_rotate
    
    line([0 numel(strainnames)], [1 1],'Color',[0.8 0.8 0.8]);
    
    printfig(msr,pSaveM,'w',15,'h',5)

end

for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    D = G.(msr);
    % sort results
    D = sortrows(D,{'mut_mean','wt_mean','genotype'});
    gnames = D.genotype_shorthand;

    % plot errorbar
    y = [D.wt_mean D.mut_mean];
    e = [D.wt_se D.mut_se];
    % graph
    close all
    figID = figure;
    axes1 = axes('Parent',figID);
    graphID = errorbar(y,e);
    % set graph settings 
    graphID(1).Color = [0 0 0]; % wildtype as black
    graphID(2).Color = [1 0 0]; % mut as red
    graphID(1).LineStyle = 'none'; 
    graphID(2).LineStyle = 'none'; 
    graphID(1).Marker = '.'; 
    graphID(2).Marker = '.';  
    
    axes1.XTick = 1:size(y,1);
    axes1.XTickLabel(:) = gnames;
    axes1.YLim = [0 2.5];
    ylabel(msr);

    xticklabel_rotate
    
    line([0 numel(strainnames)], [1 1],'Color',[0.8 0.8 0.8]);
    
    printfig(sprintf('%s gene',msr),pSaveM,'w',20,'h',5)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%




























