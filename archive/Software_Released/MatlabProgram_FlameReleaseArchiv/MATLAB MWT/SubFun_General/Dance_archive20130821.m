function [O] = Dance(p,cd)
%% INSTRUCTION
% 1) set path of interest:
%    1) Drag path into Command Window
%    2) Type in [p=cd] and press ENTER
% 2) Drag in MWT_Programs folder (located under your MultiWormTrackerPortal
% folder)
% 3) Type in Dance(p,cd)
%
% Variables:
%   p = path of interest, different for each analysis
%   pF = path to function folder, you can cd to your


% Coding History: 
%   created from AnalysisOne(pExp,pFun,ID)
%   created by Conny Lin 2013

%% evaluate inputs, preserve paths and generate function paths
pFun = cd;% preserve pFun location
pInput = p; % preserve p 

%% add unrestricted paths
addpath(pFun); % gen paths for major functions
addpath([pFun '/' 'SubFun_Released']); % get path to released functions

%% User inputs
user = input('Enter your name: ','s');
[p] = definepath4diffcomputers2(cd,user); % get defined paths


%% analysis ID selection
% create id selections
ID = {'ShaneSpark';'LadyGaGa';'Igor'};
disp([num2cell((1:numel(ID))') ID]);
% ask for analysis id
display 'enter analysis number: ';
a = input('enter analysis number (press enter to abort): ');
if isempty(a) ==1;
    return
end
id = ID{a};


%% Analysis Switch board
O = []; % [CODE] Define output O % temperary assign O = nothing

switch ID
    case 'ShaneSpark'
        %% standard habituation curve anaylysis
        %% set paths
        pExp = pInput;
        ShaneSpark(pExp,pFun);

    case 'LadyGaGa'
        %% analyze reversal responses without taps
        choice = 'suspend'; % coding status
        graph = 'combined'; % graph choice
        % ask if have done chor analysis
        display('Was LadyGaGa choreography analysis completed previously?');
        Overwrite = input('[y=1,n=0]: ');
        display('Zip current file as backup?');
        zipfile = input('[y=1,n=0]: ');
        display('New run condition?');
        sprevsQ = input('[y=1,n=0]: ');
        % set path
        pExp = pInput;
        % run program
        LadyGaGa(pExp,pFun,choice,graph,Overwrite,zipfile,sprevsQ);


    case 'Igor'        
        %% gives analysis of raw chor output
        %% add chor analysis to IgoreRaw2
        pExp = pInput;
        Igor(pExp,pFun); 

    case 'combineExp'
        %% [unfinished script] combine experiment
        combineexp;
        
        
    case 'Org1'
    %% Step1: organize files, standard
    MWTorgfiles2(pFun,pExp); 


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












