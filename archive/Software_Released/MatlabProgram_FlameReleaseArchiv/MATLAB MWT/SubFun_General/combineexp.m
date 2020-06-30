%% combineexp
%% combine same experiment from different trackers
%% add paths
addpath(genpath(pFun));
%% drag in experiment folders to be combined
pExp1 = '/Volumes/My Passport/MultiWormTrackerPortal/MWT_Experimenter_Folders/Ankie_Hung/20130731A_AH_00sx1x200s1x1100s00s_NE_2taps';
pExp2 = '/Volumes/My Passport/MultiWormTrackerPortal/MWT_Experimenter_Folders/Ankie_Hung/20130731C_AH_00sx1x200s1x1100s00s_NE_2taps';
pExp = [pExp1;pExp2]

%% check if within the same experiment folder the tracker names are correct
for y = 1:numel(pExp);
[MWTfsn,MWTfail] = draftMWTfname3('*set',pExp(y,:)); % get name of MWT run condition
tdpg = regexp(MWTfsn(:,2),'[A-Z]\d\d\d\d[a-z][a-z]','match');
A = {};
for x = 1:numel(tdpg);
    A(x,:) = tdpg{x}(1);
end
tracker = regexp(A,'[A-Z]','match');
A = {};
for x = 1:numel(tdpg);
    A(x,:) = tracker{x}(1);
end
tracker = unique(A);
if numel(tracker) ==1;
    display(sprintf('The %d experiment contains all tracker [%s] data',y,tracker));
else
    error('MWT files contains more than one tracker...');
end
% record it
end


%% combine expeirment
[expname] = findstadexpfoldername(pExp(1,:),pFun); % replace tracker code as X in experiment folder
expname = regexprep(expname,'[A-Z]_','X_');
% create folder
[pH,~] = fileparts(pExp(1,:));
pExpCombine = strcat(pH,'/',expname);
cd(pH);
mkdir(expname);