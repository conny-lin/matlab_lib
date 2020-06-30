function [sumimport,Summaryheader] = evanscriptRv3(pExp,revInit)
%% create headings for .sprevs data
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

%% summarize data
display('Summarizing reversals...');
int = revInit(2)-revInit(1);
sumimport = {};
timecount = 0;
for timeS = revInit; % for every revInit time
    [~,pMWTf] = dircontentmwt(pExp); % get MWT folders contents
    timef = timeS+int;
    [Summary] = loopMWTf(pMWTf,timeS,timef);  
    sumimport{end+1,1} = Summary;
    timecount = timecount+1;
    display(sprintf('time#%d imported',timecount));
end
if isempty(timeS) ==1;
    timeS = 0;
end
display(sprintf('total %d imported',timeS)); % reporting
end



function [Summary] = loopMWTf(pMWTf,timeS,timef)
for z = 1:numel(pMWTf) % for the all MWTf
    [~,ptxt] = dircontentext(pMWTf{z},'*.txt'); % get txt data paths  
    reversals = zeros(1,4); % set up reversals array with 4 column sizes
    [reversals,datum] = loop4txt(ptxt,timef,timeS,reversals);
    [RevTerms] = makeRevTerms (reversals,timef);
    RevTerms(:,1) = reversals(:,2)+reversals(:,4); % rev terms = time and ?
    overTime = RevTerms(:,1)>timef; % overtime = row with time smaller than 190
    RevTerms(overTime,1) = timef; % change time all over time as 190
    % minus time with reversal times
    RevTerms(:,2) = RevTerms(:,1)-reversals(:,2); 
    [RevTerms] = makeRevTerms(reversals,timef);
    [Ddat] = getdat(pMWTf{z}); % process dat files
    [Datdatum,wormTime] = processdat(Ddat,timeS,timef);
    [Summary] = summary(Datdatum,wormTime,reversals,RevTerms,z);
end  
end




function [RevTerms] = makeRevTerms(reversals,timef)
RevTerms(:,1) = reversals(:,2)+reversals(:,4); % rev terms = time and ?
overTime = RevTerms(:,1)>timef; % overtime = row with time smaller than 190
RevTerms(overTime,1) = timef; % change time all over time as 190
% minus time with reversal times
RevTerms(:,2) = RevTerms(:,1)-reversals(:,2); 
end

function [Summary] = summary(Datdatum,wormTime,reversals,RevTerms,z)

% summary of intervals -----------
% Minimum number of worms tracked during this interval
Summary(z,1) = min(Datdatum(1:end,3));
% Maximum number of worms tracked during this interval. I use the min and max as a sort of control to confirm that not too many worms are added or dropped during the interval
Summary(z,2) = max(Datdatum(1:end,3));
% Total duration of worm behavior recorded - if min=max, then this is simply your interval duration multiplied # of worms tracked
Summary(z,3) = sum(wormTime(:,2));
% Number of reversals
Summary(z,4) = size(reversals(2:end,2),1);
% Number of worms that reversed at least once in the interval.
Summary(z,5) = size(unique(reversals(2:end,1)),1); 
% Average reversal distance
Summary(z,6) = mean(reversals(2:end,3));
% Average reversal duration
Summary(z,7) = mean(reversals(2:end,4));
% Total time spent reversing during that interval   
Summary(z,8) = sum(RevTerms(2:end,2));    

end



function [Datdatum,wormTime] = processdat(Ddat,timeS,timef)
    % find user defined valid time in .dat 
    validTimes = Ddat(:,1) > timeS & Ddat(:,1) < timef; 
    % get all data from valid time
    Datdatum = Ddat(validTimes,:);
    % calculate time differences from row-(row-1)
    wormTime = diff(Datdatum(:,1));
    % Multiplies the duration of each frame by the number of worms 
    % tracked for that frame to give the amount of worm behavior 
    % recorded for each frame
    wormTime(:,2) = wormTime(:,1).*Datdatum(2:end,3); 
end

function [Ddat] = getdat(p)
        [~,pdat] = dircontentext(p,'*.dat'); % get .dat file path
        if numel(pdat) ==1; % read if only has one .dat file
            Ddat = dlmread(pdat{1}); % read *.dat file
        else
            [fn,~] = fileparts(p);
            error('more than one .dat file in %s',fn);
        end
end



function [reversals,stimRevs,datum] = loop4txt(ptxt,timef,timeS,reversals)
for k = 1:size(ptxt,1); % for every txt files
    Dtxt = dlmread(ptxt{k}); % get data
    % stimRevs = row index defined as time (column2) larger than reInit(1) and 
    % smaller than revTerm()
    stimRevs = Dtxt(:,2) > timeS & Dtxt(:,2) < timef;   
    datum = Dtxt(stimRevs,:); % store data within time limit in datum
    reversals = [reversals; datum]; % sotre data with first row zeros
end
end