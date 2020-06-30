function [RCpartcorr] = correctSpecificMWTRunCode2(RCpart,pExp,ID)
% [n] = correctSpecificMWTRunCode(name) 
% works with [n] = getRunCon
%% Create MWT run code change header
h = {'Full name'; 'Strain';'# worms used to sync'; 'length of sync (hr)';...
    'synchronized method'; 'worm age (h) at MWT run'; ...
    'culturing temperature'; 'preplate (s)'; 'number of taps'; 'ISI'; ...
    'time(s) > last tap'; 'tracker code';...
    'date of sync'; 'group code'; 'plate code'};

i = num2cell((1:size(h,1))');
parseheader = cat(2,i,h);
                
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
display('file correction begins...');

%% correct files
[MWTfull] = getallMWTfiles(pExp); % get all files
% find what's different
diff = cellfun(@strcmp,RCpart(:,1),RCpartcorr(:,1),'UniformOutput',0);
for x = find(eq(cell2mat(diff),0));   
    [parsefilename] = filenameparse3(MWTfull{x,2}); % parse ext names
    newname = {};
    newname(1:size(parsefilename,1),1) = RCpartcorr(x,1);
    MWTfull{x,2} = cellfun(@strcat,newname,parsefilename(:,2),'UniformOutput',0);
    slash(1:size(MWTfull{x,2},1),1) = {'/'};
    [pH,~] = fileparts(MWTfull{x,3}{1,1});
    pMWT(1:size(MWTfull{x,2},1),1) = {pH};
    MWTfull{x,4} = cellfun(@strcat,pMWT,slash,MWTfull{x,2},'UniformOutput',0);
    cellfun(@movefile,MWTfull{x,3},MWTfull{x,4});
    display(sprintf('%s file names corrected',MWTfull{x,1}));
end
display('file correction finished.');

end
