function [pRaw,pRawC,pBetC] = definepath4diffcomputers(pFun)
i = strfind(pFun,'/');
s = pFun(i(2)+1:i(3)-1); % get the name of the storage

switch s
    case 'connylinlin'
        pRaw = '/Users/connylinlin/MatLabTest/MWT_Raw_Data';
        pRawC = '/Users/connylinlin/MatLabTest/MWT_ConnyONLY/MWT_Raw_Data_new';
        pBetC = '/Users/connylinlin/MatLabTest/MWT_ConnyONLY/MWT_Analysis_Record';
    case 'FLAME'
        pRaw = '/Volumes/FLAME/MultiWormTracker_Centre/MWT_Raw_Data';
        pRawC = '/Volumes/FLAME/MultiWormTracker_Centre/MWT_ConnyOnly/MWT_NewRawDataReport';       
        pBetC = '/Volumes/FLAME/MultiWormTracker_Centre/MWT_ConnyOnly/MWT_AnalysisRecord';
    case 'AWLight'
        %pRaw = '/Volumes/AWLight/MWT_Data/Raw_Data';
        %pRawC = '/Volumes/AWLight/Student_Folders/Conny Lin/Raw_Data_new';
    otherwise
        pRaw = input('copy and paste path to Raw data storage:\n');
        pRawC = input('copy and paste path to Raw data notification:\n');
        pBetC = input('copy and paste path to Analysis notification:\n');
        warning('this part is under construction...');
end
end
