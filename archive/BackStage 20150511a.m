% function [varargout] = BackStage(varargin)
%% INSTRUCTION

%% VARARGOUT
% varargout{1} = {};
%

%% PROGRAM INFO
clear;
MWTSet.Program_Version = 'BackStage 20150412';
ProgramStatusType = {'Coding','Published','Testing'};
ProgramStatus = ProgramStatusType{3};
%

%% 1. PATHS
% get code path
p = fileparts(which(mfilename));
MWTSet.PATHS.pCode = p;

% add local function library folder
pFunLibrary = [p,'/Library'];
addpath(pFunLibrary); 
MWTSet.PATHS.pCodeLibrary = pFunLibrary;

% add matlab public library path
filename = [MWTSet.PATHS.pCodeLibrary,'/matlabfunctionpath.dat'];
fileID = fopen(filename,'r');
dataArray = textscan(fileID, '%s%[^\n\r]',...
    'Delimiter', '',  'ReturnOnError', false);
fclose(fileID);
pFunPublic = char(dataArray{:, 1});
addpath(pFunPublic);
MWTSet.PATHS.pCodePublic = pFunPublic;


% add extension pack path
pFunExt = [p,'/Library/ExtentionPacks'];
addpath(pFunExt);
MWTSet.PATHS.pExtPacks = pFunExt; 

% add modules path
pFunModules = [p,'/Library/Modules'];
addpath(pFunModules);
MWTSet.PATHS.pCodeModules = pFunModules; 

% find MWT_Data paths
switch ProgramStatus
    case 'Coding'
        pDriveHome = '/Volumes/ParahippocampalGyrus/';
    case 'Testing'
        pDriveHome = '/Volumes/ParahippocampalGyrus/';
    case 'Published'
        [drivepath, drivenames] = findharddrive;
        [~,i] = chooseoption(drivenames,'Choose hard drive: ');
        pDriveHome = drivepath{i};
end

pStore = [pDriveHome,'/MWT_Data_Org/MWT_Data_ExpZip_20150412'];
pIn = [pDriveHome,'/MWT_Data_Inbox'];
pData = [pDriveHome,'/MWT_Data']; MWTSet.PATHS.pData = pData;
pTemp = [pDriveHome,'/TEMP']; if isdir(pTemp) == 0; mkdir(pTemp); end
pAnalysis=  [pDriveHome,'/MWT_Data_Analysis'];


% generate output paths
pOutputHome = '/Users/connylin/OneDrive/Lab/Dance Output';
MWTSet.PATHS.pSave = pOutputHome;
MWTSet.timestamp = generatetimestamp;
pSaveA = [MWTSet.PATHS.pSave,'/',MWTSet.timestamp];
MWTSet.PATHS.pSaveA = pSaveA;
if isdir(pSaveA) == 0; mkdir(pSaveA); end

%% stop program if testing
if strcmp(ProgramStatus,'Testing') == 1
    cd(pSaveA); save('matlab.mat','MWTSet'); return
end

%% Run extension packs


% get extension pack names
a = dircontent(MWTSet.PATHS.pExtPacks,'*.m');
ExtPackNames = regexprep(a,'[.]m','');

% select expension pack
a = makedisplay(ExtPackNames);
display 'Select BackStage program to run:'
disp(a)
i = input(': ');
% run expension pack selected
eval(ExtPackNames{i})


return




















