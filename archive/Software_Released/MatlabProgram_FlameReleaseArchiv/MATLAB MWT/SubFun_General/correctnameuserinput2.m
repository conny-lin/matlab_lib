function [MWTfsncorr] = correctnameuserinput2(MWTfsn)
%% correct name
disp('');
ID = 0;
displayallMWTfrunname2(MWTfsn);
for x = 1:size(MWTfsn,1);
    disp('');
    name = {};
    name = RCpart(x,:); % pull out old name
    disp(sprintf('the original name is %s ',name{1,1}));
    switch ID
        case 0 % don't know if there is error  
            q0 = input('is this correct? (y=1,n=0) ');
        case 1 % error is known
            q0 = 0;
    end
    while q0 == 0;
        disp(sprintf('MWT experiment: %s',RCpart{x,1}));
        disp(sprintf('MWT current run name: %s',name{1,1}));
        MWTfsn = input('enter? ');

        q0 = input('Is this correct (1=yes, 0=no or more to correct)? ');
        RCpartcorr(x,:) = name;
    end
end

end