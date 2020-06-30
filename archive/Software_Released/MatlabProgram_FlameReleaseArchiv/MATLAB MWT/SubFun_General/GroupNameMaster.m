function [Gps] = GroupNameMaster(pExp,pSet,Version)
%% [DEVELOP] Group MWT into folders and 


%% interpret inputs

%%
switch Version
    case 'IVAuto'
     % assign IV one by one
     % process is too time consuming
    [pExpf,pMWTf,MWTfn] = getunzipMWT(pExp); 
    [MWTfsn,MWTsum] = getMWTruname(pMWTf,MWTfn);
    A = MWTfsn; % get run names

    % show expname
    [p,expname] = fileparts(pExp);% show experiment name
    display (sprintf('Currnet experiment folder name is [%s]',expname));

    % get parts of name % NM1968_12x2_l96h20C_100s30x10s10s_C0306ch.set
    [strain,~,~,runcondition,trackergroup] = ...
            parseMWTfnbyunder(MWTfsn); % parsename
    group = char(trackergroup);
    group = cellstr(group(:,6:6));

    % prepare group name
    display ' '
    display 'Proceeding to variable detection...'

    % create initial group name from strain and run condition
    [under] = cellfunexpr(strain,'_');
    groupnamelist = cellfun(@strcat,strain,under,runcondition,'UniformOutput',0);
    % create display
    b1(1:numel(groupnamelist),1) = {'['};
    b2(1:numel(groupnamelist),1) = {']'};
    groupnameshow = cellfun(@strcat,b1,group,b2,groupnamelist,'UniformOutput',0);
    % construct master
    gnmaster = [group groupnamelist groupnameshow];
    % get unique value
    groupU = unique(gnmaster(:,1));
    groupnameU = unique(gnmaster(:,2));
    groupnameShow = unique(gnmaster(:,3));
    % evaluate if more IV is needed
    moreIV = (numel(unique(groupU))/numel(groupnameU))~=1; % see how many other conditions

    % if only one variable found
    if moreIV ~=1;
        display 'Only variable found is strain'
        display 'Group name assigned as below';
        display(unique(groupnameshow));
        CHECK = input('Correct (y=1,n=0)? ');
        if CHECK ==0;
            save('GroupNameProblem.mat','CHECK','gnmaster','groupnameU');

        end
    end

    while moreIV ==1;  
        % display instruction
        display ' '
        display 'Adding independent variables(IV) to group name one at a time...';
        display '1) enter the name of the IV (i.e. ethanol, food)';
        display '2) enter the names of the IV variables separated by [space]';
        display '   *DO NOT enter control variable, such as 0mM*';
        display '   i.e. for ethanol (IV), enter variable names as 400mM';
        % show previous group.mat
        cd(pExp)
        [fn,pf] = dircontentext(pExp,'Groups*');
        if exist(fn{1},'file')==2;
            A = load(fn{1});
            if exist('Groups','var')==1;
                display ' ';
                display 'Previous group file says...';
                disp(Groups);
            else
                display ' ';
                display 'No previous group file found...';
            end
        end
        % show current group names
        display 'Current group name assignment:'
        display(unique(groupnameshow));

        % add other conditions to name
        display ' ';
        display 'Enter the name of an experimental condition (i.e. ethanol)';
        IV = {};
        IV{1,1} = input(': ','s'); % ask for condition name (i.e. ethanol) - loop
        display 'Enter the names of the IV variables separated by [space]';
        IVvar = {};
        IVvar(1,:) = regexp(input(': ','s'),' ','split');
        % prmopt to add IVvar to group name
        disp(groupnameShow);
            for x = 1:numel(IVvar)
            display 'Enter all group codes separated y [space]';
            display(sprintf('that belongs to [%s] group',IVvar{x}));
            g = regexp(input(': ', 's'),' ','split'); % find group code to be added the IVvar
            for y = 1:numel(g) 
                i = not(cellfun(@isempty,regexp(gnmaster(:,1),g{y}))); % find group code in master list 
                % add name
                k = find(i); % find number to change
                [underscore] = cellfunexpr(k,'_');
                [newVar] = cellfunexpr(k,IVvar{x});
                gnmaster(i,2) = cellfun(@strcat,gnmaster(i,2),underscore,newVar,'UniformOutput',0); % addIVvar
            end
            end
        % renew group name master
        % re-create groupnameshow
        b1(1:numel(groupnamelist),1) = {'['};
        b2(1:numel(groupnamelist),1) = {']'};
        groupnameshow = cellfun(@strcat,b1,group,b2,gnmaster(:,2),'UniformOutput',0);
        % re-construct master
        gnmaster = [group gnmaster(:,2) groupnameshow];
        % get unique value
        groupU = unique(gnmaster(:,1));
        groupnameU = unique(gnmaster(:,2));
        % evaluate if more IV is needed
        moreIV = (numel(unique(groupU))/numel(groupnameU))~=1;  % see how many other conditions
    end
    
    % save
    cd(pExp);
    save('GroupName.mat','groupnameU','gnmaster','IV','IVvar');
    display 'GroupName.mat saved.... '
    
    % output 
    Gps.groupnameU = groupnameU;
    Gps.gnmaster = gnmaster;
    
    case 'OneByOne'
        display 'GroupName assignment begins';
        Gps = {};
        [Gps] = groupnameonebyone(pExp,pSet);
    case 'groupnameEnter'
        display 'GroupName assignment begins';
        Gps = {};
        [Groups] = groupnameEnter(pExp,pSet);
        Gps = Groups;
    case 'makeMWTfgcode'
        display 'Making MWTfgcode';
        [MWTfgcode] = makeMWTfgcode(pExp);
        Gps = MWTfgcode;
    case 'GraphGroupSequence'
        [GAA] = assigngroupsequence(pExp);
        Gps = GAA;

end
if isempty(Gps)==1;
    display 'No Group output set';
end

