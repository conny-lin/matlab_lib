function [chorscript] = chormaster(path,option)

%% STEP2: SET UP PATHS
%  
pBet = '/Users/connylinlin/Documents/Java_Programs/Beethoven_v2.jar';
% call chor 
pChor = '''/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar''';

%% java arguments ---------------------------------------------------------
b = blanks(1);
% call java 
javacall = 'java -jar'; javaRAM = '-Xmx8G'; javaRAM7G = '-Xmx7G';
% call beethoven 
beethoven = ''pBet'';
% call chor 
chor = '''/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar''';
% chor calls 
map = '--map';
% settings 
pixelsize = '-p 0.027'; speed = '-s 0.1'; 
mintime = '-t 20'; minmove = '-M 2'; shape = '--shadowless -S';
% dat output 
odrunkposture = '-O drunkposture -o nNslwakb';
oconny = '-o 1nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d'; % Conny's 
obeethoven = '-o nNss*b12M'; % standard for Beethoven
oshanespark = '-O shanespark -o nNss*b12M'; % standard for Beethoven
oevan = '-O evan -o nNss*b12'; % Evan's dat output
oevanall = '-O evanall -N all -o nNss*b12';
% plugins 
preoutline = '--plugin Reoutline::exp';  
prespine = '--plugin Respine';
% plugins (reversals) 
revbeethoven_trv = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';
revignortap_sprevs = '--plugin MeasureReversal::postfix=sprevs';
rev_ssr = '--plugin MeasureReversal::tap::collect=0.5::postfix=ssr';



    
%%  [update as you add more options] chor options list

AnaList = '(LadyGaGa)|(ShaneSpark)|(Beethoven)|(DrunkPosture)|(Rastor)';
Chor = char(regexp(option,AnaList,'match'));
if isempty(Chor)==1; % if no match, select options
    % create display list
    select = sortrows(AnaList);
    [b1] = cellfunexpr(AnaList,'['); [b2] = cellfunexpr(AnaList,']');
    num = cellstr(num2str((1:numel(AnaList))'));
    display(char(cellfun(@strcat,b1,num,b2,select,'UniformOutput',0)));
    % ask for analysis id
    display ' '; answer = input('Select analysis or [Enter] to abort: ');
    if isempty(answer)==1; return; end
    Chor = select{answer};
end

%% create java syntax --------------------------------------------------
switch Chor
    case 'LadyGaGa'
    chorscript = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,mintime,...
        b,minmove,b,shape,b,oevan,b,preoutline,b,prespine,b,...
        revignortap_sprevs,b];
    case 'DrunkPosture'
    chorscript = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,mintime,...
        b,minmove,b,shape,b,oevan,b,odrunkposture,b,preoutline,b,prespine,b];
    case 'ShaneSpark'
    chorscript = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,mintime,...
        b,minmove,b,shape,b,oshanespark,b,preoutline,b,prespine,b,...
        revbeethoven_trv,b];
    case 'Beethoven'
    chorscript = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,mintime,...
        b,minmove,b,shape,b,obeethoven,b,preoutline,b,prespine,b,...
        revbeethoven_trv,b];
    case 'Rastor'
    chorscript = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,mintime,...
        b,minmove,b,shape,b,oevanall,b,preoutline,b,prespine,b];
end

%% eval input path & run chor
str = 'Chor-ing MWTfile [%s]...';

if size(path,1)>1 && iscell(path)==1;
    if isempty(regexp(path{1},'\<(\d{8})[_](\d{6})\>','once'))==0;
        i = not(cellfun(@isempty,regexp(path,'\<(\d{8})[_](\d{6})\>')));
        k = find(i);
        for x = 1:sum(i); 
            [~,fn] = fileparts(path{k(x)});
            file = strcat('''',path{k(x)},''''); 
            display(sprintf(str,fn));
            system([chorscript file], '-echo');       
        end
        
    % if input is a list of exp folder    
    elseif isempty(regexp(path{1},'\<(\d{8})[_](\d{6})\>','once'))==1;
        for x = 1:size(path,1); 
            [~,pMWT] = dircontentmwt(path{x});
            for y = 1:numel(pMWT)
            [~,fn] = fileparts(pMWT{y});
            file = strcat('''',pMWT{x},''''); 
            display(sprintf(str,fn));
            system([chorscript file], '-echo');       
            end
        end
        
    else display('Path input not recognized...');

    end


% if input is a MWT folder
elseif ischar(path)==1 && size(path,1)==1 && isempty(regexp(path,'\<(\d{8})[_](\d{6})\>','once'))==0;
        file = strcat('''',path{1},''''); 
        display(sprintf(str,fn));
        system([chorscript file], '-echo');

% if input might be a home foler to Exp folders    
elseif ischar(path) ==1 && isempty(regexp(path,'(\d{8})[_](\d{6})','once'))==1 && ...
        size(path,1)==1;
    [~,~,~,~,pMWTf,fn,~] = getMWTpathsNname(path,'noshow');
    i = not(cellfun(@isempty,regexp(fn,'\<(\d{8})[_](\d{6})\>')));
    k = find(i);
    for x = 1:sum(i); 
        [~,fn] = fileparts(pMWTf{k(x)});
        file = strcat('''',pMWTf{k(x)},''''); 
        display(sprintf(str,fn));
        system([chorscript file], '-echo');       
    end
else
    display('Path input not recognized...');
end

display 'Chor Finished using script:';
disp(chorscript);
end

%% helpfiles
% Options: 
%   -?  --help               This message (use -? output for help on output type) 
%       --body-length-units  Speeds are in units of body lengths (default is mm) 
%       --from               Time from which to read data (in seconds, default 0) 
%       --graph              Bring up GUI to graph population data 
%       --header             Write tab-delimited description of each data column 
%   -I (--interactive)       Bring up GUI (same as --graph) 
%       --in                 Only use data points inside specified shape 
%       --ignore-outside-triggers   Ignore all data except near explicit triggers 
%   -m (--minimum-move-mm)   How far an object must move (in mm) to count 
%   -M (--minimum-move-body)   (same thing, except unit is object-lengths) 
%       --minimum-biased     If object travels this far, it's mostly forwards 
%       --map                Use GUI to display the data as a browsable map 
%   -n (--id)                Only use listed object IDs (use commas: -n 1,5,22) 
%   -N (--each-id)           Write one output file for each ID listed 
%       --no-output          Don't write any output 
%       --no-repeat          Remove any frames that appear to be repeated 
%       --out                Data must be outside specified shape. 
%   -o (--output)            Write specified output data (-? output for syntax) 
%   -O (--output-name)       Add an identifier to output 
%   -p (--pixelsize)         Size of one pixel, in mm 
%       --plugin             Use plugin; --plugin help gives generic help 
%       --prefix             Specify data file prefix explicitly 
%   -q (--quiet)             Don't print progress information to console 
%   -s (--speed-window)      Time window (in seconds) to average velocity 
%   -S (--segment)           Shape analysis of path: lines, arcs, etc. 
%       --shadowless         Only count objects after they move a body length 
%       --skip-zeros         Omit timepoints with zero objects found 
%       --spine-from-outline (Re)compute spine more robustly given outline 
%   -t (--minimum-time)      How long an object must last (in seconds) to count 
%   -T (--output-rate)       Time between output data points (in seconds) 
%       --to                 Time after which to ignore data (in seconds) 
%       --target             Place all output in specified directory (must exist) 
%       --trigger            Report a stimulus-triggered average to .trig file 
%       --trig-only          Only write triggered averages, not regular output 
%       --who                Print out object ID numbers that pass criteria 
% Format: 
%   directory must contain a MWT .summary file 
%   A .zip file containing the data can be specified instead of the directory. 
%     The corresponding directory will be created for output purposes. 
%   -m,M,p,s,t,--from,--to expect a floating-point value as an argument 
%   -O name turns output from prefix.dat to prefix.name.dat 
%     If only one -O is given, it will change the .pos file name also. 
%     If multiple -O's are given, only .dat files are changed, and there must be 
%       the same number of -o's and -O's (and will correspond in order) 
%   --trigger is followed by the duration of the averaging window (in seconds), 
%     a comma, and then comma-separated list containing either the time at which 
%     to trigger or the tap, puff, stim3, or stim4 keywords followed by a colon, 
%     the time before to take a measurement, a colon, and the time after to 
%     take a measurement.  (Numbers may be left blank; colons are required.) 
%     Multiple trigger statements are okay (each adds more columns to the file). 
%   -n or --id can be entered multiple times, and/or can contain multiple id 
%     numbers; all IDs are accumulated.  Numbers must be separated by commas 
%     with no spaces.  IDs that do not exist or fail criteria are excluded. 
%     The -N or --each-id variant appends a five-digit object ID number to 
%     the prefix, and creates one set of files for each object. 
%     -N all means output separately every object meeting the criteria. 
%     -n and -N are not compatible.  Use only one. 
%   --in and --out should be followed by either a center and radius (circle) 
%     as x,y,r, or two corners of a rectangle as x1,y1,x2,y2. 
% Examples: 
%   --trigger 1.0,5,tap:0.25:0.5,750 will average from 5-6 s after 
%     the start of recording, from 1.25 to 0.25 s before each tap, from 0.5 s 
%     to 1.5 s after each tap, and once more from 750-751 s. 
%   --trigger 0.2,tap::0.2 will average from 0.2 to 0.4 seconds after each tap 
%   --trigger 0.5,tap:0: will average from 0.5s before to 0 s before each tap 
%   --in 1,1,100,50 --out 25,25,5 would only take data from an elongated 
%     rectangle with a hole missing from its left side. 
% crankin@Leviathan:~$ java -Xmx1500m -jar '/home/crankin/Desktop/Chore_1.3.0.r1035.jar' --help -? output 
% Choreography 1.3.0 build 1035 
% Usage:  java Choreography [options] directory 
%      or java -jar Chore.jar [options] directory 
% Format: 
%   -o requires an argument specifying columns (separate long form with commas) 
%     t time -- always the first column unless included again 
%     f frame -- the frame number 
%     D id -- the object ID 
%     n number -- the number of objects tracked 
%     N goodnumber -- the number of objects passing the criteria given 
%     p persistence -- length of time object is tracked 
%     e area 
%     s speed 
%     S angular -- angular speed 
%     l length -- measured along major axis, not curve of object 
%     L rellength -- instantaneous length/average length 
%     w width 
%     W relwidth -- instantaneous width/average width 
%     a aspect -- length/width 
%     A relaspect -- instantaneous aspect/average aspect 
%     m midline -- length measured along the curve of object 
%     M morphwidth -- mean width of body about midline 
%     k kink -- head/tail angle difference from body (in degrees) 
%     b bias -- fractional excess of time spent moving one way 
%     P pathlen -- distance traveled forwards (backwards=negative) 
%     c curve -- average angle (in degrees) between body split into 5 segments 
%     d dir -- consistency of direction of motion 
%     x loc_x -- x coordinate of object (mm) 
%     y loc_y -- y coordinate of object (mm) 
%     u vel_x -- x velocity (mm/sec) 
%     v vel_y -- y velocity (mm/sec) 
%     o orient -- orientation of body (degrees, only guaranteed modulo pi) 
%     r crab -- speed perpendicular to body orientation 
%     C custom -- calls plugin 
%     1 tap -- whether a tap (stimulus 1) has occurred 
%     2 puff -- whether a puff (stimulus 2) has occurred 
%     3 stim3 -- whether the first custom stimulus has occurred 
%     4 stim4 -- whether the second custom stimulus has occurred. 
%       all -- same as ftnNpsSlLwWaAmkbcd1234 
%   The output items can be followed by the statistic to report 
%     (default is to output the mean) 
%     ^ :max -- maximum value 
%     _ :min -- minimum value 
%     # :number -- number of items considered in this statistic 
%     - :median -- median value 
%     * :std -- standard deviation 
%       :sem -- standard error 
%       :var -- variance 
%     ? :exists -- 1 if the value exists, 0 otherwise 
%       :p25 -- 25th percentile 
%       :p75 -- 75th percentile 
%       :jitter -- estimate of measurement precision 
%   Long format items need at least one comma (add trailing comma if needed) 
% Examples: 
%   -o a_ and -o aspect:min, are the same thing 
%   -o fnww* and -o frame,number,width,width:std also are the same 
%   -o xy will give positions (useful in conjunction with -N option) 
%   -o uv will give velocity vectors (also useful with -N) 
%   -o CCCCC will run through five different plugin-computed quantities, in order 
%     (advancing to the next plugin when the previous has computed all it can) 
%   -o CC*CC* will run through two but compute mean and SD of each. 
% 
% 

