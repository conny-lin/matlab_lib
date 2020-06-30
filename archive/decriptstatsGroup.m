function [DesStats,N,Mean,SE,DesStatsh] = decriptstatsGroup(sumimport,Summaryheader,SumName,pExp)
i = ~cellfun(@isempty,(regexp(Summaryheader(:,2),SumName)'));
if sum(i) ==1;
    sprevsindx = Summaryheader{i,1};
end

% get mean rev per time point
meanrevc = sprevsindx; %
N = [];
Mean = [];
SE = [];
for stim = 1:numel(sumimport); % for the number of sprevs imported
    mdata = sumimport{stim}(:,meanrevc); % get meanrev data
    valid = not(isnan(sumimport{stim}(:,6))); % get not NaN index
    N(stim,1) = sum(valid); % get N for each mean
    Mean(stim,1) = mean(mdata(valid,1)); % get mean of valid data
    SE(stim,1) = std(mdata(valid,1),1)/sqrt(N(stim,1)); % get SE
end
DesStats = cat(2,N,Mean,SE);
DesStatsh = {'N' 'Mean' 'SE'};

% save files
under = '_';
[~,fn] = fileparts(pExp);
saveProg = ['save ' fn under SumName '.sprevsum DesStats /ascii']; % write out matlab expression
cd(pExp);
eval(saveProg); % validate and execute matlab expression in text string
end