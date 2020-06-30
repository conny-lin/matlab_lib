function correctMWTnamebyparts(MWTfsn,pExp)
display(' ');
disp('Running MWT naming user validation...');
display(' ');
[RCpart,~,~] = parseMWTRCnameall(MWTfsn); % parse and validate MWTf name parts
displayallMWTfrunname2(MWTfsn); % display all experiment names
q1 = input('Are all MWTf named correctly? (y=1,n=0) ');
if q1 ==0;
    display(' ');
    [parseheader] = createheader; % create selection manual 
    [RCpartcorr] = correctnameuserinput(RCpart,parseheader);  % change from seleciton
    MWTfsncorr = cat(2,MWTfsn(:,1),RCpartcorr(:,1)); % reasemable
    displayallMWTfrunname2(MWTfsncorr); % display corrected
    q1 = input('Are all MWTf named correctly? (y=1,n=0) ');    
else 
MWTfsncorr = MWTfsn;
end    
changeMWTname(pExp,MWTfsn,MWTfsncorr); % correct files
end


function [parseheader] = createheader
%% Create MWT run code change header
h = {'Full name'; 'Strain';'# worms used to sync'; 'length of sync (hr)';...
'synchronized method'; 'worm age (h) at MWT run'; ...
'culturing temperature'; 'preplate (s)'; 'number of taps'; 'ISI'; ...
'time(s) > last tap'; 'tracker code';...
'date of sync'; 'group code'; 'plate code'};

i = num2cell((1:size(h,1))');
parseheader = cat(2,i,h);
end

function [RCpartcorr] = correctnameuserinput(RCpart,parseheader)
%% correct name
RCpartcorr = RCpart;
disp('');
for x = 1:size(RCpart,1);
    disp('');
    disp(sprintf('for MWT experiment %s...',RCpart{x,16}));
    name = {};
    name = RCpart(x,:); % pull out old name
    disp(sprintf('the MWT run name is %s',name{1,1}));
    switch ID
        case 0 % don't know if there is error  
            q0 = input('is this correct? (y=1,n=0) ');
        case 1 % error is known
            q0 = 0;
    end
    while q0 == 0;
        disp(parseheader);
        disp(sprintf('MWT experiment: %s',RCpart{x,16}));
        disp(sprintf('MWT current run name: %s',name{1,1}));
        q1 = input('Which part do you want to fix? ');  
        name{1,q1} = input(sprintf('Enter correct %s: ',parseheader{q1,2}),'s'); 
        [name] = reasembleMWTRCnameAll(name);
        Reparse = cat(2,RCpart{x,16},name);
        [name,~,~] = parseMWTRCnameall(Reparse);
        display(' ');
        disp(name{1,1});
        q0 = input('Is this correct (1=yes, 0=no or more to correct)? ');
        RCpartcorr(x,:) = name;
    end
end

end
