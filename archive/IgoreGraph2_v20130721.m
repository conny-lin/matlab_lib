function IgoreGraph2(pExp,pFun,rawfilename)
%% set paths and load .mat set files
addpath(genpath(pFun)); 
[Expfdat,MWTfdat] = importmatfile(rawfilename,pExp);

%% validate import
% if Expfdat does not exist or no analysis had been done
if exist('Expfdat','var')==0;
    error('no Expfdat file');
%elseif size(Expfdat,2)==2;
 %   error('no grouped data in Expfdat');
elseif isempty(Expfdat{1,2})==1;
    error('no Expfdat imported');
elseif exist('MWTfdat','var')==0;
    error('no MWTfdat for grouping');
end

%% grouping Expfdat
[GA,GAA,MWTfgcode] = setgroup(MWTfdat,pFun,pExp,0); % set groups
[Expfdat] = groupexpmat(Expfdat,MWTfgcode); % group Expfdat

%% descriptive and graph
[Stats.curve] = statcurve(Expfdat); % Curve data
[Stats.curvestd] = statstdcurve(Expfdat); % Standardized Curve

%% Graphing
habgraphindividual(Stats.curve,Stats.curvestd,'Stim','GraphSetting.mat',...
    GAA(:,3),GAA,pFun,pExp,pExp);
%[Graph] = figvprep3(Stats.curve,'MWTfdata',GAA,Xn,Yn,...
            %pFun,pExp,'GraphSetting.mat');
%makefig2(Graph);
%savefig(titlename,pExp);
%cd(pExp);
%[savename] = creatematsavename(pExp,'statshab_','');
%save(savename);
end


%% [subfunctions] ---------------------------------------------------------


%% SF: grouping
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
function [A] = groupexpmat(D,MWTGind)
% [Expfdat] = groupexpimport(Expfdat,MWTGind);
%% organize import via groups: Expfdat
% process raw import to get plate mean via MWTGind
% D = Expfdat;
A = {};
for f = 1:(size(D,1)); % loop for all imports
    c1 = 3; % get rid of time and mean
    c2 = size(D{f,2},2)-1; % get rid of SD
    A{f,1} = D{f,2}(:,c1:c2); % get only plate mean
    A{f,2} = MWTGind; % copy group index into each file import
    for g = 1:size(A{f,2},1);% for each group
        p = A{f,2}{g,2}; % get plate number

        for px = 1:p; % for each plate
           i = A{f,2}{g,3}(1,px); % get column number
           A{f,2}{g,4}(:,px) = A{f,1}(:,i); % get data 
        end
        
    end
    A{f,2}(:,2)= []; % remove count
    A{f,2}(:,2)= []; % remove column index
end
A = cat(2,D(:,1),A);
end


%% Graphing
function [G] = habgraphindividual(DRaw,DStd,Xn,setfilename,GL,GAA,pFun,pExp,pSave)
%% Graphing: individual
% works with [Stats.curve] = statcurve(Expfdat); % Curve data
% and [Stats.curvestd] = statstdcurve(Expfdat);
% GL = group name legend
% GL = GAA(:,3);
%
% universal settings
% Xn = 'Stim';
% setfilename = 'GraphSetting.mat';

% non-standardized data
% graph Dist
fname = 'Tap_Dist.dat';
Yn = 'Dist';
%%
[G] = figvprep(DRaw,4,5,pFun,pExp,setfilename,GL,fname,Yn,Xn,GAA);
%%
makefig(G);
savefig(Yn,pSave);

% graph Freq
fname = 'Tap_Freq.dat';
Yn = 'Freq';
[G] = figvprep(DRaw,4,5,pFun,pExp,setfilename,GL,fname,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);

% standardized data
% graph DisStd
fname = 'Tap_Dist.dat';
Yn = 'DistStd';
[G] = figvprep(DStd,4,5,pFun,pExp,setfilename,GL,fname,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);

% graph FreqStd
fname = 'Tap_Freq.dat';
Yn = 'FreqStd';
[G] = figvprep(DStd,4,5,pFun,pExp,setfilename,GL,fname,Yn,Xn,GAA);
makefig(G);
savefig(Yn,pSave);
end
    function [G] = figvprep(D,mi,sei,pFun,pExp,setfilename,Gname,fname,Yn,Xn,GAA)
    %% Graphing: individual
%   setfilename = 'GraphSetting.mat';
%   fname = 'Tap_Dist.dat';
%   Yn = 'Dist';
%   Xn = 'Stim';
%   D = Stats.curve;
%   mi = 4; % c of mean
%   sei = 5; % c of se

% load graph settings
cd(pFun);
G = load(setfilename);
G.legend = Gname;
% load graph data source
G.Ylabel = Yn;
G.Xlabel = Xn;
[~,f] = ismember(fname,D(:,1)); % find row for fname
t1 = isequal(f,0); % test if fname exists
switch t1
    case 1; % doesn't exist
        error(sprintf('imported data is not %s...',fname));
    case 0
        G.Y = D{f,mi};
        G.E = D{f,sei};
end

%% see if group needs to be resorted
if exist('GAA','var') ==0;
    ...
else
    G.gs = cell2mat((GAA(:,1))');
    YA = G.Y;
    EA = G.E;
    for x = 1:size(G.gs,2);
        YA(:,x) = G.Y(:,G.gs(1,x));
        EA(:,x) = G.E(:,G.gs(1,x));
    end
    G.Y = YA;
    G.E = EA;
end
%% fix names
[~,G.expname] = fileparts(pExp);
G.expname = strrep(G.expname,'_','-');
for x = 1:size(G.legend);
    G.legend{x,1} = strrep(G.legend{x,1},'_','-');
end

    end
    function makefig(G)
%% create figure 
figure1 = figure('Color',[1 1 1]); % Create figure with white background

x = 1;
axes1 = axes('Parent',figure1,...
    'XTickLabel','',...
    'FontName',G.FontName);
%
hold(axes1,'all');
errorbar1 = errorbar(G.Y,G.E,...
    'Marker','.',...
    'LineWidth',1);
for i = 1:size(G.Y,2);
    set(errorbar1(i),...
        'DisplayName', G.legend{i,1},...
        'Color',G.Color(i,:)); 
end
ylim(axes1,[G.Ymin(x) G.Ymax(x)]);
xlim(axes1,[G.Xmin(x) G.Xmax(x)]);
ylabel(G.Ylabel,'FontName',G.FontName);
xlabel(G.Xlabel,'FontName',G.FontName);


legend(axes1,'show');
set(legend,...
    'Location','NorthEast',...
    'EdgeColor',[1 1 1],...
    'YColor',[1 1 1],...
    'XColor',[1 1 1],...
    'TickDir','in',...
    'LineWidth',1);


%% annotation: N
N = size(G.Y,2);
s = 'N=%d';
text = sprintf(s,N);
annotation(figure1,...
    'textbox',G.Gp(6,1:4),...
    'String',{text},...
    'FontSize',10,...
    'FontName',G.FontName,...
    'FitBoxToText','on',...
    'EdgeColor','none');

%% annotation: experiment name
annotation(figure1,...
    'textbox',G.Gp(7,1:4),...
    'String',{G.expname},...
    'FontSize',10,...
    'FontName',G.FontName,...
    'FitBoxToText','on',...
    'EdgeColor','none');
end






%% Shared functions
function [a] = SE(A)
    a = std(A,1,2)/sqrt(size(A,2));
end
function [Expfdat,MWTfdat] = importmatfile(rawfilename,pExp)
cd(pExp);
a = dir(rawfilename);
a = {a.name};
load(char(a));
end
function [D] = statcurve(D)
% D = Expfdat;
for f = 1:size(D,1); % for every import
    for g = 1:size(D{f,3},1); % for every group  
        A = {};
        A = D{f,3}{g,2}; % get data
        D{f,3}{g,3}= mean(A,2);
        D{f,3}{g,4}= SE(A);
    end
    D{f,4} = cell2mat(D{f,3}(:,3)'); % combine get group mean 
    D{f,5} = cell2mat(D{f,3}(:,4)'); % combine get group se 
end
end
function [D] = statstdcurve(D)
%% Standardized Curve
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
end
end

