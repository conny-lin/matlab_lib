function [Gps] = groupnameEnter(pExp,pSet)
%% construct selection interface
Home = pExp;
% go to each folder
[~,MWTfn,MWTfsn,~,~] = getMWTrunamefromHomepath(pExp);
MWTrunameCorr = MWTfsn;
[~,~,~,~,trackergroup] = parseMWTfnbyunder(MWTfsn);

% construct show names
% create components
[~,expname] = fileparts(pExp);
[r] = char(cellfunexpr(MWTfn,')'));
[b] = char(cellfunexpr(MWTfn,']'));
[rr] = char(cellfunexpr(MWTfn,'('));
a = char(trackergroup); % get groupcode out
MWTgc = a(:,6); % group
gcode = cellstr(unique(MWTgc)); 

% construct show name
showfilename = [num2str((1:numel(MWTfsn))') r char(MWTfsn)];
showfoldername = [num2str((1:numel(MWTfn))') r char(MWTfn)];
showmwtfgc = [char(MWTfn) rr a(:,6) r];

% reporting
display ' ';
display(sprintf('Experiment folder name: %s',expname));
display 'MWT folders:';
disp(showfoldername);
display 'MWT run names:';
disp(showfilename);
display 'Group code extracted from each MWT file:'
disp(showmwtfgc);
str = '*[%d] unique group codes: [%s]';
display(sprintf(str,numel(unique(MWTgc)),char(unique(MWTgc)')));
t = tabulate(MWTgc);
display 'MWTf counts for each group code:';
disp(t(:,1:2))

%% show old group file
pSave = [Home,'/MatlabAnalysis'];
[groupmatname,p] = dircontentext(pSave,'Groups_*.mat');
if numel(groupmatname)==1 && iscell(groupmatname)==1;
    cd(pSave); load(groupmatname{1},'Groups');
elseif numel(groupmatname)>1 && iscell(groupmatname)==1;
    cd(pSave); load(groupmatname{1});
else
    display 'No Groups_*.mat imported';
end
if (exist('Groups','var'))==1;
    [dash] = char(cellfunexpr(Groups,')'));
    groupmatshow = [char(Groups(:,1)) char(dash) char(Groups(:,2))];
    display 'Previous Group files found and says this:';
    disp(groupmatshow);
end

% assign group number
groupN = input('How many groups? ');
if groupN ~= numel(unique(MWTgc));
    display 'number of group entered does not match record';
    display 'run MWT run name correction first';
    error('Abort');
end

%% create gcode
% [suspend] do not auto assign % auto generate group code
% a1 = ['a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o'];
% a2 = ['p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'];
% alphabet = [a1 a2];
disp(char(gcode)');
q = input('Are above group codes correct (y=1,n=0)?');
if q==0;
    error('fix MWT run name first');
end

%% assign MWT file to groups and move files
gcodeM = cellstr(gcode);
display 'Group code extracted from each MWT file:'
disp(showmwtfgc);
display ' ';
groupmethod = input('Are run name contains correct groupcodes (y=1,n=0)? ');
if groupmethod==0; % if is not correct
    gcodeM = {};
    for x = 1:groupN
        display(sprintf('Enter index to MWT file that belongs to [%s]',gcode{x}));
        display 'separated each index by [space]';
        gcode(x,2) = {input(': ','s')};
        a = regexp(gcode(x,2), ' ','split');
        gcodeM(x,2) = a;
    end
end


%% assign group names
if (exist('groupmatshow','var'))==1;
    disp(groupmatshow);
end

groupcodeask = input('Are GroupName correct (y=1,n=0)? ');
if groupcodeask==1; % if is correct
    gcodeM(:,2) = Groups(:,2);
    gname = Groups(:,2);
    Groups = gcodeM;
    MWTfgcode = [MWTfsn(:,1),cellstr(MWTgc)];
    cd(pSave);
    groupmatname = {'Groups_1Set.mat'};
    save(groupmatname{1},'Groups','MWTfgcode');
else   
    gname = {};
    display 'Enter group name as follows...';
    display 'Example: N2 400mM Nofood';
    display 'If multiple variable, separate each var with a space';
    display 'Do not add space in one variable (i.e. [NoFood], not [No Food]';
    for x =1:numel(gcode)
        display(sprintf('Enter variables for [%s]', gcode{x}));
        a = '';
        a = input(': ','s');
        b = '';
        b = regexprep(a,' ','_');
        gname(x,1) = {b};
    end
    gcodeM(:,2) = gname(:,1);
    Groups = gcodeM;
    MWTfgcode = [MWTfsn(:,1),cellstr(MWTgc)];
    
        groupmatname = {'Groups_1Set.mat'};
    
    cd(pSave);
    save(groupmatname{1},'Groups');
end

% [don't do this anymore] create group folder with group code
% for x = 1:numel(gname)
%     groupfilename = [gcode{x},'_',gname{x}];
%     mkdir(Home,groupfilename);
% end


%% store group name in database
cd(pSet);
load('GroupNameDatabase.mat');
GroupNameDatabase = [GroupNameDatabase;gname];
save('GroupNameDatabase.mat','GroupNameDatabase');


%% output 
Gps = gcodeM;