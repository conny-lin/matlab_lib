function choretest(pMWT)
%% analyze reversals ignoring taps
%% text codes
%Mac
%java -jar -Xmx8G '/Users/connylinlin/Desktop/Beethoven_v2.jar' '/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar ' -p 0.027 -s 0.1 -t 20 -M 2 --shadowless -S -o 1nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d --plugin Reoutline::exp  --plugin Respine --plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv
% Evan reversal no tap
%java -jar -Xmx8G '/Users/connylinlin/Desktop/Beethoven_v2.jar' '/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar ' -p 0.027 -s 0.1 -t 20 -M 2 --shadowless -S -o nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d*1 --plugin Reoutline::exp --plugin Respine --plugin MeasureReversal::postfix=txt

%% java argument components
% no need to include space as sprintf will accommodate spaces
% initial components
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
% plugin
pluginreoutline = '--plugin Reoutline::exp';  
pluginrespine = '--plugin Respine';
% plug in reversal output
pluginreversal = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';
pluginreversal_notap = '--plugin MeasureReversal::postfix=txt';


%% create java syntax
chorvar = {javacall,javaRAM,chor,pixelsize,speed,mintime,minmove,...
            shape,output2,pluginreoutline,pluginrespine,pMWT}'; 
i = size(chorvar,1);
s = {'%s '};
s2(1:i) = s;
s3 = cell2mat(s2);
chorescript = sprintf(s3,javacall,javaRAM,chor,pixelsize,speed,mintime,...
               minmove,shape,output2,pluginreoutline,pluginrespine,...
               pMWT);
%% run java
systemcallscript = system(chorescript, '-echo');
end