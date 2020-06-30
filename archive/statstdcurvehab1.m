function [HabGraphStd] = statstdcurvehab1(MWTftrvG)
%%function [D] = statcurve(D)
HabGraphStd = MWTftrvG(:,1);
for g = 1:size(MWTftrvG,1); % for every group  
    A = {};
    A = cell2mat((MWTftrvG{g,2}(:,10))'); % get distance data
    I = repmat(A(1,:),size(A,1),1); % get initial array
    A = A./I; % standardize to initial
    HabGraphStd{g,2}= mean(A,2);
    HabGraphStd{g,3}= SE(A);
    A = cell2mat((MWTftrvG{g,2}(:,8))'); % freq data
    I = repmat(A(1,:),size(A,1),1); % get initial array
    A = A./I; % standardize to initial
    HabGraphStd{g,4}= mean(A,2);
    HabGraphStd{g,5}= SE(A);
end
end

