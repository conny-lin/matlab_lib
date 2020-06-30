function [MWTSet] = chormaster_setting(MWTSet)
%%

%% re-run option
display ' ';
display 'Chor options...'

i = input('type ''new'' chor output or press any key for old chor: ','s');
switch i
    case 'new'
        MWTSet.chorstatus = 'new';
    otherwise
        MWTSet.chorstatus = 'old';
end


%% choroption
AnalysisName = MWTSet.AnalysisName;

%% GENERATE CHOR JAVA SYNTAX (chorescript)

% GENERATE JAVA ARGUMENTS
% path to java programs
%javapath = [strrep(userpath,pathsep,''),'/MATLAB MWT/SubFun_Java'];
% javapath = [pProgram,'/Java'];
javapath = MWTSet.pJava;
choreversion = 'Chore_1.3.0.r1035.jar';

b = blanks(1); % blank
% call java 
javacall = 'java -jar'; javaRAM = '-Xmx7G'; javaRAM7G = '-Xmx7G';
beethoven = ['''',javapath,'/Beethoven_v2.jar','''']; % call beethoven 
chor = ['''',javapath,'/',choreversion,'''']; % call chor 
% chor calls 
map = '--map';
% settings 
pixelsize = '-p 0.027'; speed = '-s 0.1'; 
mintime = '-t 20'; minmove = '-M 2'; shape = '--shadowless -S';
% plugins 
preoutline = '--plugin Reoutline::exp';  
prespine = '--plugin Respine';
% plugins (reversals) 
revbeethoven_trv = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';
revignortap_sprevs = '--plugin MeasureReversal::postfix=sprevs';
rev_ssr = '--plugin MeasureReversal::tap::collect=0.5::postfix=ssr';

% dat output 
odrunkposture = '-O drunkposture -o nNslwakb';
odrunkposture2 = '-O drunkposture2 -o nNslwakbcemM';

oconny = '-o 1nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d'; % Conny's 
obeethoven = '-o nNss*b12M'; % standard for Beethoven
oshanespark = '-O shanespark -o nNss*b12M'; % standard for Beethoven
oevan = '-O evan -o nNss*b12'; % Evan's dat output
oevanall = '-O evanall -N all -o nNss*b12';
oswanlakeall = '-O swanlakeall -N all -o tnNemMawlkcspbd1';
oswanlake = '-O swanlake -o tnNemMawlkcspbd1e#m#M#a#w#l#k#c#s#p#b#d#e-m-M-a-w-l-k-c-s-p-b-d-e*m*M*a*w*l*kvc*s*p*b*d*';


%% GENERATE JAVA SYNTAX (chorescript) ---------------------------------------
chorscript = {};
switch char(MWTSet.AnalysisName)
    case 'LadyGaGa'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oevan,b,preoutline,b,prespine,b,...
            revignortap_sprevs,b]; 
        fval = {'*evan.dat';'*.sprevs'};
    
    
    case 'DrunkPosture'
%         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,oevan,b,odrunkposture,b,....
%             preoutline,b,prespine,b]; 
%         fval = {'*drunkposture.dat'};
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oevan,b,odrunkposture2,b,....
            preoutline,b,prespine,b]; 
        fval = {'*drunkposture2.dat'};
    
    
    case 'ShaneSpark'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oshanespark,b,preoutline,b,...
            prespine,b,revbeethoven_trv,b]; 
        fval = {'*.trv';'*shanespark.dat'};
    
    case 'ShaneSpark2'
        [chorscript] = chorjavasyntax_swanlake(MWTSet.pJava);
        fval = {'*swanlake2all.*','*swanlake2.dat'};
    
    case 'Beethoven'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,obeethoven,b,preoutline,b,...
            prespine,b,revbeethoven_trv,b]; 
        fval = {'*.trv'};
    
    
    case 'AnnaPavlova'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oshanespark,b,preoutline,b,...
            prespine,b,revbeethoven_trv,b]; 
        fval = {'*.trv';'*shanespark.dat'};
    
    
    case 'Rastor'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oevanall,b,preoutline,b,prespine,b];
        fval = {'*evanall*'};
    
    
    case 'Swanlake'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oswanlakeall,b,preoutline,b,...
            prespine,b,revbeethoven_trv,b];   
        chorscript{2} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oswanlake,b,preoutline,b,...
            prespine,b]; 
        fval = {'*.trv';'*swanlake.dat'; '*swanlakeall*'};
    
    case 'Swanlake2'
        [chorscript,fval] = chorjavasyntax_swanlake(javapath);
    
    otherwise
        error('option does not exist in chore master');
end
% validate chorescript is cell
if iscell(chorscript) ==0; error 'chorescript must be in cell array'; end
%%

MWTSet.chorscript = chorscript;
MWTSet.chorfile = fval;



end