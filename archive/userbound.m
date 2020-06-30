function [userbound] = userbound(Data,iuser,itime)

Data = sortrows(Data,[iuser,itime]);
a = Data(:,iuser); % raw user name
b = [Data(1,iuser);Data(1:end-1,iuser)]; % next user name
k = a(:,1) > b(:,1); % current username - next user name
userbound = [true;k(2:end)];
str = '%d user bounderies found for %d users';
display(sprintf(str,sum(userbound),numel(unique(Data(:,iuser)))));
if sum(userbound) ~= numel(unique(Data(:,iuser)));
    warning('user boundaries search problematic');
end