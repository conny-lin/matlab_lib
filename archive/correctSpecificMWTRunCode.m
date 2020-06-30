function [n] = correctSpecificMWTRunCode(MWTfsn)
% [n] = correctSpecificMWTRunCode(name) 
% works with [n] = getRunCon


%% create headers
h = {'full name'; 'Strain';'# worms used to sync'; 'length of sync (hr)';...
    'Synchronize code'; 'Age of worms (hh)'; ...
    'culturing temperature'; 'preplate (s)'; 'number of taps'; 'ISI'; ...
    'time(s) > last tap'; 'tracker code';...
    'date of sync'; 'group code'; 'plate code'};
i = num2cell((1:size(h,1))');
h = cat(2,i,h);

%% correct name
n = MWTfsn(1,:);
q2 = 0;
disp(h)
disp('');
disp(sprintf('for MWT experiment %s...',MWTfsn{1,1}));
while q2 == 0;
    q1 = input('Which of the above code do you want to fix? ');   
    if q1 == 1; % if full name is changed
        n{1,q1} = input(sprintf('Enter correct %s: ',h{q1,2}),'s');
        n = getMWTruncond_v20130705(n,1); % parse out names
    else
        n{1,q1} = input(sprintf('Enter correct %s: ',h{q1,2}),'s');     
    end
    n{1,1} = strcat(n{1,2},'_',n{1,3},'x',n{1,4},'_',n{1,5},n{1,6},...
                'h', n{1,7},'C_', n{1,8},n{1,9},'s',n{1,10},'x',n{1,11},...
                's',n{1,12},'s_',n{1,13},n{1,14},n{1,15},n{1,16});
    display(' ');
    disp(n{1,1})
    q2 = input('Is this correct (1=yes, 0=no)? ');
end
display(sprintf('name is corrected to... \n%s',n{1,1}));
end
