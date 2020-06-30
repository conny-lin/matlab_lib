    function [Summaryheader] = LadyGaGasummaryheader
% create headings for .sprevs data
% Summaryheader
% minN = Minimum number of worms tracked during this interval
% maxN = Maximum number of worms tracked during this interval. I use the min and max as a sort of control to confirm that not too many worms are added or dropped during the interval
% durationR = Total duration of worm behavior recorded - if min=max, then this is simply your interval duration multiplied # of worms tracked
% revIncident = Number of reversals
% revSN = Number of worms that reversed at least once in the interval.
% meanRevDist = Average reversal distance
% meanRevDur = Average reversal duration
% revTimSum = Total time spent reversing during that interval   
h = {'minN'; 'maxN';'durationR';'revIncident';'revSN';...
    'meanRevDist';'meanRevDur';'revTimSum'};
Summaryheader = cat(2,num2cell((1:numel(h))'),h);
    end