function [RevDesStats,RevDesStatsh] = meanperstim(pExp,meanindex)
% set meanindex to 6
%% get mean per stim
% import data
[~,psp] = dircontentext(pExp,'*.sprevs'); % get dir for all .sprevs
sumimport = cellfun(@dlmread,psp,'UniformOutput',0); % import all sprevs
%% get mean rev per time point
%meanRev = cellfun(@mean,sumimport) % get mean for meanRev
meanrevc = meanindex; % define mean data as column 6
RevN = [];
RevMean = [];
RevSE = [];
for stim = 1:numel(sumimport); % for the number of sprevs imported
    mdata = sumimport{stim}(:,meanrevc); % get meanrev data
    valid = not(isnan(sumimport{stim}(:,6))); % get not NaN index
    RevN(stim,1) = sum(valid); % get N for each mean
    RevMean(stim,1) = mean(mdata(valid,1)); % get mean of valid data
    RevSE(stim,1) = std(mdata(valid,1),1)/sqrt(RevN(stim,1)); % get SE
end
RevDesStats = cat(2,RevN,RevMean,RevSE);
RevDesStatsh = {'N' 'Mean' 'SE'};

% save files
saveProg = ['save ' pExp '.sprevsum RevDesStats /ascii']; % write out matlab expression, must leave the space behind the save
cd(pExp);
eval(saveProg); % validate and execute matlab expression in text string
end