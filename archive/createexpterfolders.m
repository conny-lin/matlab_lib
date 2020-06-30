function createexpterfolders(pFun,pPF)
%% create personal folders
addpath(genpath(pFun));
load('expter.mat');
cd(pPF);
for x = 1:size(expter,1);
    p = strcat(pPF,'/',expter{x,1}); % create path pPF
    if isdir(p) ==0; % check if is dir
        mkdir(expter{x,1});
    end
end

