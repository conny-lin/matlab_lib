function [varargout] = MWTAnalysisSetUpMaster(varargin)


%% VARARGIN

pList = varargin{1};

%% get pList content
pSave = pList.pSave;
pJava = pList.pJava;
APack = pList.AnalysisPackName;
% pFun = pList.pFun;
pFunA = pList.pFunA;


%% DEFINE ANALYSIS PACKAGE
display ' ';
display 'Analysis options: ';
disp(makedisplay(APack));
display ' ';
AnalysisName = APack{input('Select analysis option: ')};


%% GET ANALYSIS PACK PATH
pFunAP = [pFunA,'/',AnalysisName];


%% TIME INTERVAL
OptionNoTimeInput = {'ShaneSpark'};
optioni = celltakeout(regexp(OptionNoTimeInput,AnalysisName),'logical');
if optioni ==1
    % do not need time input

else
    % define time
    display ' ';
    display 'Time interval setting options:'
    a = {'Mean of every 10s from start to finish';
        'Manually enter time intervals'};
    disp(makedisplay(a))
    display ' ';
    method = a{input('Choose analysis time interval setting: ')};
    
    switch method
        case 'Mean of every 10s from start to finish'
           TimeInputs = [NaN,10,NaN,NaN];
        case 'Manually enter time intervals'        
            display 'Enter analysis time periods: ';
            tinput = input('Enter start time, press [Enter] to use MinTracked: ');
            intinput = input('Enter interval, press [Enter] to use default (10s): ');
            tfinput = input('Enter end time, press [Enter] to use MaxTracked: ');
            display 'Enter duration after each time point to analyze';
            % (optional) survey duration after specifoied target time point
            durinput = input('press [Enter] to analyze all time bewteen intervals: '); 

            % organize time inputs
            if isempty(tinput) ==1; tinput = NaN; end
            if isempty(intinput) ==1; intinput = NaN; end
            if isempty(durinput) ==1; durinput = NaN; end
            if isempty(tfinput) ==1; tfinput = NaN; end
            TimeInputs = [tinput,intinput,durinput,tfinput];


    end
end


%% CREATE OUTPUT FOLDER
display ' ';
display 'Name your analysis output folder';
a = clock;
time = [num2str(a(4)),num2str(a(5))];
name = [input(': ','s'),'_',AnalysisName,'_',datestr(now,'yyyymmdd'),time];
mkdir(pSave,name);
pSaveA = [pSave,'/',name];



%% GRAPH SETTING


%% ANALYSIS JAVA ARGUMENTS--------------------------------------------------
% path to java programs
%javapath = [strrep(userpath,pathsep,''),'/MATLAB MWT/SubFun_Java'];
% javapath = [pProgram,'/Java'];
javapath = pJava;
choreversion = 'Chore_1.3.0.r1035.jar';

b = blanks(1); % blank
% call java 
javacall = 'java -jar'; javaRAM = '-Xmx8G'; javaRAM7G = '-Xmx7G';
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

%% ANALYSIS JAVA SYNTAX (chorescript) ---------------------------------------
chorscript = {};
switch AnalysisName
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
    case 'SwanLake'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oswanlakeall,b,preoutline,b,...
            prespine,b,revbeethoven_trv,b];   
        chorscript{2} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oswanlake,b,preoutline,b,...
            prespine,b]; 
        fval = {'*.trv';'*swanlake.dat'; '*swanlakeall*'};
    otherwise
        error('option does not exist in chore master');
end
% validate chorescript is cell
if iscell(chorscript) ==0; error 'chorescript must be in cell array'; end




%% OUTPUT
A.pSaveA = pSaveA;
A.pJava = pJava;
if exist('TimeInputs','var') ==1
    A.TimeInputs = TimeInputs;
end
A.AnalysisName = AnalysisName;
A.pFunAP = pFunAP;
A.chorscript = chorscript;
A.chorfile = fval;

varargout{1} = A;



end


