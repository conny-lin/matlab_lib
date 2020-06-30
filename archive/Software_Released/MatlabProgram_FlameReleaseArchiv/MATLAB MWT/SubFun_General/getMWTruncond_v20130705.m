function [c,h] = getMWTruncond_v20130705(n, nc)
% function [output,outputh] = getMWTruncond(namesource, namecolumn)
% Conny Lin, start: 2013 July 5
% Published: ____________
% 
% The stadnard MWT code: A_1x2_a3h4C_5sx6x7s8s_B9cd
% A = Strain name is upper case letter followed by numbers
% 1 = numer of worms used to sync colony
% 2 = number of hours used to sync colony
% a = code for how worms are synchronized, in lower case
% 3 = age of worms in hours
% 4 = culturing temperature 
% 5 = preplate in seconds
% 6 = number of taps
% 7 = ISI
% 8 = length of time filmed after the last tap in seconds
% B = tracker code in upper case
% 9 = the date when worms were synchronized
% c = group code
% d = plate code
% 
% Input:
%  expname = cell array with names stored in column <namecolumn>
%
% Example:
%  expname{1,1} = 'N2_5x3_t96h20C_100s30x10s10s_C0109aa.set';
%  namecolumn = 1;
% 
% output:
%    [ 1]    'MWT file name'       
%    [ 2]    'group code'          
%    [ 3]    'group-plate code'    
%    [ 4]    'strain'              
%    [ 5]    'tracker'      
%    [ 6]    'N of starting colony'
%    [ 7]    'N of hours synched'  
%    [ 8]    'transfer method'     
%    [ 9]    'age'                 
%    [10]    'temp' 
%    
% 
% CL modified 20130703, finished: 20130703



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
for x = 1:size(n,1);
    % find indexes
    name = n{x,nc}; % name of the MWT file
    dot = strfind(n{x,nc},'.'); % find position of dot
    under = strfind(n{x,nc},'_'); % find underline
    cross = strfind(n{x,nc},'x'); % find cross
    hour = strfind(n{x,nc},'h'); % find h
    second = strfind(n{x,nc},'s'); % find s
    
    
    % get conditions parts
    c{x,1} = n{x,nc}(1:dot-1); % full name 
    c{x,2} = n{x,nc}(1:under(1)-1); % strain
    c{x,3} = n{x,nc}(under(1)+1:cross(1)-1); % numer of worms used to sync colony
    c{x,4} = n{x,nc}(cross(1)+1:under(2)-1); % number of hours used to sync colony
    c{x,5} = n{x,nc}(under(2)+1); % code for how worms are synchronized, in lower case
    c{x,6} = n{x,nc}(under(2)+2:hour(1)-1); % age of worms in hours
    c{x,7} = n{x,nc}(hour(1)+1:under(3)-2); % culturing temperature 
    c{x,8} = n{x,nc}(under(3)+1:second(1)-1); % 5 = preplate in seconds
    c{x,9} = n{x,nc}(second(1)+1:cross(2)-1); % 6 = number of taps
    c{x,10} = n{x,nc}(cross(2)+1:second(2)-1);% 7 = ISI
    c{x,11} = n{x,nc}(second(2)+1:second(3)-1);% 8 = length of time filmed after the last tap in seconds
    c{x,12} = n{x,nc}(under(4)+1); % % B = tracker code in upper case
    c{x,13} = n{x,nc}(under(4)+2:under(4)+5); % % 9 = the date when worms were synchronized
    c{x,14} = n{x,nc}(under(4)+6); % c = group code
    c{x,15} = n{x,nc}(under(4)+7); % plate code


end

end