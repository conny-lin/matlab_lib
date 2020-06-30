function [HabGraph] = statcurvehab1(MWTftrvG)
%%function [D] = statcurve(D)
HabGraph = MWTftrvG(:,1);
for g = 1:size(MWTftrvG,1); % for every group  
    A = {};
    A = cell2mat((MWTftrvG{g,2}(:,10))'); % get distance data
    HabGraph{g,2}= mean(A,2);
    HabGraph{g,3}= SE(A);
    A = cell2mat((MWTftrvG{g,2}(:,8))'); % freq data
    HabGraph{g,4}= mean(A,2);
    HabGraph{g,5}= SE(A);
end
end