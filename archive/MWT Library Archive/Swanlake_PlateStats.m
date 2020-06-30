function [varargout] = Swanlake_PlateStats(MWTindex,ST,varargin)

varargout = {};

%% INPUT 
SampleTime = ST.all;
SampleTime_NoTap = ST.notap;
SampleDur = ST.Sdur;

%% VARARGIN
% [optional] measuretype
i = strcmp(varargin,'measure');
if isempty(i) ==0 && sum(i) ==1 && iscell(varargin{find(i)+1}) ==1
    measuretype = varargin{find(i)+1};
end


%% CREATE PLATE STATS
display 'calculating plate stats...';
% get data from import
pMWTf = MWTindex.platepath.text;
D = cell(size(pMWTf));
for mwt = 1:numel(pMWTf)
    cd(pMWTf{mwt}); load('swanlake.mat','swanlake');
    A = swanlake;
    tapt = A.time((A.tap ==1));
    t = sort([SampleTime_NoTap,tapt']);
    
    % get data location from t:t+SampleDur
    i = false(size(t)); % create logical array 
    for x = 1:numel(t)
        i(A.time>=t(x) & A.time<=t(x)+SampleDur) = true;
    end
    
    % retain only time of interest
    D{mwt}.plate = A.plate; 
    D{mwt}.platepath = A.platepath;
    if exist('measuretype','var') ==0
        measure = fieldnames(A);
        k = regexpcellout(measure,'(plate)|(platepath)');
        measuretype = measure(~k);
    end

    for m = 1:numel(measuretype)
        D{mwt}.(measuretype{m}) = A.(measuretype{m})(i);
    end
    
    D{mwt}.time = A.time(i); % record time
end
Data = D; 
varargout{2} = D;
clearvars D;

%% reporting
display 'for measurements:';
disp(measuretype);

% %% reorganize Data to match MWTfn
% MWTfn = MWTindex.plate.text;
% pname = cell(size(Data));
% 
% 
% for mwt = 1:numel(Data)
%     pname{mwt} = Data{mwt}.plate;
% end
% [~,k] = ismember(MWTfn,pname);
% if issorted(k) == 0; display 'matching data sequence'; Data = Data(k); end
% 

%% calculate descriptive stats for plates
display 'calculating descriptive stats';
%GroupBy = 'plate';
C = [];
for m = 1:numel(measuretype)
    B = []; 
 %   StatType = 'Descriptive';
    for mwt = 1:numel(pMWTf)
        % get plate data
        A = Data{mwt};
        A.time = floor(A.time); % floor time
        % get time sample number
        [n] = grpstats(A.time,A.time,{'numel'});
        
        % code mwt code, time, sampling time
        a = [repmat(mwt,numel(n),1),unique(A.time),n];

        % get mean for each time points
        [mns,sd] = grpstats(A.(measuretype{m}),A.time,{'mean','std'}); 
        B = [B;[a,mns,sd]];
    end
    C.(measuretype{m}) = B;
end
%Stats.(Analysis).(GroupBy).(StatType) = C;
%clearvars B A Import;
varargout{1} = C;

