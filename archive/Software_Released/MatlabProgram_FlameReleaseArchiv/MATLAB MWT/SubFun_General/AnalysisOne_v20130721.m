function AnalysisOne_v20130721(pExp,pFun,ID)
%% IgorePilot_v3
%  works with JAVA code:
% java -jar '/home/crankin/Desktop/Beethoven_v2.jar' '/home/crankin/Desktop/Chore_1.3.0.r1035.jar' -p 0.027 -s 0.1 -t 20 -M 2 --shadowless -S -o nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d*1 --plugin Reoutline::exp --plugin Respine   
% ID- 2 = ungrouped data, 1 = grouped data
% [TESTING CODE]user defined info
%pExp1 = '/Users/connylinlin/MatLabTest/Igor/Beethoven_sumallpara';
%pFun = '/Users/connylinlin/Documents/Lab/Methods & Database/Analysis/MatlabProgramming/Program_Coding/Igor/IgorPilot_v3';
%pExp2 = '/Users/connylinlin/MatLabTest/Igor/20130407A_FP_100s30x10s10s_Dose';
%pFunSub = strcat(pFun,'/SubFun'); % define where the supporting .mat is
%pFun = pFunSub;

%% set paths
addpath(genpath(pFun));
cd(pFun);
%% [DEVELOP] Switch board
switch ID
    case 'Raw1' % grouped data, MWTfdata analysis only
        Igor3Raw1(pExp,pFun);
    case 'Raw2' % ungrouped data, MWTfdata analysis only
        IgoreRaw2(pExp,pFun); 
    %case 'Raw3'
        %IgoreRaw3(pExp,pFun);% ungrouped data, standard habitutaion curve
    case 'G1' % graphing, ungrouped data, MWTfdata analysis only
        IgoreGraph1(pExp,pFun);
    case 'G2' % graphing with standard habituation curve
        IgoreGraph2(pExp,pFun,'import*.mat');
    otherwise
        error('Invalid analysis code "%s"',ID);
end
end












