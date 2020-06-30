function [Gps] = groupnameonebyone(pExp,pSet)
%% construct selection interface
% go to each folder
[pMWTf,MWTfn,MWTfsn,MWTsum,pExpf] = getMWTrunamefromHomepath(pExp);
MWTrunameCorr = MWTfsn;
[strain,~,colonygrowcond,runcond,trackergroup] = ...
        parseMWTfnbyunder(MWTfsn);

% construct show names
% create components
[p,expname] = fileparts(pExp);
[r] = char(cellfunexpr(MWTfn,')'));
[b] = char(cellfunexpr(MWTfn,']'));
[rr] = char(cellfunexpr(MWTfn,'('));
a = char(trackergroup); % get groupcode out
MWTgc = a(:,6); % group

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


%% show old group file
[n,p] = dircontentext(pExp,'Groups_*.mat');
load(n{1})
if (isvarname('Groups'))==1;
    [dash] = char(cellfunexpr(Groups,')'));
    show = [char(Groups(:,1)) char(dash) char(Groups(:,2))];
    display 'Previous Group files found and says this:';
    disp(show);
end

% assign group number
groupN = input('How many groups? ');
% auto generate group code
a1 = ['a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o'];
a2 = ['p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'];
alphabet = [a1 a2];
gcode = cellstr(alphabet(1:groupN)');
display('The following group codes should be seen in run name')
disp(gcode');


%% assign group names
gname = {};
display 'Enter group name as follows...';
display 'Example: N2 400mM Nofood';
display 'If multiple variable, separate each var with a space';
display 'Do not add space in one variable (i.e. [NoFood], not [No Food]';
for x =1:groupN
disp(gcode');
display(sprintf('Enter variables for [%s]', gcode{x}));
a = '';
a = input(': ','s');
b = '';
b = regexprep(a,' ','_');
gname(x,1) = {b};
end

% create group folder
for x = 1:numel(gname)
    mkdir(pExp,gname{x});
end

%% store group name in database
cd(pSet);
load('GroupNameDatabase.mat');
GroupNameDatabase = [GroupNameDatabase;gname];
save('GroupNameDatabase.mat','GroupNameDatabase');

%% assign MWT file to groups and move files
gcodeM = gcode;
display 'Group code extracted from each MWT file:'
disp(showmwtfgc);
display ' ';
groupmethod = input('Are group codes in run name correct (y=1,n=0)? ');
if groupmethod~=1; % if in correct
    gcodeM = {};
    for x = 1:groupN
        display(sprintf('Enter index to MWT file that belongs to [%s]',gcode{x}));
        display 'separated each index by [space]';
        gcode(x,2) = {input(': ','s')};
        a = regexp(gcode(x,2), ' ','split');
        gcodeM(x,2) = a;
    end
    % move experiment under group folder
    for x = 1:size(gcodeM,1)
        i = str2num(cell2mat(gcodeM{x,2}'));
        for y = 1:numel(i);
            movefile([pExp '/' MWTfn{i(y)}],[pExp '/' gname{x}]);
        end
    end 
else
    % group automatically
    for x = 1:size(gname,1)
    i = find(not(cellfun(@isempty,regexp(cellstr(MWTgc),gcode(x,1)))));
    for y = 1:numel(i)
    movefile([pExp '/' MWTfn{i(y)}],[pExp '/' gname{x}]);
    end
    end
end


%% output 
Gps.gcodeM = gcodeM;
Gps.MWTgc = MWTgc;