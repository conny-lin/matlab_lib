function TEMP
%% addpaths
addpath(genpath(pFun));
% standard paths (remove this and move to input)
[P] = definepath4diffcomputers3(pFun,'Conny Lin'); % [CODE] need to change
        addpath(P.Fun);
        addpath(P.FunG);
        addpath(P.FunD);

%% Prep: count experiment and MWT folders, and get variables
[pExpf,pMWTf,MWTfn] = getunzipMWT(Home); 
[MWTfsn,MWTsum] = getMWTruname(pMWTf,MWTfn); %% reload correct names
expnumber = numel(pExpf);
expnumberU = numel(unique(pExpf));
MWTfn = MWTsum(:,2);
MWTfnumer = numel(MWTfn);
MWTfnumerU = unique(numel(MWTfn));
display(sprintf('%d Experiment folders [%d unique]',expnumber,expnumberU));
display(sprintf('%d MWT folders [%d unique]',MWTfnumer,MWTfnumerU));
% get name parts and check uniques for errors
MWTruname = MWTsum(:,3);
[strain,seedcolony,colonygrowcond,runcond,trackergroup] = ...
        parseMWTfnbyunder(MWTruname); % parsename

%% Prototype: Run new data first

%% 1) Nicole's data

% look at data on/after a specified date
% [done] ShaneSparkAfterADate(p);
%% run script on exp after a date
Home = Ana;
[pExp,Expfn,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = getMWTpathsNname(Home,'show');
display 'enter the oldest year/date you want the analysis [20120304] or [2013]:';
datemin = input(': ');
searchterm = ['^' num2str(datemin)];
[~,expname] = cellfun(@fileparts,pExp,'UniformOutput',0);% get pExp name
disp(expname);
searchstart = min(find(not(cellfun(@isempty,regexp(expname,searchterm))))); % find minimum
pExptarget = pExp(searchstart:end); % get all MWT from search start
Expntarget = expname(searchstart:end);  

%% name groups
for x = 1:size(pExptarget,1);
    [Gps] = GroupNameMaster(pExptarget{x},pSet,'groupnameEnter');

end

%% [optional] assign group show sequence
for x = 1:size(pExptarget,1);
    [GAA] = GroupNameMaster(pExptarget{x},pSet,'GraphGroupSequence');
end

%% choreography 
for x = 1:size(pExptarget,1);
    pExp = pExptarget{x};
    [~,pMWTf] = dircontentmwt(pExp);
    for y = 1:numel(pMWTf)
        Shanesparkchoretapreversal2(pMWTf{y})
    end
end


%% Data Processing
for x = 1:size(pExptarget,1);
    % Data processing
    [MWTftrv,MWTftrvL] = ShaneSparkimporttrvNsave(pExptarget{x},pExptarget{x});
    % check MWTftrv input consistency
    %[MWTfgcode] = GroupNameMaster(pExptarget{x},pSet,'makeMWTfgcode');
    %[MWTftrvG] = GroupData(MWTftrv,MWTfgcode);
    %option = 'FreqRev';
    %ShankSparkGraph(pExptarget{x},pSet,MWTftrvG,MWTftrvL,option)
end
%%
% for x = 1:size(pExptarget,1);
%     
%     % need to validate the number of taps
%     [HabGraph1,X1,Y1,E1] = ShaneSparkstatcurvehab2(MWTftrvG,MWTftrvL,'FreqRev');
%     [HabGraph2,X2,Y2,E2] = ShaneSparkstatcurvehab2(MWTftrvG,MWTftrvL,'Dist/NRev');
%     [HabGraph3,X3,Y3,E3] = ShaneSparkstatcurvehab2(MWTftrvG,MWTftrvL,'Dist/TotalN');
% end

%% graphing
 option = 'FreqRev';
%for x=1:1%size(pExptarget,1);
pExp = pExptarget{x};
ShankSparkGraph(pExp,pSet,MWTftrvG,MWTftrvL,option)
%end
%%



% descriptive stats -------------------------------------------------------
% source code: [HabGraph3,X3,Y3,E3] = ShaneSparkstatcurvehab2(MWTftrvG,MWTftrvL,'Dist/TotalN');
HabGraph = MWTftrvG(:,1); % group name
timeind = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),'Time'))));
dataind = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),option))));

for g = 1:size(MWTftrvG,1); % for every group  
    A = {};
    HabGraph{g,2} = cell2mat((MWTftrvG{g,2}(:,timeind))'); % raw time 
    HabGraph{g,3} = (1:size(HabGraph{g,2},1))'; % scaled time
    A = cell2mat((MWTftrvG{g,2}(:,dataind))'); % get data option selected
    HabGraph{g,4}= mean(A,2); 
    HabGraph{g,5}= SE(A);
end
X = cell2mat(HabGraph(:,3)');
Y = cell2mat(HabGraph(:,4)'); 
E = cell2mat(HabGraph(:,5)');

% graphing ----------------------------------------------------------------
% prep graphing --------
% source [G] = figvprep5(HabGraph,2,3,pFun,pExp,setfilename,GL,Yn,Xn,GAA);
% load graph settings
cd(pSet);
G = load('GraphSetting.mat');

% input variables
fname = [option '.ShankSparkStats'];
G.Ylabel = option;
G.Xlabel = 'Tap';
G.XTickLabel = cellstr(num2str(X(:,1)))';

% group names and graphing sequence
[~,p] = dircontentext(pExp,'Groups_*');
cd(pExp);
load(p{1});
G.legend = Groups(:,2);
% see if group needs to be resorted
if exist('GAA','var') ==0;   
    G.legend = Groups(:,2); G.X=X; G.Y=Y; G.E=E;
else
    k = cell2mat((GAA(:,1))'); 
    G.legend = Groups(k,2); G.Y = Y(:,k); G.X = X(:,k); G.E = E(:,k);   
end


% create figure % source: makefig(G); -----------
figure1 = figure('Color',[1 1 1]); % Create figure with white background
x = 1;
axes1 = axes('Parent',figure1,'FontName',G.FontName);
hold(axes1,'all');
errorbar1 = errorbar(X,Y,E,'Marker','.','LineWidth',1);
for i = 1:size(G.Y,2);
    set(errorbar1(i),'DisplayName', G.legend{i,1},'Color',G.Color(i,:)); 
end
%ylim(axes1,[G.Ymin(x) G.Ymax(x)]);
%xlim(axes1,[G.Xmin(x) G.Xmax(x)]);
ylabel(G.Ylabel,'FontName',G.FontName);
xlabel(G.Xlabel,'FontName',G.FontName);

legend(axes1,'show');
set(legend,'Location','NorthEast','EdgeColor',[1 1 1],'YColor',[1 1 1],...
    'XColor',[1 1 1],'TickDir','in','LineWidth',1);

% annotation: N
N = size(G.Y,2);
s = 'N=%d';
text = sprintf(s,N);
annotation(figure1,'textbox',G.Gp(6,1:4),'String',{text},'FontSize',10,...
    'FontName',G.FontName,'FitBoxToText','on','EdgeColor','none');

% annotation: experiment name
% fix names
[~,expname] = fileparts(pExp);
expname = strrep(expname,'_','-');
for x = 1:size(G.legend);
    G.legend{x,1} = strrep(G.legend{x,1},'_','-');
end
annotation(figure1,'textbox',G.Gp(7,1:4),'String',{expname},...
    'FontSize',10,'FontName',G.FontName,'FitBoxToText','on',...
    'EdgeColor','none');

% soure code: savefig(Yn,pSave);
% save figures 
titlename = option;
cd(pExp);
h = (gcf);
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
print (h,'-dtiff', '-r0', titlename); % save as tiff
saveas(h,titlename,'fig'); % save as matlab figure 
close;

end



%% combine graph
a = hgload('FreqStd.fig');
b = hgload('DistStd.fig');
%
h1 = openfig('FreqStd.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure
h2 = openfig('DistStd.fig','reuse');
ax2 = gca;
% test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots

h3 = figure; %create new figure
s1 = subplot(2,1,1); %create and get handle to the subplot axes
s2 = subplot(2,1,2);
fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');

copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);


%%







%% 2) Ankie's data
% case 'LadyGaGa(reversal)'
        
LadyGaGa(pExp,pFun,'tested','combined','runchor','backup','userinput')


%% Condition Database 
% load most recent datanbase
pSet = P.Setting;
cd(pSet)
[setfile,~] = dircontentext(pSet,'MWTVariableDataBase*');
setfile = sortrows(setfile); % load newest
load(setfile{1});

% strain list
A = MWTVariableDataBase.Strains; % take out strain list from database
display(sprintf('%d unique values found.',numel(unique(strain))));
disp(unique(strain));
display 'Strain not in current strainlist:';
new = setdiff(unique(strain),A(:,1));
dis(new); % find new ones and add?

% modify list
gcode = input('Enter strain name to add genes: ','s');
i = find(not(cellfun(@isempty,regexp(A,gcode)))); % find location
A(i,2) = {input('Enter gene name or description: ','s')};
disp(A);

% save Strainlist
MWTVariableDataBase.Strains = A;
cd(pSet);
savename = ['MWTVariableDataBase_' datestr(now,'yyyymmddHHMM') '.mat'];
save(savename,'MWTVariableDataBase');

% seedcolony
A = {};% set up
display(sprintf('%d unique values found.',numel(unique(seedcolony))));
disp(unique(seedcolony));
% save
pSet = P.Setting;
MWTVariableDataBase.SeedColony = A;
cd(P.Setting);
savename = ['MWTVariableDataBase_' datestr(now,'yyyymmddHHMM') '.mat'];
save(savename,'MWTVariableDataBase');


% find unique values ****************************************************

[strain,seedcolony,colonygrowcond,runcond,trackergroup] = ...
        parseMWTfnbyunder(Output.MWTsum(:,3)); % parsename
display(sprintf('%d unique values found.',numel(unique(runcond))));
disp(unique(trackergroup));
A = unique(trackergroup);

b = char(unique(trackergroup));
c= unique(cellstr(char((b(:,1:5)))))
c= unique(cellstr(char((b(:,1:3)))))
month = cellstr(unique(b(:,2:4)));
disp(month)


%% Workflow
% 1) Backup 
[pExpf,pMWTf] = unzipMWT(Home); % unzip MWT folders
zipall(Home); % zip Raw
% move unzipped to a different folder
[~,~,~,pmwth] = dircontent(Home); 
[pmwth,~] = fileparts(Home);
newfname = 'Raw_Unzipped';
mkdir(Home,newname);
newlocation = [pmwth '/' newfname];
for x = 1:numel(pmwth)
    movefile(pmwth{x}, newlocation);
end
% 2) run chor
for x = 1:numel(pExpf);
    ShaneSparkChor(pExpf{x}); % chore
end


%% 2) Make sure group name and code are correct: Group folders 
[pExpV,Expfn,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = getMWTpathsNname(home,'show');
for x = 1:numel(pExpV);
    pExp = pExpV{x}; % get path to exp folder
    % get general info
    [pMWTf,MWTfn,MWTfsn,~,pMWTH] = getMWTrunamefromHomepath(pExp);
    [strain,~,colonygrowcond,runcond,trackergroup] = parseMWTfnbyunder(MWTfsn);
    % show experiment name 
    [~,n] = fileparts(pExp);
    display 'Experiment name:';
    disp(n);
    % load Groups data
    display 'Previous Group name file';
    [~,pmwth] = dircontentext(pExp,'Groups_*');
    load(pmwth{1});
    disp(Groups(:,1:2));
    % check tracker group
    gcode = char(trackergroup);
    gcode = gcode(:,end-1);
    [s] = cellfunexpr(MWTfn,'--');
    disp([char(MWTfn) char(s) gcode ])
    % ask if correct
    i = input('correct (y=1,n=0)? ');
    if i==1; % if so, reocord groups
        str = 'GroupNameV.mat';
        path = [pExp '/' str];
        Groups = Groups(1:2);
        save(path,'Groups');
    else
        disp(MWTfsn);
        f = input('Any way to fix this?');
        if f ==1;
            return
        else
            str = 'GroupNameProblem.mat'; 
            path = [pExp '/' str];
            Groups = Groups(1:2);
            save(path,'Groups');
            cd(pExp); % cd to current folder
        end
    end
end


%% PROBLEMS: --------------------------------
%% group code incorrect
disp(MWTfsn)
    
    
%% TOOLS ==================================================================
%% fixes
[Output] = Stage(pExp,pFun,'Conny');


%%
Groups{1,1:4} = {'a'; 'b'; 'c'; 'd'};
Groups{x,2} = '400mM'
%%
save('Groups_.mat',Groups')
%% modify list
A = tracker;
disp(A);
gcode = input('Enter target name: ','s');
i = find(not(cellfun(@isempty,regexp(A(:,1),gcode)))); % find location
A(i,2) = {input('Enter description: ','s')};
disp(A);
colonyprepmethod = A;
%% save colony condition
pSet = P.Setting;
MWTVariableDataBase.tracker = tracker;
cd(pSet);
savename = ['MWTVariableDataBase_' datestr(now,'yyyymmddHHMM') '.mat'];
save(savename,'MWTVariableDataBase');
dir(P.Setting); % show setting file list
%% ========================================================================


%% check if MWT file names group code are arranged correctly
[strain,~,colonygrowcond,runcond,trackergroup] = ...
        parseMWTfnbyunder(MWTfsn);
[pExpV,Expfn,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = ...
    getMWTpathsNname(Home,'noshow');
gcode= unique(Gpn);
gcfolderdelete = cellfun(@numel,regexp(Gpn,'[a-z]'))==1;
[fn,~,~,~] = cellfun(@dircontent,pGp(gcfolderdelete),'UniformOutput',0);
fn = celltakeout(fn)
% if is empty, delete
dir(pGp{1})


%% idea - compare run condition plus group to reassign
(not(cellfun(@isempty,regexp(pMWTH,expname{x}))))
%% find ones with group file
%function [Groups] = loadgroupfiles(pExp)
[gfile] = cellfunexpr(pExp,'Groups*.mat');
[groupfile,pgf] = cellfun(@dircontentext,pExp,gfile,'UniformOutput',0);
gfpositive = not(cellfun(@isempty,groupfile));
display(sprintf('%d experiments have [Group.mat] file',sum(gfpositive)));

% load group.mat file
i = find(gfpositive);
for x = 1:numel(i);
pG = pgf{i(x)}{1};
A = load(pG);
[home,Gname] = fileparts(pG);
[~,Expname] = fileparts(home);
Groups(x,1) = {Expname};
Groups(x,2) = {A.Groups};
end
cd(P.Setting)
save('GroupName.mat','Groups');

