function [Score] = removedupscore(Score,iuser, itime, igame, iscore)
display 'eliminating duplicated time points'
% minus next time point with previous time points
Score = sortrows(Score,[iuser,itime,igame,iscore]);
a = Score(:,itime); % current time
b = [Score(2:end,itime);1]; % next time in relation to current time
i = b-a ~=0; % index to none duplicated time (exclude the old time)
% report
str = '%d duplicate time points, %d valid datapoints';
display(sprintf(str,sum(not(i)),size(Score,1)));
% eliminate
Score = Score(i,:); 