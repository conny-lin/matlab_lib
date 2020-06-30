function [GraphData,Time,Xaxis,Yn,titlename] = IgoreGraphDataexpwithingroup(MWTfdatGG,g,intmin,int,intmax,m,pFun)
% g = group row index (recorded in GAA)
%% load matlab settings
cd(pFun);
load('analysisetting.mat');
load('javasetting.mat'); 
Yn = MWTfdatGraphcode{m,2};
set = [m intmin int intmax];
Xaxis = (intmin:int:intmax)';
%% get data from all plates loop plates
for p = 1:size(MWTfdatGG{g,2},1); % loop plates  
    % import time
    ri = [];
    T = MWTfdatGG{g,2}{p,2}(:,1); % get time data
    for xt = intmin:int:intmax; % loop for time intervals
        [frame,~]= find(T>xt); % find a time
        tf = frame(1); % row to the beginning of next interval
        ri(end+1,1) = tf; % record row index
        ri(end,2) = xt; % record interval number
    end
    Time{g,2}{p,2} = ri;
    % get mean of measure per interval
    D = MWTfdatGG{g,2}{p,2}(:,m); % get speed data
    for x = 2:size(ri,1)-1; % for each time interval
        MWTfdatGG{g,3}(x,p) = mean(D(ri(x):ri(x+1)-1)); % mean of all data during this time
    end
end
GraphData = MWTfdatGG;
titlename = regexprep(mat2str(set),' ','x');
titlename = strcat(Yn,'_',titlename);



end

