%% rerun analysis
pList = PathCommonList('Dance','Conny','Developer');

% drag folder
pR = cd;

% load matlab
cd(pR); load('matlab.mat');
% correct pSave A location
MWTSet.pSaveA = pR;


%% STATS OPTIONS
display ' ';
display 'Statistics options...';
[MWTSet] = Dance_StatsMaster(MWTSet,'Setting');


%% STATS SWITCH BOARD
[MWTSet] = Dance_StatsMaster(MWTSet);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');

%% GRAPH SETTING
[MWTSet] = MWTAnalysisSetUpMaster_Graphing(MWTSet);
cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');


%% GRAPHING SWITCH BOARD
GraphNames = MWTSet.GraphNames;
GraphN = numel(GraphNames);

for x = 1:GraphN
    display ' '; 
    display(sprintf('Running graphing package [%s]',GraphNames{x}));
    addpath(MWTSet.pFunGP{x}); % add path to analysis packs
    switch GraphNames{x}
        
        case 'Individual graphs'
            [MWTSet] = Dance_Graph_Individual(MWTSet);
        
        case 'subplot all in one'
            [MWTSet] = Dance_Graph_Subplot(MWTSet);
        
        case 'subplot SD'
            [MWTSet] = Dance_Graph_Subplot_SD(MWTSet);
    
        otherwise
        error('Graph packs not installed');
    end
end

cd(MWTSet.pSaveA); save('matlab.mat','MWTSet');





display 'Analysis completed';