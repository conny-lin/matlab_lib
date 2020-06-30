function [pExpf,MWTsum] = MWTrunameMaster(Home,ID)
%% [further development
% automatically remove extra_ after group code

%% interpret input
% display 'MWT run name check begins...';
Version = char(regexp(ID,'(tested)|(developer)|(groupcode)|(onebyone)|(switch)|(choice)|(synchronize)|(duplicate)','match'));


%% declare action
display ' ';
display(sprintf('Running MWTrunameMaster[Option:%s]',ID));
%% general code
% get run name
[pMWTf,MWTfn,MWTfsn,MWTsum,pExpf] = getMWTrunamefromHomepath(Home);
MWTrunameCorr = MWTfsn;

%% Switch board
switch Version 
    case 'groupcode'
        groupf = Home;
        display 'This only works for one folder at a time';
        display 'enter [go] to continue or press [enter] to restart';
        i = input(': ','s');
        if isempty(i) ==1;
            return
        end
        [strain,seedcolony,colonygrowcond,runcond,trackergroup] = ...
        parseMWTfnbyunder(MWTfsn);
        a = char(trackergroup);
        groupcode = a(:,end-1);
        b = unique(groupcode);
        if numel(b) ==1;
            str = 'For group folder [%s]';
            [~,groupfname] = fileparts(groupf);
            display(sprintf(str,groupfname));
            str = 'all MWT has the same group code [%s]';
            display(sprintf(str,b));
            return
        else
            groupcodecorr = input('Enter correct group code: ','s');
            % replace with correct group code
            part1 = a(:,1:end-2);
            part2 = char(cellfunexpr(trackergroup,groupcodecorr));
            part3 = a(:,end);
            trackergroupcorr = [part1,part2,part3] % reconstruct
        end
        % incorporate new to MWTruname
        [u] = cellfunexpr(MWTrunameCorr,'_');
        MWTrunameCorr = cellfun(@strcat,strain,u,seedcolony,u,colonygrowcond,u,...
            runcond,u,trackergroup,'UniformOutput',0);
    case 'tested'
        [MWTrunameCorr] = MWTfsnCheck(MWTfn,MWTfsn);
    case 'switch'
        %% global switch
        display 'correct specific run condition to a different one';
        display 'Enter wrong run condition name';
        oldname = input(': ','s');
        display 'Enter correct run condition name';
        newname = input(': ','s');
        i = not(cellfun(@isempty,regexp(MWTfsn,oldname)));
        display(sprintf('%d files contains wrong name [%s]',...
            sum(i),oldname));
        display(sprintf('Correcting to [%s]...',newname));
        MWTrunameCorr = regexprep(MWTfsn,oldname,newname);
    
    case 'onebyone'
        %% change each name individually
        MWTrunameCorr = MWTfsn;
        for x = 1:numel(MWTfsn);
            [expath,mwtname] = fileparts(pMWTf{x});
            [~,expname] = fileparts(expath);
            disp(expname);
            disp(mwtname);
            display 'for the wrong name below'
            disp(MWTfsn{x});
            MWTrunameCorr(x,1) = {input('enter the correct name: ','s')};
        end

    case 'developer'
     %% [DEVELOP] final manual check
    %[MWTfsn] = cellfun(@MWTfnCorrect,MWTfsn,A,pExpf,'UniformOutput',0); % correct file name
    case 'choice'
        %% specific fixes
        %% Selection
        % create analysis id list
        show = {'SwitchASpecificName2Another';...
            'CorrDuplicatedNames'};
        show = sortrows(show);
        disp([num2cell((1:numel(show))') show]);
        a = input('Select fix number (press enter to abort): ');
        if isempty(a) ==1;
            return
        end
        fix = show{a};
        switch fix
            case 'SwitchASpecificName2Another'
                %% global switch
                display 'correct specific run condition to a different one';
                display 'Enter wrong run condition name';
                oldname = input(': ','s');
                display 'Enter correct run condition name';
                newname = input(': ','s');
                i = not(cellfun(@isempty,regexp(MWTfsn,oldname)));
                display(sprintf('%d files contains wrong name [%s]',...
                    sum(i),oldname));
                display(sprintf('Correcting to [%s]...',newname));
                MWTrunameCorr = regexprep(MWTfsn,oldname,newname);
            case 'CorrDuplicatedNames'
                %% change each name individually
                for x = 1:numel(MWTfsn);
                    [expath,mwtname] = fileparts(pMWTf{x});
                    [~,expname] = fileparts(expath);
                    disp(expname);
                    disp(mwtname);
                    display 'for the wrong name below'
                    disp(MWTfsn{x});
                    MWTrunameCorr(x,1) = {input('enter the correct name: ','s')};
                end
            otherwise
        end       
        
    case 'synchronize'
        [MWTrunameCorr] = synchronizeMWTnamefromsameFoldername(MWTsum);
    case 'duplicate'
        [MWTrunameCorr] = eachMWTfhaveuniqueRunname(MWTsum);
    case 'corrdate'
        [MWTrunameCorr] = corrdatefromMWTdate(MWTfn,MWTfsn);
end   

%% correct file names in computer
% match name and move file
i = find(not(cellfun(@strcmp,MWTfsn,MWTrunameCorr))); % not the same
if isempty(i) ==1;
    display('No file name corrected...');
else
for x = 1:numel(i); % for each MWTf that has differen run name
    % parse ext names
    [fn,oldpaths,~,~] = dircontent(pMWTf{i(x,1),1});
    [~,~,oldext] = filenameparse4(fn); 
    % replace old name with new name
    [newname] = cellfunexpr(oldext,MWTrunameCorr{i(x,1),1}); 
    newfilenames = cellfun(@strcat,newname,oldext,...
        'UniformOutput',0);
    % create new path
    [p] = cellfunexpr(oldext,pMWTf{i(x,1)});
    [slash] = cellfunexpr(oldext,'/');
    newpaths = cellfun(@strcat,p,slash,newfilenames,'UniformOutput',0);

    % move files 
    % [BUGFIX] double check if oldpaths and newpaths are the same
    cellfun(@movefile,oldpaths,newpaths);
    display(sprintf('%s file names corrected',MWTfn{i(x,1)}));
end
end
[pMWTf,MWTfn,MWTfsn,MWTsum,pExp] = getMWTrunamefromHomepath(Home); %% reload correct names
end





