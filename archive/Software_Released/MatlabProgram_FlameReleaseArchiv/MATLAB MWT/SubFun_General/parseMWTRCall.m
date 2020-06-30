function [c,h] = parseMWTRCall(MWTfsn)
%% function [output,outputh] = getMWTruncond(namesource, namecolumn)

%% create output headers
h = {'Full name'; 'Strain';'# worms used to sync'; 'length of sync (hr)';...
    'synchronized method'; 'worm age (h) at MWT run'; ...
    'culturing temperature'; 'preplate (s)'; 'number of taps'; 'ISI'; ...
    'time(s) > last tap'; 'tracker code';...
    'date of sync'; 'group code'; 'plate code'};

i = num2cell((1:size(h,1))');
h = cat(2,i,h);

%% get run condition parts
c = {}; % declare output cell array
for x = 1:size(MWTfsn,1);
    % find indexes
    name = MWTfsn{x,2}; % name of the MWT file
    dot = strfind(MWTfsn{x,2},'.'); % find position of dot
    under = strfind(MWTfsn{x,2},'_'); % find underline
    cross = strfind(MWTfsn{x,2},'x'); % find cross
    hour = strfind(MWTfsn{x,2},'h'); % find h
    second = strfind(MWTfsn{x,2},'s'); % find s
    
    
    % get conditions parts
    c{x,1} = MWTfsn{x,2}(1:dot-1); % full name 
    c{x,2} = MWTfsn{x,2}(1:under(1)-1); % strain
    c{x,3} = MWTfsn{x,2}(under(1)+1:cross(1)-1); % numer of worms used to sync colony
    c{x,4} = MWTfsn{x,2}(cross(1)+1:under(2)-1); % number of hours used to sync colony
    c{x,5} = MWTfsn{x,2}(under(2)+1); % code for how worms are synchronized, in lower case
    c{x,6} = MWTfsn{x,2}(under(2)+2:hour(1)-1); % age of worms in hours
    c{x,7} = MWTfsn{x,2}(hour(1)+1:under(3)-2); % culturing temperature 
    c{x,8} = MWTfsn{x,2}(under(3)+1:second(1)-1); % 5 = preplate in seconds
    c{x,9} = MWTfsn{x,2}(second(1)+1:cross(2)-1); % 6 = number of taps
    c{x,10} = MWTfsn{x,2}(cross(2)+1:second(2)-1);% 7 = ISI
    c{x,11} = MWTfsn{x,2}(second(2)+1:second(3)-1);% 8 = length of time filmed after the last tap in seconds
    c{x,12} = MWTfsn{x,2}(under(4)+1); % % B = tracker code in upper case
    c{x,13} = MWTfsn{x,2}(under(4)+2:under(4)+5); % % 9 = the date when worms were synchronized
    c{x,14} = MWTfsn{x,2}(under(4)+6); % c = group code
    c{x,15} = MWTfsn{x,2}(under(4)+7); % plate code


end

end