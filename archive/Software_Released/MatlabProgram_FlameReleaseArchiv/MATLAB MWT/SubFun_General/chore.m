% system('','-echo')
% chorescript = sprintf('%s ''%s''',javacall,chor)
%% [test path]
pExpChore = '/Users/connylinlin/MatLabTest/Flame/MWT_Personal_Folders/Daniel_Hsiao/20130603C_DH_100s30x10s10s';

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

%%
bettest = {javacall,beethoven,chor,pixelsize,speed,mintime,minmove,shape,output1,pluginreoutline,pluginrespine,pluginreversal}'
i = size(bettest,1)

%%
s = {'%s '}
s2(1:i) = s
s3 = cell2mat(s2)
chorescript = sprintf(s3,javacall,beethoven,chor,pixelsize,speed,mintime,minmove,shape,output1,pluginreoutline,pluginrespine,pluginreversal)
%% run java
systemcallscript = system(chorescript, '-echo')
%%
{pixelsize,speed,mintime,minmove,shape,pluginreoutline,pluginrespine,pluginreversal}'


javacall,chor,pixelsize,speed,mintime,minmove,...
shape,output,pluginreoutline,pluginrespine,pluginreversal


%%


help = '--help';


java -jar -Xmx8G '/Users/connylinlin/Desktop/Chore_1.3.0.r1035.jar' 