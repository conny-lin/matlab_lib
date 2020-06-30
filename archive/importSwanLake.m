function [Data] = importSwanLake(pSaveA,Analysis)
% input -----------
% Analysis = 'Movements';
L = {'time'; 'number'; 'goodnumber';'area';'midline';'morphwidth';...
    'aspect';'width';'length';'kink';'curve';'speed';'pathlen';'bias';...
    'dir';'tap'}';
switch Analysis
    case 'Movements'
        measure = {'speed';'pathlen';'bias';'dir'}';
    case 'Posture'
        measure = {'aspect';'width';'length';'kink';'curve'};
end
        


% GET DATA FROM IMPORT
cd(pSaveA); load('Swanlake.mat', 'Import');
cd(pSaveA); load('matlab.mat', 'MWTindex','RCT');
pMWTf = MWTindex.platepath.text;
% get times
% SET SAMPLE TIME
% set time interval: sample half a second (sampledur) after sampletime
INT = 10; % 10seconds
a = regexp(RCT,'[s,x]','split');
preplate = str2num(a{1});
tapN = str2num(a{2});
int = str2num(a{3});
aftertap = str2num(a{4});
endtap = int*tapN+preplate; 
beforetap = INT:INT:preplate-INT;
followtap = endtap+INT:INT:aftertap+endtap;
sampledur = 0.5;
ST = [beforetap,followtap];


% get time
for mwt = 1:numel(pMWTf)
    time = Import{mwt}(:,strcmp('time',L));
    i = false(size(time)); % create logical array
    % find tap time
    ttime = Import{mwt}(:,strcmp('tap',L));
    ttime = time(ttime==1);
    tendtime = ttime+sampledur;
    % get sampling time points
    sampletime = sort([ST,ttime']);
    
    for ts = 1:numel(sampletime)
        t = sampletime(ts);
        i(time>=t & time<=t+sampledur) = true;
    end
    Import{mwt} = Import{mwt}(i,:); % retain only time of interest
end
% get data
for m = 1:numel(measure)
    B = [];
    for mwt = 1:numel(pMWTf)
        A = Import{mwt};
        A(:,strcmp('time',L)) = floor(A(:,strcmp('time',L))); % floor time
        [n] = grpstats(A(:,strcmp('time',L)),A(:,strcmp('time',L)),...
            {'numel'});
        % code mwt code, time, sampling time
        D = [repmat(mwt,numel(n),1),unique(A(:,strcmp('time',L))),n];

        % get mean for each time points
        [mns,sd] = grpstats(A(:,strcmp(measure{m},L)),A(:,strcmp('time',L)),...
        {'mean','std'}); 
        B = [B;[D,mns,sd]];
    end
    Data.(Analysis).(measure{m}) = B;
end
clearvars B A Import;


