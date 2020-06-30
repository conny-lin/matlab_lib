function IgoreRaw2_v20130722(pExp,pFun)
[Expfdat] = importungroupedExpraw('*.dat',pExp);
[MWTf,pMWTf,T] = getungroupedMWTfolders(pExp);
[MWTftrv,MWTfdat] = importMWTdattrv(MWTf,pMWTf,T); % Import ungrouped data
[MWTftrv,MWTfdat,MWTfgcode,GAA,MWTfdatG,MWTftrvG] = groupMWTimport(pExp,pFun,MWTfdat,MWTftrv);        
[savename] = creatematsavename(pExp,'import_','.mat'); % create save name
cd(pExp);
save(savename);
[Time,Graph,Stats] = igoreGraphing2(pFun,pExp,'time',...
    'import*.mat'); 

end


%% Subfunctions
%% import
function [Expfdat] = importungroupedExpraw(ext,pExp)
%% Import sum.dat, MWTf .dat and .trv from ungrouped data
[Expfdat] = importsumdata2(pExp,ext,5,1); % import Exp summary data
if isempty(Expfdat)==1; % status reporting
    display('no summary data...');
else
    display('summary data imported...');
end
end
function [MWTf,pMWTf,T] = getungroupedMWTfolders(pExp)% import MWT files
[~,~,MWTf,pMWTf] = dircontent(pExp); % get path to MWTf
[T] = validateMWTfn(MWTf,pMWTf); % check if all folders are MWTf
end
    function [T] = validateMWTfn(MWTf,pMWTf)
        %% make sure the dir is a MWT folder (20130407_153802)
        T = [];
        for x = 1:size(MWTf,1);
            % set conditions
            c1 = isequal(isdir(pMWTf{x,1}),1); % c1=1 if it is a dir
            c2 = isequal(size(MWTf{x,1},2),15); % c2=1 if name is 15 characters
            c3 = isequal(strfind(MWTf{x,1},'_'),9); % c3=1 if _ at position9
            c4 = isnumeric(str2num(MWTf{x,1}(1:8))); % first 8 digit numeric
            c5 = isnumeric(str2num(MWTf{x,1}(10:15))); % last 6 digit numeric
            if (c1+c2+c3+c4+c5) ==5; % if satisfies all 5 conditions
                T(x,1) = 1; % record pass
            else
                T(x,2) = 0; % record fail
            end
        end
    end 
function [MWTftrv,MWTfdat] = importMWTdattrv(MWTf,pMWTf,T)
if isequal(sum(T),size(MWTf,1))==1; % if all folders validated as MWT folder
    [MWTftrv] = importmwtdata3('*.trv',MWTf,5,0,pMWTf);
    [MWTfdat] = importmwtdata3('*.dat',MWTf,0,0,pMWTf);
else
    error('[BUG] some folders are not MWT folders...');
end
end
    function [MWTfdata] = importmwtdata3(ext,MWTf,r,c,pMWTf)
%[MWTfdata] = importmwtdata2(ext,MWTf,r,c,pExp)
% MWTf = list of MWTfile name, ext = '*.trv'; r = 5; c = 1;
A = MWTf;
for x = 1:size(pMWTf,1); % for each MWTf
    p = pMWTf{x,1}; % get path
    cd(p); % go to path
    a = dir(ext); % list content
    a = {a.name}'; % get just the name of the file
    if (isempty(a) == 0)&&(size(a,1)==1); % if only one file with ext
        A(x,2) = a; % name of file imported
        A{x,3} = dlmread(a{1},' ',r,c); % import .trv file
    elseif (isempty(a) == 0)&&(size(a,1)>1); % if more than one file with ext
        for xs = 1:size(a,1);
            A{x,2}(xs,1) = a; % name of file imported
            A{x,3}{xs,1} = dlmread(a{1},' ',r,c); % import .trv file
        end   
    else % in other situations
        warning('Nothing imported for %s',ext);
    end
end
MWTfdata = A;
    end
function [MWTftrv,MWTfdat,MWTfgcode,GAA,MWTfdatG,MWTftrvG] = groupMWTimport(pExp,pFun,MWTfdat,MWTftrv)
[~,GAA,MWTfgcode] = setgroup(MWTfdat,pFun,pExp,0); % assign group name
% [BUG] confirm entry of groups
[MWTfdatG] = groupMWTfdata(MWTfdat,MWTfgcode); % group data
[MWTftrvG] = groupMWTfdata(MWTftrv,MWTfgcode); % group data
end
    %% grouping
    function [GA,GAA,MWTfgcode] = setgroup(MWTfdat,pFun,pExp,id)
    %id = select group name method id
    [RCpart] = parseRCname1(MWTfdat);
    [MWTfgcode,gcode] = MWTfgroupindex(RCpart);
    [GA] = groupnameswitchboard(gcode,RCpart,pFun,pExp,0); % assign group name using group files 
    [GAA] = groupseq(GA); % sort group name for graphing
    end    
        function [RCpart] = parseRCname1(MWTfdat)
                % use imported .dat or .trv file names to parse out runcondition names
                % the first column is a list of MWT folder names, the second column is a
                % list of imported file names
                A = {};
                for x = 1:size(MWTfdat,1);
                    n = MWTfdat{x,2}; % name of the MWT file
                    dot = strfind(n,'.'); % find position of dot
                    under = strfind(n,'_'); % find underline
                    A{x,1} = MWTfdat{x,1}; % MWT folder name
                    A{x,2} = n(1:dot-1); % RC name 
                    A{x,3} = n(1:under(1)-1); % strain
                    A{x,4} = n(dot-2:dot-2); % group code
                    A{x,5} = n(dot-2:dot-1);% plate code  
                    A{x,6} = n(under(4)+1); % tracker
                end
                RCpart = A;
        end
        function [MWTfgcode,gcode] = MWTfgroupindex(RCpart)
                % prepare Group output, work with RCpart produced by function...
                % [RCpart] = parseRCname1(MWTfdatname)
                % MWTfg = 1- group, 2- groupincidences, 3-index to MWTf rows
                % MWTfgroup = 1-MWT folder name, 2-group code, 3-strain name
                % Gcode = unique group codes
                % Gind = row index to MWTf with group code
                MWTfgroup = cat(2,RCpart(:,1),RCpart(:,4),RCpart(:,3)); % extract summary
                gcode = unique(RCpart(:,4)); % extract unique group code
                T = tabulate(RCpart(:,4)); % find incidences of each group @ T(:,2)
                for x = 1:size(T,1); % for each group
                MWTfgcode(x,1:2) = T(x,1:2); % put group code and incidences of each group in record
                MWTfgcode{x,3} = (strmatch(T{x,1},RCpart(:,4)))'; % find MWTf index for current group code
                end
        end
        function [GA] = groupnameswitchboard(gcode,RCpart,pFun,pExp,id)
        % assign group names
        % id: 0- select method, 1- select pre-defined variable, 
        % 2-manually assign, 3-use premade Groups*.mat file
        %MWTGname = MWTfdat; 
        if id==0;
            disp(' ');
            method = char('[1] Select pre-defined variable',...
            '[2] Manually assign','[3] Use Groups*.mat file');
            disp(method);
            q1 = input('Enter method to name your group: ');
        else
            q1 =id;
        end
        
        switch q1;
            case 1 % select assign (by continueing)
                %% [BUG SUSPENSION]
                display('method [1] is currently suspended for bugs');
                %%[GA] = groupnameselectfromvarlist2(RCpart,pFun,pExp,gcode);
            case 2 % manually assign
                GA = gcode;
                disp(gcode);
                disp('type in the name of each group as prompted...');
                q1 = 'name of group %s: ';
                i = {};
                for x = 1:size(gcode,1);
                     GA(x,2) = {input(sprintf(q1,gcode{x,1}),'s')};
                end
            case 3 % use group files
                cd(pExp);
                fn = dir('Groups*.mat'); % get filename for Group identifier
                fn = fn.name; % get group file name
                load(fn); % load group files
                GA = Groups;
            otherwise
                error('please enter 0 or 1');
        end
        end           
            function [GA] = groupnameselectfromvarlist2(RCpart,pFun,pExp,gcode)
            %% creating Exp condition variable
            cd(pFun)
            load('variables.mat');

            % identify groups to be assigned names
            s_gcode = {}; 
            for x = 1:size(RCpart,1);
                s_gcode{x,1} = strcat(RCpart{x,3},'_',RCpart{x,4}); % create group name (strain_condition)
            end
            s_gcode_unique = unique(s_gcode(:,1)); % get unique strain_groups

            % prepare exp run condition name
            [expname] = creatematsavename(pExp,'Groups detected from experiment:','');
            disp(' ');
            disp(expname);
            disp(s_gcode_unique);

            % Prep IV categories: see if strain is the only variable
            vn = [];
            if size(gcode,1) - size(unique(RCpart(:,3)),1) ==0; % if gcode is the same number as unique strain
                ...
            else
               disp(variable); % display IV category list
               vi= str2num(input('\nEnter relevant IV category(s)...\nif more than one IV, separate answers by space\n,if not on the list, enter(0):','s')); % choose variables
            end
            %% [BUG SUSPENSION] vi cycling problem
            % assign group codes
            for x = 1:size(vi,2);% cycle through IV category
                display('IV index:');
                disp(Cond{vi(x,1),5}{1}) % display remaining groups
                display(' ');
                q1 = 'Enter IV index for group "%s": ';
                q2 = 'Please Re-enter correct IV index for group "%s". If your group is not shown above, enter 0: ';
                for x1 = 1:size(s_gcode_unique,1); % cycle through all groups for variable level 2
                    i = [];
                    i = input(sprintf(q1,s_gcode_unique{x1,1}));
                    while isempty(i) ==1;
                        i = input(sprintf(q2,s_gcode_unique{x1,1})); 
                    end

                    while i > size(Cond{vi(x),3},1);
                        i = input(sprintf(q2,s_gcode_unique{x1,1})); 
                    end

                    while i ==0; % if no group name pre assigned
                        s_gcode_unique(x1,x+1) = {'unkonwn'}; 
                    end

                    if isequal(i,Cond{vi(x),4}) ==0; % if the selected group is not a ctrl group
                        s_gcode_unique(x1,x+1) = {Cond{vi(x),3}{i,2}}; % code group name
                    end
                end
            end
            % construct new name
            e = size(s_gcode_unique,2)+1; % find last cell
            for x = 1:size(s_gcode_unique,1); % cycle through rows in strain_group
                i = strfind(s_gcode_unique{x,1},'_'); % find index to _a
                sname = s_gcode_unique{x,1}(1:i-1); % get strain name
                for y = 2:e-1; % cycle through columns in groups
                    if isempty(s_gcode_unique{x,2}) ==0; % if there is a group assigned?
                        sname = strcat(sname,'_',s_gcode_unique{x,2}); % construct name
                    else 
                        sname = sname;
                    end
                end
                s_gcode_unique{x,e} = sname;
            end
            % create GA
            for x = 1:size(s_gcode_unique,1);
                GA{x,1} = s_gcode_unique{x,1}(end);
                GA(x,2) = s_gcode_unique(x,3);
            end
            end
        function [GAA] = groupseq(GA)
        %% assign sequence of groups for graphing
        GAs = GA;
        GAA = {};
        i = num2cell((1:size(GA,1))');
        GAs = cat(2,i,GA);
        GAA = GAs;
        disp(GAs);
        q2 = input('is this the sequence to be appeared on graphs (y=1 n=0): ');
        while q2 ==0;
            s = str2num(input('Enter the index sequence to appear on graphs separated by space...\n','s'));
            for x = 1:size(GAs,1);
                GAA(x,:) = GAs(s(x),:);
            end
            disp('')
            disp(GAA)
            q2 = input('is this correct(y=1 n=0): ');
        end

        end
    function [A] = groupMWTfdata(MWTfdat,MWTfGi)
    % [Expfdat] = groupexpimport(Expfdat,MWTGind);
    %% organize import via groups: Expfdat
    % process raw import to get plate mean via MWTGind
    % D = Expfdat;
    A = MWTfGi(:,1);
    groupsize = size(MWTfGi,1);
    for xg = 1:groupsize; % for each group
        groupindex = MWTfGi{xg,3}; % get MWTf index
        for xx = 1:size(groupindex,2);
            i = groupindex(1,xx); % get index to MWTf
            A{xg,2}{xx,1} = MWTfdat{i,1}; % get raw data MWTf name 
            A{xg,2}(xx,2) = MWTfdat(i,3);% get MWTfdat raw data
        end
    end
    end


%% [SF] graphing
function [Time,Graph,Stats] = igoreGraphing2(pFun,pExp,Yn,rawfilename)
%% set paths and load .mat set files
addpath(genpath(pFun)); 
cd(pFun);
cd(pExp);
a = dir(rawfilename);
a = {a.name};
load(char(a));
%% analysis
[titlename,~,m,intmin,int,intmax,Xn] = selectmeasure2(pFun,'analysisetting.mat',0);
%% [BUG] tell intmax to user
[Data,Time,Xaxis] = getmeanresponse(MWTfdatG,intmin,int,intmax,m);
%% [OBJECTIVES]
%% descriptive and graph
[Stats.curve] = statcurve2(Data,2); 
[Stats.curvestd] = statstdcurve2(Data,2); 
[Graph] = figvprep3(Stats.curve,'MWTfdata',GAA,Xn,Yn,...
            pFun,pExp,'GraphSetting.mat');
makefig2(Graph);
savefig(titlename,pExp);
cd(pExp);
%% combineed speed graphs of 6 groups 
% day4 - 0mM, 400mM
% day5 - 0mM, 400mM, 0mM(repeated), 400mM(repeated)

%% [code later] create analysis dat reference
%% individual and combined graphs of any parameters
% [code later] create analysis dat reference
%% flexibility in selecting X axis
%% bar graphs to compare selected time points

end
function [titlename,set,m,intmin,int,intmax,Yn] = selectmeasure2(pFun,setfn,id)
%% userinput interface
cd(pFun);
load(setfn);
load('javasetting.mat'); % load matlab settings
while id ==0;
    id = input('set analysis use preset(1), quick entry (2), user prompt(3):\n');
end

switch id
    case 1 % preset
        display(setid);
        x = input('select analysis: ');
        set = preset(x,:);
        m = set(1);
        Yn = MWTfdatGraphcode{m,2};
        intmin = set(2);
        int = set(3);
        intmax = set(4);
        
    case 2 % quick entry
        disp(MWTfdatGraphcode(:,1:2));
        set = input('enter [m intmin int intmax] separated by space:\n ','s');
        set = str2num(set);
        m = set(1);
        intmin = set(2);
        int = set(3);
        intmax = set(4);
        Yn = MWTfdatGraphcode{m,2};
    case 3 % user prompt
        disp(MWTfdatGraphcode(:,1:2));
        mi = input('select measure code: ');
        m = MWTfdatGraphcode{mi,3};
        Yn = MWTfdatGraphcode{m,2};
        set(1) = m;
        intmin = input('starting time: ');
        set(2) = intmin;
        int = input('interval: ');
        set(3) = int;
        intmax = input('end time: ');
        set(4) = intmax;
        
        %% [future coding] - ask to store setting
        
end
% make graph title name
titlename = regexprep(mat2str(set),' ','x');
titlename = strcat(Yn,'_',titlename);
end
    function [Data,Time,Xaxis] = getmeanresponse(A,intmin,int,intmax,m)
    %% get speed is at column 6
    %m = 6; % select speed (at column 6)
    % set up time intervals
    %intmin = 0; % starting time
    %int = 10; % at 10 second intervals
    %intmax = 410; % until max time

    Time = A(:,1:2); % get group name
    Xaxis = (intmin:int:intmax)';
    for g = 1:size(A,1); % loop groups
        for p = 1:size(A{g,2},1); % loop plates  
            % import time
            ri = [];
            T = A{g,2}{p,2}(:,1); % get time data
            for xt = intmin:int:intmax; % loop for time intervals
                %% [BUG] if intmax exceeds max time...
                [frame,~]= find(T>xt); % find a time
                tf = frame(1); % row to the beginning of next interval
                ri(end+1,1) = tf; % record row index
                ri(end,2) = xt; % record interval number
            end
            Time{g,2}{p,2} = ri;

            % get mean of measure per interval
            D = A{g,2}{p,2}(:,m); % get speed data
            for x = 2:size(ri,1)-1; % for each time interval
                A{g,3}(x,p) = mean(D(ri(x):ri(x+1)-1)); % mean of all data during this time
            end

        end

    end
    Data = A;
    end
    function [A] = statcurve2(D,id)
% id - Expdata=1, MWTdata=2
switch id
    case 1 % D = Expfdat   
        for f = 1:size(D,1); % for every import
            for g = 1:size(D{f,3},1); % for every group  
                A = {};
                A{f,3}{g,1} = D{f,3}{g,1}; 
                A{f,3}{g,2} = D{f,3}{g,2}; % get data
                A{f,3}{g,3} = mean(D{f,3}{g,2},2);
                A{f,3}{g,4} = SE(D{f,3}{g,2});
            end
            A{f,4} = cell2mat(D{f,3}(:,3)'); % combine get group mean 
            A{f,5} = cell2mat(D{f,3}(:,4)'); % combine get group se 
        end
        
        
    case 2 % MWTfdat/MWTftrv
        for g = 1:size(D,1); % for every group  
            A(g,1) = D(g,1); % get group code
            A(g,2) = D(g,3); % get plate data
            A{g,3}= mean(D{g,3},2); % plate mean
            A{g,4}= SE(D{g,3}); % plate SE
        end
end
    end
    function [B] = statstdcurve2(D,id)
% id - Expdata=1, MWTdata=2
%% Standardized Curve
switch id
    case 1 % D = Expfdat 
        for f = 1:size(D,1); % for every import
            for g = 1:size(D{f,3},1); % for every group  
                A = {};
                A = D{f,3}{g,2}; % get data
                I = repmat(A(1,:),size(A,1),1); % get initial array
                A = A./I; % standardize to initial
                D{f,3}{g,3}= mean(A,2); % calculate mean
                D{f,3}{g,4}= SE(A); % calculate SE
            end
            D{f,4} = cell2mat(D{f,3}(:,3)'); % combine get group mean 
            D{f,5} = cell2mat(D{f,3}(:,4)'); % combine get group se 
            B = D;
        end
    case 2 % MWTfdat/MWTftrv
        %%
        for g = 1:size(D,1); % for every group  
            A = D{g,3};
            %% [BUG] initial zero... what to do then?
            I = repmat(A(1,:),size(A,1),1); % get initial array
            A = A./I; % standardize to initial
            D{g,3}= mean(A,2); % calculate mean
            D{g,4}= SE(A); % calculate SE
        end
        B = D;
        
    otherwise
        error('invalid analysis id for statstdcurve2');
        
end
    end
    function [Graph] = figvprep3(D,fn,GAA,Yn,Xn,pFun,pExp,setfilename)
%% Graphing: individual
% [Graph] = figvprep3(D,fn,GAA,Yn,Xn,pFun,pExp,setfilename)% D-stats data (produced by stats* function 
%   with graph means at D{f,3} and SE at D{f,4}
% pFun - path to funciton
% pExp - path to experiment
% setfilename - name of the graph settings
% Groups - .mat files containing group name and index
% fn -name of the imported file (i.e. *.dat), 
%   type in 'MWTfdata' for MWTfdat and MWTftrv analysis
% Yn - Y axis name
% Xn - X axis name
% GAA - group sorting files
% Example:
%setfilename = 'GraphSetting.mat';

%% load graph settings
cd(pFun);
Graph = load(setfilename);
Graph.legend = GAA(:,3);
Graph.Ylabel = Yn;
Graph.Xlabel = Xn;

%% load graph data source
% if filename is a variable, or imported Expfdata
if (isequal(fn,'MWTfdata')==1)||ismember(fn,D(:,1))==1; 
    Graph.Y = cell2mat(D(:,3)');
    Graph.E = cell2mat(D(:,4)');
else
    error('imported data %s does not exist...',fn);
    
end

%% see if group needs to be resorted
Graph.gs = cell2mat((GAA(:,1))');
YA = Graph.Y;
EA = Graph.E;
for x = 1:size(Graph.gs,2);
    YA(:,x) = Graph.Y(:,Graph.gs(1,x));
    EA(:,x) = Graph.E(:,Graph.gs(1,x));
end
Graph.Y = YA;
Graph.E = EA;

%% fix names
[~,Graph.expname] = fileparts(pExp);
Graph.expname = strrep(Graph.expname,'_','-');
for x = 1:size(Graph.legend);
    Graph.legend{x,1} = strrep(Graph.legend{x,1},'_','-');
end

    end
    function makefig2(Graph)
%% create figure 
figure1 = figure('Color',[1 1 1]); % Create figure with white background

x = 1;
axes1 = axes('Parent',figure1,...
    'XTickLabel','',...
    'FontName',Graph.FontName);
%
hold(axes1,'all');
errorbar1 = errorbar(Graph.Y,Graph.E,...
    'Marker','.',...
    'LineWidth',1);
for i = 1:size(Graph.Y,2);
    set(errorbar1(i),...
        'DisplayName', Graph.legend{i,1},...
        'Color',Graph.Color(i,:)); 
end
%ylim(axes1,[G.Ymin(x) G.Ymax(x)]);
%xlim(axes1,[G.Xmin(x) G.Xmax(x)]);
ylabel(Graph.Ylabel,'FontName',Graph.FontName);
xlabel(Graph.Xlabel,'FontName',Graph.FontName);


legend(axes1,'show');
set(legend,...
    'Location','NorthEast',...
    'EdgeColor',[1 1 1],...
    'YColor',[1 1 1],...
    'XColor',[1 1 1],...
    'TickDir','in',...
    'LineWidth',1);


%% annotation: N
N = size(Graph.Y,2);
s = 'N=%d';
text = sprintf(s,N);
annotation(figure1,...
    'textbox',Graph.Gp(6,1:4),...
    'String',{text},...
    'FontSize',10,...
    'FontName',Graph.FontName,...
    'FitBoxToText','on',...
    'EdgeColor','none');

%% annotation: experiment name
annotation(figure1,...
    'textbox',Graph.Gp(7,1:4),...
    'String',{Graph.expname},...
    'FontSize',10,...
    'FontName',Graph.FontName,...
    'FitBoxToText','on',...
    'EdgeColor','none');
    end
    function savefig(titlename,pSave)
% save figures 
% titlename = 'CombinedGraph';
cd(pSave);
h = (gcf);
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
print (h,'-dtiff', '-r0', titlename); % save as tiff
saveas(h,titlename,'fig'); % save as matlab figure 
close;
end

%% Shared functions
function [savename] = creatematsavename(pExp,prefix,suffix)
    % add experiment code after a prefix i.e. 'import_';
    [~,expn] = fileparts(pExp);
    i = strfind(expn,'_');
    if size(i,2)>2;
        expn = expn(1:i(3)-1);
    else
        ...
    end
    savename = strcat(prefix,expn,suffix);
    end
function [a] = SE(A)
    a = std(A,1,2)/sqrt(size(A,2));
end
function [a,b,c,d] = dircontent(p)
        %% get directory content
        % a = full dir, can be folder or files, b = path to all files, 
        % c = only folders, d = paths to only folders
        cd(p); % go to directory
        a = {}; % create cell array for output
        a = dir; % list content
        a = {a.name}'; % extract folder names only
        a(ismember(a,{'.','..','.DS_Store'})) = []; 
        b = {};
        c = {};
        d = {};
        for x = 1:size(a,1); % for all files 
            b(x,1) = {strcat(p,'/',a{x,1})}; % make path for files
            if isdir(b{x,1}) ==1; % if a path is a folder
                c(end+1,1) = a(x,1); % record name in cell array b
                d(end+1,1) = b(x,1); % create paths for folders
            else
            end
        end
end
function [Expfdat] = importsumdata2(p,ext,r,c)
%% Import summary data from folder p
% [NEED USING IT] import .dat file 
% i.e. ext = '*.dat';
cd(p); % go to path
a = dir(ext); % list content
a = {a.name}'; % get just the name of the file
d = {};
for x = 1:size(a,1);
    d(x,1) = a(x,1); % name of file imported
    d{x,2} = dlmread(a{1},' ', r,c); % import 
end
Expfdat = d;
end


