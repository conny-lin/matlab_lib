function [HabGraph,X,Y,E] = ShaneSparkstatcurvehab2(MWTftrvG,MWTftrvL,option)
%% from
% MWTftrvL = {1,'MWTfile name';2,'Run name';3,'RawData';4,'NReversed';...
% 5,'TotalN';6,'N_NoResponse';7,'Time';8,'FreqRev';9,'Dist*NReversed';...
% 10,'Dist/NRev';11,'Dist/TotalN'};
%
% function [D] = statcurve(D)
% HabGraph = MWTftrvG(:,1); % file name
% for g = 1:size(MWTftrvG,1); % for every group  
%     A = {};
%     A = cell2mat((MWTftrvG{g,2}(:,10))'); % get distance data
%     HabGraph{g,2}= mean(A,2); 
%     HabGraph{g,3}= SE(A);
%     A = cell2mat((MWTftrvG{g,2}(:,8))'); % freq data
%     HabGraph{g,4}= mean(A,2);
%     HabGraph{g,5}= SE(A);
% end

HabGraph = MWTftrvG(:,1); % group name
timeind = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),'Time'))));
dataind = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),option))));

for g = 1:size(MWTftrvG,1); % for every group  
    A = {};
    HabGraph{g,2} = cell2mat((MWTftrvG{g,2}(:,timeind))'); % raw time 
    HabGraph{g,3} = (1:size(HabGraph{g,2},1))'; % scaled time
    A = cell2mat((MWTftrvG{g,2}(:,dataind))'); % get data option selected
    HabGraph{g,4}= mean(A,2); 
    HabGraph{g,5}= SE(A);
end
X = cell2mat(HabGraph(:,3)');
Y = cell2mat(HabGraph(:,4)'); 
E = cell2mat(HabGraph(:,5)');


end