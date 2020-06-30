function [T,P] = validateMWTfnzip(MWTf)
%% make sure the dir name is MWTzip folder (20130407_153802)
% P = pass (1) or fail(0), T = individual pass or fail
T = [];
for x = 1:size(MWTf,1);
    % set conditions
    %c1 = isequal(isdir(pMWTf{x,1}),1); % c1=1 if it is a dir
    c1 = isequal(MWTf{x,1}(end-2:end),'zip'); % see if the last 3 characters are zip
    c2 = isequal(size(MWTf{x,1},2),19); % c2=1 if name is 15 characters
    c3 = isequal(strfind(MWTf{x,1},'_'),9); % c3=1 if _ at position9
    c4 = isnumeric(str2num(MWTf{x,1}(1:8))); % first 8 digit numeric
    c5 = isnumeric(str2num(MWTf{x,1}(10:15))); % last 6 digit numeric
    if (c1+c2+c3+c4+c5) ==5; % if satisfies all 5 conditions
        T(x,1) = 1; % record pass
    else
        T(x,1) = 0; % record fail
    end
end
P = isequal(size(MWTf,1),sum(T));
end

