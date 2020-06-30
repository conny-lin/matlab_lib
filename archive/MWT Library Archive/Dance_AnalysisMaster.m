function [MWTSet] = Dance_AnalysisMaster(varargin)


%% optionlist
% option name, function name
optionlist = {'ShaneSpark';'ShaneSpark2';'Swanlake2';'DrunkPosture'};

%% varargin
A = varargin;


%% SETTING
setname = 'AnalysisName'; % setting name in MWTSet
if sum(strcmp(A,'Setting')) == 1  
    if strcmp(inputname(1),'MWTSet') == 1
        MWTSet = A{1};
    else
        error('first input for this function must be named MWTSet')
    end
    
    display ' '; display 'Analysis options...';
    option = chooseoption(optionlist,2);
    MWTSet.(setname) = option;

    return
else  
    MWTSet = A{1};
end


%% starting report
display ' '; 
display(sprintf('Running analysis package [%s]',MWTSet.AnalysisName));
% add path to analysis packs
addpath(MWTSet.pFunAP);

% run analysis
switch MWTSet.AnalysisName
    case 'ShaneSpark'
        [MWTSet] = Dance_ShaneSpark(MWTSet);
    case 'ShaneSpark2';
        [MWTSet] = Dance_ShaneSpark2(MWTSet);
    case 'DrunkPosture';
        [MWTSet.Raw] = Dance_DrunkPosture(MWTSet);
%     case 'LadyGaGa'
%         Dance_LadyGaGa(MWTSet);
    case 'Swanlake2'
        error ('under construction');
        
    otherwise
        error('Analysis not installed');
end
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');
