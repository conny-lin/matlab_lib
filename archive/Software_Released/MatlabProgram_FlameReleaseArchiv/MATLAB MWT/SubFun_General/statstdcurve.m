function [D] = statstdcurve(D)
%% Standardized Curve
for f = 1:size(D,1); % for every import
    for g = 1:size(D{f,3},1); % for every group  
        A = {};
        A = D{f,3}{g,2}; % get data
        I = repmat(A(1,:),size(A,1),1); % get initial array
        A = A./I; % standardize to initial
        D{f,3}{g,3}= mean(A,2); % calculate mean
        D{f,3}{g,4}= SE(A); % calculate SE
    end
    D{f,4} = cell2mat(D{f,3}(:,3)'); % combine get group mean 
    D{f,5} = cell2mat(D{f,3}(:,4)'); % combine get group se 
end
end