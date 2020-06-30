function AnalysisOne(pExp,pFun,ID)
%AnalysisOne(pExp,pFun,ID)
%% define path for differnet computers/drives
% update for all computers


%% set paths
addpath(genpath(pFun));

%% Switch board
switch ID
    case 'MWT1'
        HabAnalysis2(pExp,pFun);
        
    % Step1: organize files, standard
    case 'Org1'
        MWTorgfiles2(pFun,pExp); 
    case 'Chor1'
        display('coding...');
    
    
    
    case 'Hab1'
        IgoreRaw3(pExp,pFun);% ungrouped data, standard habitutaion curve

    case 'Raw1' % grouped data, MWTfdata analysis only (to be removed soon)
        Igor3Raw1v2(pExp,pFun);
        [Time,Graph,Stats] = igoreGraphing2(pFun,pExp,'time','import*.mat'); 



    case 'Raw2' % ungrouped data, MWTfdata analysis only
    % [BUG] fixing no renaming on IgoreRaw2v2
        IgoreRaw2(pExp,pFun); 

    case 'G1' % graphing, ungrouped data, MWTfdata analysis only
        IgoreGraph1(pExp,pFun);
    case 'G2' % graphing with standard habituation curve
        IgoreGraph2(pExp,pFun,'import*.mat');
    %case 'G3'
     %   igoreGraphing3(pFun,pExp,Xn,rawfilename,intmin,int,intmax,m);
    case 'C1' % combine data already analyzed by Raw
        [MWTfdatGG,ExpGA] = getMWTfdatcombined(pBet);
    case 'GC1'; % make all graphs and save it in pBet
        [~,~,~,intmin,int,intmax,Xn] = selectmeasure2(pFun,...
            'analysisetting.mat',2);
        for m = 1:15;
            [Stats,Graph,Data] = igoreGraphCombineM(pFun,pBet,MWTfdatGG,intmin,int,intmax,m);        
        end
        
    case 'GdG1'; % get graph data within groups, use data analyzed by C1
        [GraphData,Time,Xaxis,Yn,titlename] = IgoreGraphDataexpwithingroup(MWTfdatGG,g,intmin,int,intmax,m,pFun);
        
    case 'Gexp1'
        makefigwithinexp(GraphData,g,setfilename,titlename,pFun,Yn,pBet);
        
    otherwise
        error('Invalid analysis code "%s"',ID);
end
end












