function [varargout] = MWTAnalysisSetUpMaster(varargin)
%% instruction
% input names should be fixed


%% VARARGIN
InputName = cell(size(varargin));
for x = 1:numel(varargin)
    InputName{x} = inputname(x);
end


% get pList content
name = 'pList';
i = ismember(InputName,name);
if sum(i) ==1

    % get var out
    pList = varargin{i};
    % MWTSet set up
    MWTSet = pList;
    % get individual var
    pSave = pList.pSave;
    pJava = pList.pJava;
    pFun = pList.pFun;
    pFunA = pList.pFunA;
    pFunG = pList.pFunG;
else
    error('%s input required',name);
end


%% SEARCH MWT DATABASE
liquidtsfcutoffdate = 20120213;
invertedcutoffdate = 20130919;
[MWTfG] = MWTDataBaseMaster(pList.pData,'search');

% % get MWTfG content
% name = 'MWTfG';
% i = ismember(InputName,name);
% if sum(i) ==1
%     MWTfG = varargin{i};
% else
%     error('%s input required',name);
% end


%% choose analysis parameter
choicelist = {'Within Exp';'Any Exp'};
disp(makedisplay(choicelist));
choice = choicelist{input(': ')};
switch choice
    case 'Within Exp'
        [MWTfG] = MWTDataBase_withinexp(MWTfG);
end


%% IDENTIFY PROBLEM PLATES
% get plates
names = fieldnames(MWTfG);
fn = {};
for x = 1:numel(names)
    fn1 = MWTfG.(names{x});
    fn = [fn;fn1];
end
% get rid of MWT plates marked problematic
i = regexpcellout(fn(:,1),'\<(\d{8})[_](\d{6})\>');
fn2 = sortrows(fn(i,:),1);

% ask if want to exclude certain plates
display 'Do you want to exclude specific plates?';
opt = input('[yes/no]: ','s');
if strcmp(opt,'yes') == 1
    [fn3] = chooseoption(fn2,2);
    i = ~ismember(fn2(:,2),fn3);
    fn4 = fn2(i,2);
    [MWTfG] = reconstructMWTfG(fn4);
else
    display 'include all plates found';
end

%% DEFINE ANALYSIS PACKAGE
display ' ';
display 'Analysis options: ';
APack = dircontent(pFunA);
disp(makedisplay(APack));
display ' ';
AnalysisName = APack{input('Select analysis option: ')};
% GET ANALYSIS PACK PATH
MWTSet.pFunAP = [pFunA,'/',AnalysisName];
% MWTSet output
MWTSet.AnalysisName = AnalysisName;

%% TIME INTERVAL
OptionNoTimeInput = {'ShaneSpark','ShaneSpark2'};
optioni = sum(strcmp(OptionNoTimeInput,AnalysisName));

%%
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

if exist('TimeInputs','var') ==1
    MWTSet.TimeInputs = TimeInputs;
end

%% CREATE OUTPUT FOLDER
display ' ';
display 'Name your analysis output folder';
name = [AnalysisName,'_',generatetimestamp,'_',input(': ','s')];
cd(pSave);
mkdir(name);
pSaveA = [pSave,'/',name];

MWTSet.pSaveA = pSaveA;

%% GRAPHING OPTIONS
display ' ';
display 'Graphing options: ';
GPack = dircontent(pFunG);
disp(makedisplay(GPack));
display ' ';
i = str2num(input('Select graphing option(s): ','s')');
GraphNames = GPack(i);
% GET ANALYSIS PACK PATH
for x = 1:numel(GraphNames)
    pFunGP{x,1} = [pFunG,'/',GraphNames{x}];
end

MWTSet.GraphNames = GraphNames;
MWTSet.pFunGP = pFunGP;

%% STATS OPTIONS
display ' ';
display 'Statistics options...';
[MWTSet] = Dance_StatsMaster(MWTSet,'Setting');


%% CHOR OPTIONS
[MWTSet] = chormaster(MWTSet,'Setting');
% display ' ';
% display 'Chor options...'
% 
% i = input('type ''new'' chor output or press any key for old chor: ','s');
% switch i
%     case 'new'
%         MWTSet.chorstatus = 'new';
% otherwise
%         MWTSet.chorstatus = 'old';
% end

% GENERATE CHOR JAVA SYNTAX (chorescript)

% % GENERATE JAVA ARGUMENTS
% % path to java programs
% %javapath = [strrep(userpath,pathsep,''),'/MATLAB MWT/SubFun_Java'];
% % javapath = [pProgram,'/Java'];
% javapath = pJava;
% choreversion = 'Chore_1.3.0.r1035.jar';
% 
% b = blanks(1); % blank
% % call java 
% javacall = 'java -jar'; javaRAM = '-Xmx7G'; javaRAM7G = '-Xmx7G';
% beethoven = ['''',javapath,'/Beethoven_v2.jar','''']; % call beethoven 
% chor = ['''',javapath,'/',choreversion,'''']; % call chor 
% % chor calls 
% map = '--map';
% % settings 
% pixelsize = '-p 0.027'; speed = '-s 0.1'; 
% mintime = '-t 20'; minmove = '-M 2'; shape = '--shadowless -S';
% % plugins 
% preoutline = '--plugin Reoutline::exp';  
% prespine = '--plugin Respine';
% % plugins (reversals) 
% revbeethoven_trv = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';
% revignortap_sprevs = '--plugin MeasureReversal::postfix=sprevs';
% rev_ssr = '--plugin MeasureReversal::tap::collect=0.5::postfix=ssr';
% 
% % dat output 
% odrunkposture = '-O drunkposture -o nNslwakb';
% odrunkposture2 = '-O drunkposture2 -o nNslwakbcemM';
% 
% oconny = '-o 1nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d'; % Conny's 
% obeethoven = '-o nNss*b12M'; % standard for Beethoven
% oshanespark = '-O shanespark -o nNss*b12M'; % standard for Beethoven
% oevan = '-O evan -o nNss*b12'; % Evan's dat output
% oevanall = '-O evanall -N all -o nNss*b12';
% oswanlakeall = '-O swanlakeall -N all -o tnNemMawlkcspbd1';
% oswanlake = '-O swanlake -o tnNemMawlkcspbd1e#m#M#a#w#l#k#c#s#p#b#d#e-m-M-a-w-l-k-c-s-p-b-d-e*m*M*a*w*l*kvc*s*p*b*d*';
% 
% 
% % GENERATE JAVA SYNTAX (chorescript) ---------------------------------------
% chorscript = {};
% switch AnalysisName
%     case 'LadyGaGa'
%         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,oevan,b,preoutline,b,prespine,b,...
%             revignortap_sprevs,b]; 
%         fval = {'*evan.dat';'*.sprevs'};
%     case 'DrunkPosture'
% %         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
% %             mintime,b,minmove,b,shape,b,oevan,b,odrunkposture,b,....
% %             preoutline,b,prespine,b]; 
% %         fval = {'*drunkposture.dat'};
%         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,oevan,b,odrunkposture2,b,....
%             preoutline,b,prespine,b]; 
%         fval = {'*drunkposture2.dat'};
%     case 'ShaneSpark'
%         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,oshanespark,b,preoutline,b,...
%             prespine,b,revbeethoven_trv,b]; 
%         fval = {'*.trv';'*shanespark.dat'};
%     case 'Beethoven'
%         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,obeethoven,b,preoutline,b,...
%             prespine,b,revbeethoven_trv,b]; 
%         fval = {'*.trv'};
%     case 'AnnaPavlova'
%         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,oshanespark,b,preoutline,b,...
%             prespine,b,revbeethoven_trv,b]; 
%         fval = {'*.trv';'*shanespark.dat'};
%     case 'Rastor'
%         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,oevanall,b,preoutline,b,prespine,b];
%         fval = {'*evanall*'};
%     case 'SwanLake'
%         chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,oswanlakeall,b,preoutline,b,...
%             prespine,b,revbeethoven_trv,b];   
%         chorscript{2} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
%             mintime,b,minmove,b,shape,b,oswanlake,b,preoutline,b,...
%             prespine,b]; 
%         fval = {'*.trv';'*swanlake.dat'; '*swanlakeall*'};
%     otherwise
%         error('option does not exist in chore master');
% end
% % validate chorescript is cell
% if iscell(chorscript) ==0; error 'chorescript must be in cell array'; end
% 


% MWTSet output
% MWTSet.chorscript = chorscript;
% MWTSet.chorfile = fval;




%% OUTPUT

% if exist('TimeInputs','var') ==1
%     MWTSet.TimeInputs = TimeInputs;
% end
% MWTSet.AnalysisName = AnalysisName;
% MWTSet.GraphNames = GraphNames;
% MWTSet.pFunGP = pFunGP;
% MWTSet.pFunAP = pFunAP;
% MWTSet.pSaveA = pSaveA;
% MWTSet.chorscript = chorscript;
% MWTSet.chorfile = fval;
% MWTSet.chorstatus = chorstatus;
% MWTSet.GraphSetting = GraphSetting;
MWTSet.MWTfG = MWTfG;


varargout{1} = MWTSet;



end


