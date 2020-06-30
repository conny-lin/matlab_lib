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