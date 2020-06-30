function [Summary] = TEMP1(pExp,pFun)
% .dat file generated by '-o nNss*b12' gives 
    % time
    % n = number of objects tracked
    % N = number of valid objectives
    % s = speed
    % s* = speed SD
    % b = b bias -- fractional excess of time spent moving one way 
    % 1 tap -- whether a tap (stimulus 1) has occurred 
    % 2 puff -- whether a puff (stimulus 2) has occurred 
    % .txt generated by '--plugin MeasureReversal::postfix=txt'

%% modified from Evan Ardiel
% Evan's Instruction:
% This will give you a .txt file for every object listing each reversal 
% for that object. The following matlab script will combine your plates
% for 1 condition and give a .sprev file for whatever intervals you 
% specify in the %input options section. In the script below you'd get the 
% spontaneous reversals from 180-190s, 190-200s, 200-210s, but this could 
% be adjusted however you needed. For example, for spontaneous reversals 
% for the first three minutes, it'd be

% revInit = 0:60:120;
% revTerm = 60:60:180;
% 
% The .sprev files contain summarized info about the spontaneous reversals 
% for each interval. 


%%%%%%%%
%% paths
addpath(pFun); % add path to function folder

%% input options
% revInit = 180:10:200; % startin from 180 second, for every 10 seconds, end at 200 seconds
% revTerm = 190:10:210; % first time end at 190 second, for every 10 seconds, last end at 210 seconds
% user input
choice = 1;
switch choice
    case 2
    timeinput = input('enter start time(s):interval(s):endtime(s) (i.e 90:10:210):\n');
    case 1
    revInit = 10:10:400; % startin from 180 second, for every 10 seconds, end at 200 seconds
    revTerm = 20:10:410; % first time end at 190 second, for every 10 seconds, last end at 210 seconds
end



%% loop through every interval
for t = 1:size(revInit,2); % for every revInit definition
    % Motherfoldercontents = dir(pwd); % import dir
    [~,pMWTf] = dircontentmwt(pExp); % get MWT folders contents
    counting = 0; % count for each interval
    % Togetherness= zeros(1,5); % don't know why this is here, not used below
    % for z = 1 : numel(Motherfoldercontents) % for the all MWTf
    for z = 1:numel(pMWTf) % for the all MWTf
        counting = counting+1; % record this folder had been deal with
 
        reversals = zeros(1,4); % set up reversals array with 4 column sizes

        [~,ptxt] = dircontentext(pMWTf{z},'*.txt');
        
        % get txt data into reversals
        choice = 'Evan'; % choose how to get reversals
        switch choice
            case 'Evan'
                % for k = 1:size(dirData,1); % for every txt files
                for k = 1:size(ptxt,1); % for every txt files

                    % storedData = dlmread(dirData(k).name); % get data
                    storedData = dlmread(ptxt{k}); % get data
                    % stimRevs = row index defined as time (column2) larger than reInit(1) and 
                    % smaller than revTerm()
                    stimRevs = storedData(:,2) > revInit(1,t) & storedData(:,2) < revTerm(1,t);   
                    datum = storedData(stimRevs,:); % store data within time limit in datum
                    reversals = [reversals; datum]; % sotre data with first row zeros
                end
            case 'Conny';
                % [EFFICIENTCY]  get all data and then choose stimRevs
        end
        RevTerms(:,1) = reversals(:,2)+reversals(:,4); % rev terms = time and ?
        overTime = RevTerms(:,1)>revTerm(1,t); % overtime = row with time smaller than 190
        RevTerms(overTime,1) = revTerm(1,t); % change time all over time as 190
        RevTerms(:,2) = RevTerms(:,1)-reversals(:,2); % minus time with reversal times

        [~,pdat] = dircontentext(pMWTf{z},'*.dat'); % get .dat file path

        % storedDatData = dlmread(dirDatData(end).name); % read *.dat file
        if numel(pdat) ==1; % read if only has one .dat file
            storedDatData = dlmread(pdat{1}); % read *.dat file
        else
            [MWTfn,~] = fileparts(pMWTf{z});
            error('more than one .dat file in %s',MWTfn);
        end

        % find user defined valid time in .dat 
        validTimes = storedDatData(:,1) > revInit(1,t) & storedDatData(:,1) < revTerm(1,t); 
        % get all data from valid time
        Datdatum = storedDatData(validTimes,:);
        % calculate time differences from row-(row-1)
        wormTime = diff(Datdatum(:,1));
        % total time traveled of all valid worms (timediff*validworms)
        % validworms(=.dat column 3) 
        wormTime(:,2) = wormTime(:,1).*Datdatum(2:end,3);

        % summary of intervals -----------
        % counting = index of MWTf
        % find minimum worm valid
        Summary(counting,1) = min(Datdatum(1:end,3)); 
        % find max worm valid
        Summary(counting,2) = max(Datdatum(1:end,3));
        % sum of time traveled within user defined interval (ie. every
        % 10second)
        Summary(counting,3) = sum(wormTime(:,2));
        % reversal N
        Summary(counting,4) = size(reversals(2:end,2),1);
        % get unique times for reversal recording
        Summary(counting,5) = size(unique(reversals(2:end,1)),1); 
        % get mean (of txt column 2) reversal distance/time?
        Summary(counting,6) = mean(reversals(2:end,3));
        % get mean reversals (from txt column 4) distance?
        Summary(counting,7) = mean(reversals(2:end,4));
        % total time reversed
        Summary(counting,8) = sum(RevTerms(2:end,2));
        
        
        % cd ('..'); % cd to something else % suspended     
        clearvars -except Summary revInit revTerm ...
         counting z t pMWTf pExp;  % clean up % supsended
        %end % removed because no need to validate MWT folder
    end % end of loop for looping MWTf  

    %% create output for time point t
    % currentDirectory = pwd; % find current directory (probably a pMWT)
    % [~, deepestFolder] = fileparts(currentDirectory); % find pExp

    stimNum = num2str(revInit(1,t)); % define stim number
    underscore = '_'; % define underscore
    saveProg = ['save ' pExp underscore stimNum '.sprevs Summary /ascii']; % write out matlab expression
    eval(saveProg); % validate and execute matlab expression in text string
    %% reporting
    display(sprintf('time point %d recorded',t)); % reporting
    %% clean up
    clearvars -except pExp pFun  revInit revTerm t % clear vars % not necesary 
    % clear all % clean up workspace % suspended
    
end


