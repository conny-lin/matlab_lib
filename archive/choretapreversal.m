function choretapreversal(ptrv)
%% java argument components
javacall = 'java -jar -Xmx8G';
beethoven = '''/Users/connylinlin/Desktop/Beethoven_v2.jar''';
chor = '''/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar''';
pixelsize = '-p 0.027';
speed = '-s 0.1';
mintime = '-t 20';
minmove = '-M 2';
shape = '--shadowless -S';
output3 = '-o 1nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d';
output1 = '-o nNss*b12M';
pluginreoutline = '--plugin Reoutline::exp';  
pluginrespine = '--plugin Respine';
pluginreversal = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';
map = '--map';

%% create java syntax
chorvar = {javacall,chor,pixelsize,speed,mintime,minmove,...
            shape,pluginreoutline,pluginrespine,pluginreversal,ptrv}'; 
i = size(chorvar,1);
s = {'%s '};
s2(1:i) = s;
s3 = cell2mat(s2);
chorescript = sprintf(s3,javacall,chor,pixelsize,speed,mintime,minmove,...
            shape,pluginreoutline,pluginrespine,pluginreversal,ptrv);
%% run java
systemcallscript = system(chorescript, '-echo');
end

