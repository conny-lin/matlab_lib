function validateMWTname 
%% [development...validateMWTname] validate names
%% if "_" is not correct
% correct format: N2_5x3_t90h20C_100s30x10s10s_C1029aa
% should have 4 _
% first letter should be Capital letter
% after first _ should be a number
% before second _ should be a number
% after second _ should be a letter
% after 2nd _, and firt h, should be number
% after first h, and first C, should be 2 digit number
% after third_ should be a number
% after first s, and first x, should be a number
% after first x, and second s, should be a number
% between second s and one letter before 4th _ , should be a number
% before 4th_ should be a letter 
% after 4th _ should be a capital letter
% one letter after 4th_ should be 4 digit number
% after 5 digit number should be 2 lower case letter

undernumber = [];
pass = [];
for x = 1:size(MWTfsn,1);
    t = size(strfind(MWTfsn{x,2},'_'),2); % find underline
    while isequal(t,4) ==0;
        q1 = 0;
        display('MWT components incorrect...');
        display('Naming should be in the format like ''N2_5x3_t90h20C_100s30x10s10s_C1029ca''');
        disp('');
        while q1 ==0;
            disp(sprintf('for MWT experiment %s...',MWTfsn{x,1}));
            disp('The incorrect name is...');
            disp(MWTfsn{x,2});
            n = MWTfsn(x,2); % pull out old name
            n{1,2} = input('Enter correct full name: ','s'); 
            q1 = input ('Is this correct (y=1,n=0)? ');
        end
        MWTfsn(x,2) = n(1,2);
        t = size(strfind(MWTfsn{x,2},'_'),2); 
    end
end


%% validate names of single MWT run name (name)
% correct format: N2_5x3_t90h20C_100s30x10s10s_C1029aa
%% TEST code
name = MWTfsn{1,2};
correct = 'NM1968_5x3_t90h20C_100s30x10s10s_C1029aa';
%%
% correct format: NM12_5x3_t90h20C_100s30x10s10s_C1029aa
capitalsingle = '[A-Z]';
capital = '[A-Z]';
number = '\d';
under = '[_]';
cross = '[x]';
dot = '[.]';
any,'*';
singlelowercase = '[a-z]';  
%%
%[matchstart,matchend,tokenindices,matchstring,tokenstring,tokenname,...
 %   splitstring] = regexp(test,expr)

%% get name
expr = strcat(dot); 
[matchstart,matchend,~,matchstring,~,~,splitstring] = regexp(name,expr);
name = splitstring{1};

%% should have 4 _
test =  name;
expr = strcat(under); 
[matchstart,matchend,~,matchstring,~,~,splitstring] = regexp(test,expr);
testresult = splitstring
[matchstart,matchend,~,matchstring,~,~,splitstring] = regexp(correct,expr);
correctresult = splitstring
if size(testresult,1)~=5;
    display('underscore number incorrect, consider full name change...');
else
    display('underline number correct, next');
end

%% first letter should be capital
test1 = testresult{1,1};
corr1 = correctresult{1,1};
expr = strcat(number); 
[matchstart,matchend,~,matchstring,~,~,splitstring] = regexp(test1,expr);
testresult = splitstring
[matchstart,matchend,~,matchstring,~,~,splitstring] = regexp(corr1,expr);
correctresult = splitstring

%% after first _ should be a number

% before second _ should be a number
% after second _ should be a letter
% after 2nd _, and firt h, should be number
% after first h, and first C, should be 2 digit number
% after third_ should be a number
% after first s, and first x, should be a number
% after first x, and second s, should be a number
% between second s and one letter before 4th _ , should be a number
% before 4th_ should be a letter 
% after 4th _ should be a capital letter
% one letter after 4th_ should be 4 digit number
% after 5 digit number should be 2 lower case letter

%%
     % find underline
    while isequal(t,4) ==0;
        q1 = 0;
        display('MWT components incorrect...');
        display('Naming should be in the format like ''N2_5x3_t90h20C_100s30x10s10s_C1029ca''');
        disp('');
        while q1 ==0;
            disp(sprintf('for MWT experiment %s...',MWTfsn{x,1}));
            disp(sprintf('The incorrect name is %s...',MWTfsn{x,2}));
            n = MWTfsn(x,2); % pull out old name
            n{1,2} = input('Enter correct full name: ','s'); 
            q1 = input ('Is this correct (y=1,n=0)? ');
        end
        MWTfsn{x,2} = n(1,2);
        t = size(strfind(MWTfsn{x,2},'_'),2); 
    end
end



%% get run condition parts
c = {}; % declare output cell array
for x = 1:size(n,1);
    
    name = name; % name of the MWT file
    dot = strfind(name,'.'); % find position of dot
    under = strfind(name,'_'); % find underline
    cross = strfind(name,'x'); % find cross
    hour = strfind(name,'h'); % find h
    second = strfind(name,'s'); % find s
    
    
    % get conditions parts
    c{x,1} = name(1:dot-1); % full name 
    c{x,2} = name(1:under(1)-1); % strain
    c{x,3} = name(under(1)+1:cross(1)-1); % numer of worms used to sync colony
    c{x,4} = name(cross(1)+1:under(2)-1); % number of hours used to sync colony
    c{x,5} = name(under(2)+1); % code for how worms are synchronized, in lower case
    c{x,6} = name(under(2)+2:hour(1)-1); % age of worms in hours
    c{x,7} = name(hour(1)+1:under(3)-2); % culturing temperature 
    c{x,8} = name(under(3)+1:second(1)-1); % 5 = preplate in seconds
    c{x,9} = name(second(1)+1:cross(2)-1); % 6 = number of taps
    c{x,10} = name(cross(2)+1:second(2)-1);% 7 = ISI
    c{x,11} = name(second(2)+1:second(3)-1);% 8 = length of time filmed after the last tap in seconds
    c{x,12} = name(under(4)+1); % % B = tracker code in upper case
    c{x,13} = name(under(4)+2:under(4)+5); % % 9 = the date when worms were synchronized
    c{x,14} = name(under(4)+6); % c = group code
    c{x,15} = name(under(4)+7); % plate code


end