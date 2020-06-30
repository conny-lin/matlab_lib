function testfun(pExp,t)
%%
revInit = 20:10:500; % startin from 180 second, for every 10 seconds, end at 200 seconds
    revTerm = 30:10:510;
    %%
    
    % Motherfoldercontents = dir(pwd); % import dir
    [~,pMWTf] = dircontentmwt(pExp); % get MWT folders contents
    counting = 0; % count for each interval
    % Togetherness= zeros(1,5); % don't know why this is here, not used below
    % for z = 1 : numel(Motherfoldercontents) % for the all MWTf
    for z = 1:numel(pMWTf) % for the all MWTf
        % validate dir is MWT folder (dealt with by dircontentmwt)
        %if Motherfoldercontents(z).isdir && ~any(strcmp(Motherfoldercontents(z).name, {'.' '..'})); % if dir that is a dir and are not . and ..
        counting = counting+1; % record this folder had been deal with
        % group(counting).name = Motherfoldercontents(z).name; % get the name of the folder
        % parentfolder = Motherfoldercontents(z).name; % get MWTf name
        % cd(parentfolder); % go to pMWT % dealt with by directly path to
        % files or % cd(pMWTf{z});
        reversals = zeros(1,4); % set up reversals array with 4 column sizes
        % dirData = dir('*.txt'); % get txt files within the folder
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

        % dirDatData = dir('*.dat'); % get .dat dir
        [~,pdat] = dircontentext(pMWTf{z},'*.dat') % get .dat file path

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
        % clearvars -except Summary revInit revTerm Motherfoldercontents
        % counting z t;  % clean up % supsended
        %end % removed because no need to validate MWT folder
    end % end of loop for looping MWTf
end