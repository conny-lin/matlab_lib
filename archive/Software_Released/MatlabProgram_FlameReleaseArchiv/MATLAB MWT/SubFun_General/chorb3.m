function chorb3(pMWT)
%% analyze reversals ignoring taps
%% text codes
%Mac
%java -jar -Xmx8G '/Users/connylinlin/Desktop/Beethoven_v2.jar' '/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar ' -p 0.027 -s 0.1 -t 20 -M 2 --shadowless -S -o 1nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d --plugin Reoutline::exp  --plugin Respine --plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv
% Evan reversal no tap
%java -jar -Xmx8G '/Users/connylinlin/Desktop/Beethoven_v2.jar' '/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar ' -p 0.027 -s 0.1 -t 20 -M 2 --shadowless -S -o nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d*1 --plugin Reoutline::exp --plugin Respine --plugin MeasureReversal::postfix=txt
% java arguments
% no need to include space as sprintf will accommodate spaces
% initial components
%  -o requires an argument specifying columns (separate long form with commas) 
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

%% java arguments ---------------------------------------------------------
javacall = 'java -jar';
javaRAM = '-Xmx8G';
% call beethoven 
beethoven = '''/Users/connylinlin/Desktop/Beethoven_v2.jar''';
% call chor
chor = '''/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar''';
% chor calls
map = '--map';
% settings
pixelsize = '-p 0.027';
speed = '-s 0.1';
mintime = '-t 20';
minmove = '-M 2';
shape = '--shadowless -S';
% dat output
output3 = '-o 1nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d'; % Conny's 
output1 = '-o nNss*b12M'; % standard for Beethoven
output2 = '-o nNss*b12'; % Evan's dat output
output4 = '-o nNeslwamMk';


% plugin
pluginreoutline = '--plugin Reoutline::exp';  
pluginrespine = '--plugin Respine';
% plug in reversal output
pluginreversal = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';
pluginreversal_notap = '--plugin MeasureReversal::postfix=txt';
% create file argument
file = strcat('''',pMWT,'''');
%% [developmet] generate chor legend
%chorelegend

% create java syntax --------------------------------------------------
var = {javacall,javaRAM,chor,pixelsize,speed,mintime,minmove,...
            shape,output4,pluginrespine,...
            file}'; 
i = size(var,1);
s = {'%s '};
s2(1:i) = s;
s3 = cell2mat(s2);
chorscript = sprintf(s3,javacall,javaRAM,chor,pixelsize,speed,mintime,...
               minmove,shape,output4,pluginrespine,...
               file);
%% run java ------------------------------------------------------------
system(chorscript, '-echo');
end
