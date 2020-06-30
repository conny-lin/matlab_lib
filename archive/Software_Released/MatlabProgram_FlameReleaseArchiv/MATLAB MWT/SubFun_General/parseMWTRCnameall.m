function [RCpart,MWTfname,h] = parseMWTRCnameall(MWTfsn)
%% [c,h] = parseMWTRCall(MWTfsn)
%% create output headers
h = {'Full name'; 'Strain';'# worms used to sync'; 'length of sync (hr)';...
    'synchronized method'; 'worm age (h) at MWT run'; ...
    'culturing temperature'; 'preplate (s)'; 'number of taps'; 'ISI'; ...
    'time(s) > last tap'; 'tracker code';...
    'date of sync'; 'group code'; 'plate code'};
i = num2cell((1:size(h,1))');
h = cat(2,i,h);

%% get run condition parts
display('Parsing MWT run names...');
RCpart = {}; % declare output cell array
for x = 1:size(MWTfsn,1);
    % get name
    display(sprintf('parsing [%s]%s',MWTfsn{x,1},MWTfsn{x,2}));
    MWTfname{x,1} = MWTfsn{x,1}; % MWT folder name
    name = MWTfsn{x,2}; % get name of the MWT file
    
    % find indexes
    [under] = regexp(name,'_','start'); % find underline
    [cross] = regexp(name,'x','start');
    [hour] = regexp(name,'h','start');
    [second] = regexp(name,'s','start');
        
    %% validate and record entries
    % full name structure
    [fullname,P] = validateMWTfullnameunder(name,under);
    RCpart{x,1} = fullname;
    
    %% Part I: strain name
    % strain
    [strain] = validatestrainname(name,under); % strain name: capital letters + numeric identifier
    RCpart{x,2} = strain; % record strain name  
    
    %% Part II: synchronization colony
    syncol(1:size(MWTfsn(:,2)),1) = {'_*\dx\d*_'};
    [~,~,~,m,~,~,~] = cellfun(@regexp,MWTfsn(:,2),syncol,'UniformOutput',0);
    undercell = {};
    undercell(1:size(MWTfsn(:,2)),1) = {'_'};
    blank = {};
    blank(1:size(MWTfsn(:,2)),1) = {''};
    a = cellfun(@regexprep,m,undercell,blank,'UniformOutput',0);
    % number of worms used to sync colony (WSn)
    WSn = name(under(1)+1:cross(1)-1);
    [WSn] = validatenamenumeric(WSn,...
        '''# of Worm used to sync(WSn)'' is not numeric');
    RCpart{x,3} = WSn; % numer of worms used to sync colony
    % number of hours used to sync colony (HS)
    HS = name(cross(1)+1:under(2)-1);
    [HS] = validatenamenumeric(HS,...
        '''# of hours used to sync(HS)'' is not numeric');
    RCpart{x,4} = HS; % numer of worms used to sync colony
    
    %% Part III: synch and growth condition
    % compare to syn method code
    %% [DEVELOPMENT] code for how worms are synchronized [MS] in lower case
    MS = name(under(2)+1);
    [MS] = validateletter(MS,1,...
        'Method of sync is not %d letter');
    RCpart{x,5} = MS;
    % age of worms in hours
    WAge = name(under(2)+2:hour(1)-1);
    [WAge] = validatenamenumeric(WAge,...
        '''# of hours used to sync(HS)'' is not numeric'); 
    RCpart{x,6} = WAge; % age of worms in hours
    % culturing temperature 
    temp = name(hour(1)+1:under(3)-2);
    [temp] = validatenamenumeric(temp,...
        '''syn temp'' is not numeric'); 
    RCpart{x,7} = temp; % culturing temperature 
    % preplate in seconds
    preplate = name(under(3)+1:second(1)-1);
    [preplate] = validatenamenumeric(preplate,...
        'preplate is not numeric'); 
    RCpart{x,8} = preplate; 
    % number of taps
    tap = name(second(1)+1:cross(2)-1);
    [tap] = validatenamenumeric(tap,...
        'tap is not numeric'); 
    RCpart{x,9} = tap;
    % ISI  
    ISI = name(cross(2)+1:second(2)-1);% 7 = ISI
    [ISI] = validatenamenumeric(ISI,...
        'ISI is not numeric'); 
    RCpart{x,10} = ISI;% 7 = ISI
    % length of time filmed after the last tap in seconds or unconventional
    % code
    %% [development] experiment list
    expspecialcon = name(second(2)+1:second(3));
    [i] = regexp(expspecialcon,'[a-z]','start');
    expspecialconN = expspecialcon(1:i(1)-1);
    [expspecialconN] = validatenamenumeric(expspecialconN,...
        'expspecialconN is not numeric'); 
    expspecialconL = expspecialcon(i(1):end);
    [p] = regexp(expspecialconL,'[s]','start');
    if isempty(p) ==1;
        warning('coding needed for special exp run condition cases');
        [expspecialconL] = validateletter(expspecialconL,1,...
        'expspecialconLis not %d letter');      
    end
    RCpart{x,11} = expspecialcon;
    
    %% Final part: Tracker-expdate-group-plate
    % tracker code in upper case
    Tracker = name(under(4)+1); 
    Tracker = regexp(Tracker,'[A-Z]','match');
    RCpart(x,12) = Tracker; 
    % date when worms were synchronized
    Sdate = name(under(4)+2:under(4)+5);
    [Sdate] = regexp(Sdate,'\d\d\d\d','match'); 
    if isempty(Sdate)~=1;
        RCpart(x,13) = Sdate; 
    else
        RCpart{x,13} = [];
    end
    % group code
    g = name(under(4)+6);
    [g] = validateletter(g,1,...
        'group code is not %d letter');
    RCpart{x,14} = g; % c = group code
    % plate code
    plate = name(under(4)+7); % plate code
    [plate] = validateletter(plate,1,...
        'plate is not %d letter');
    RCpart{x,15} = plate; % plate code
    RCpart{x,16} = MWTfsn{x,1}; % code folder name

end
display('Parsing validation successful.');

end