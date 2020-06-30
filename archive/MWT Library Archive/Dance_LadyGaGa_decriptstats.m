
function [DesStats,N,Mean,SE,DesStatsh] = LadyGaGa_decriptstats(sumimport,Summaryheader,SumIndex)
% Summaryheader
% minN = Minimum number of worms tracked during this interval
% maxN = Maximum number of worms tracked during this interval. I use the min and max as a sort of control to confirm that not too many worms are added or dropped during the interval
% durationR = Total duration of worm behavior recorded - if min=max, then this is simply your interval duration multiplied # of worms tracked
% revIncident = Number of reversals
% revSN = Number of worms that reversed at least once in the interval.
% meanRevDist = Average reversal distance
% meanRevDur = Average reversal duration
% revTimSum = Total time spent reversing during that interval 
i = ~cellfun(@isempty,(regexp(Summaryheader(:,2),SumIndex)'));
if sum(i) ==1;
sprevsindx = Summaryheader{i,1};
end

%% get mean per stim
% import data
%[~,psp] = dircontentext(pExp,'*.sprevs'); % get dir for all .sprevs
% sumimport = cellfun(@dlmread,psp,'UniformOutput',0); % import all sprevs


%% get mean rev per time point
%meanRev = cellfun(@mean,sumimport) % get mean for meanRev
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
saveProg = ['save' pExp '.sprevsum RevDesStats /ascii']; % write out matlab expression
cd(pExp);
eval(saveProg); % validate and execute matlab expression in text string
end