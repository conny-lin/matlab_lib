function [GraphData,Time,Xaxis,Yn,titlename] = getmeanresponse3(MWTfdatG,intmin,int,intmax,m,pFun)
% from preset measure
%% get speed is at column 6
%m = 6; % select speed (at column 6)
% set up time intervals
%intmin = 0; % starting time
%int = 10; % at 10 second intervals
%intmax = 410; % until max time
%% load matlab settings
cd(pFun);
load('analysisetting.mat');
load('javasetting.mat'); % load matlab settings
Yn = MWTfdatGraphcode{m,2};
set = [m intmin int intmax];

Time = MWTfdatG(:,1:2); % get group name
Xaxis = (intmin:int:intmax)';
for g = 1:size(MWTfdatG,1); % loop groups
    for p = 1:size(MWTfdatG{g,2},1); % loop plates  
        % import time
        ri = [];
        T = MWTfdatG{g,2}{p,2}(:,1); % get time data
        for xt = intmin:int:intmax; % loop for time intervals
            [frame,~]= find(T>xt); % find a time
            tf = frame(1); % row to the beginning of next interval
            ri(end+1,1) = tf; % record row index
            ri(end,2) = xt; % record interval number
        end
        Time{g,2}{p,2} = ri;
   
        % get mean of measure per interval
        D = MWTfdatG{g,2}{p,2}(:,m); % get speed data
        for x = 2:size(ri,1)-1; % for each time interval
            MWTfdatG{g,3}(x,p) = mean(D(ri(x):ri(x+1)-1)); % mean of all data during this time
        end
        
    end

end
GraphData = MWTfdatG;

titlename = regexprep(mat2str(set),' ','x');
titlename = strcat(Yn,'_',titlename);
end