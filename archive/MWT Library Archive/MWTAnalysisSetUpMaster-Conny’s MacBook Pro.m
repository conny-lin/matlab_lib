function [varargout] = MWTAnalysisSetUpMaster(pList)
%% instruction
% input names should be fixed


%% INPUT
MWTSet = pList;

if sum(isfield(pList,{'pSave','pJava','pFunA','pFunG'})) ~= 4
    error ('not enough input');
end


%% SEARCH MWT DATABASE
% liquidtsfcutoffdate = 20120213;
% invertedcutoffdate = 20130919;
[MWTfG] = MWTDataBaseMaster(MWTSet.pData,'search');


%% WITHIN OR ANY EXP
choicelist = {'Within Exp';'Any Exp'};
disp(makedisplay(choicelist));
choice = choicelist{input(': ')};
switch choice
    case 'Within Exp'
        [MWTfG] = MWTDataBase_withinexp(MWTfG);
end


%% IDENTIFY PROBLEM PLATES
% get plates
names = fieldnames(MWTfG);
fn = {};
for x = 1:numel(names)
    fn1 = MWTfG.(names{x});
    fn = [fn;fn1];
end
% get rid of MWT plates marked problematic
i = regexpcellout(fn(:,1),'\<(\d{8})[_](\d{6})\>');
fn2 = sortrows(fn(i,:),1);

% ask if want to exclude certain plates
display 'Do you want to exclude specific plates?';
opt = input('[yes/no]: ','s');
if strcmp(opt,'yes') == 1
    [fn3] = chooseoption(fn2,2);
    i = ~ismember(fn2(:,2),fn3);
    fn4 = fn2(i,2);
    [MWTfG] = reconstructMWTfG(fn4);
else
    display 'include all plates found';
end
% put in output
MWTSet.MWTfG = MWTfG;

%% DEFINE ANALYSIS PACKAGE
display ' '; display 'Analysis options: ';
pFunA = MWTSet.pFunA; APack = dircontent(pFunA);
disp(makedisplay(APack));
AnalysisName = APack{input('Select analysis option: ')};
MWTSet.pFunAP = [pFunA,'/',AnalysisName]; % GET ANALYSIS PACK PATH
MWTSet.AnalysisName = AnalysisName; % MWTSet output



%% TIME INTERVAL
[MWTSet] = MWTAnalysisSetUpMaster_timeinterval(MWTSet);



%% CREATE OUTPUT FOLDER
[MWTSet] = MWTSetUp_OutputFolder(MWTSet);


%% GRAPHING OPTIONS
[MWTSet] = MWTSetUp_GraphOption(MWTSet);


%% STATS OPTIONS
[MWTSet] = Dance_StatsMaster(MWTSet,'Setting');


%% CHOR OPTIONS
[MWTSet] = chormaster(MWTSet,'Setting');


%% OUTPUT




varargout{1} = MWTSet;



end


