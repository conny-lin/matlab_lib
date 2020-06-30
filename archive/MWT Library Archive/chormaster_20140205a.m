function [chorscript] = chormaster_20140204(pMWT,pProgram,varargin)

% function [chorscript] = chormaster2(paths,option,pData)

% CHOREGRAPHY
% input must be a rx1 cell array containing rows of paths to MWT folders
% source code: MWT003_chormaster



Var = varargin;


% PATH
% % pData & pBadFiles
% i = cellfun(@isdir,Var); % see if pData path is provided
% 
% if sum(i) ==1;  % if pData is provided
%     pData = Var(i); 
% 
%     
% % if provided with pData and pBadFiles
% elseif sum(i) ==2; 
%     i = find(i);
%     pData = i(1);
%     pBadFiles = i(2);
% 
%     
% % if no path provided
% elseif sum(i) ==0;
%     
%     PathCommonList;
%     
%     % check if rose is a dir
%     p = paths.pRose;
%     if isdir(p) ==1; 
%         pData = paths.MWT.pRoseData; 
%         pBadFiles = paths.MWT.pBadFiles;
% 
%     else
%         error 'Rose is not attached';
%     end
%     
% end




% VALIDATE pMWT INTPUTS
% get all MWT folders under input paths
p = [];
for x = 1:numel(pMWT)
    if exist(pMWT{x},'dir')==7
        p2 = genpath(pMWT{x});
        p = [p,':',p2];
    end
end

a = regexp(p,':','split');
b = regexp(a,'\<(\d{8})[_](\d{6})\>');
i = celltakeout(b','singlenumber');
i = i~=0;
pMWT = a(i)';
if isempty(pMWT)
    error 'path contains no MWT folder';
end


% CHECK INTEGRITY OF MWT FILES
% prepare pMWTf input for validation
display 'Validating MWT folder contents...';
% check for files
fname = '*.blobs';
a = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
    cellfunexpr(pMWT,fname),'UniformOutput',0))); % get numer of files
fname = '*.summary';
b = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
    cellfunexpr(pMWT,fname),'UniformOutput',0))); % get numer of files
fname = '*.set';
c = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
    cellfunexpr(pMWT,fname),'UniformOutput',0))); % get numer of files
% fname = '*.png';
% d = cellfun(@numel,(cellfun(@dircontentext,paths,...
%     cellfunexpr(paths,fname),'UniformOutput',0))); % get numer of files


% MOVE BAD MWT FILES TO BAD FOLDER 

[r,c] = find([a,b,c]==0);
if isempty(r)==0;
    % make pBadFile folder
    p = fileparts(fileparts(fileparts(fileparts(pMWT{1}))));
    filename = 'MWT_BadFiles';
    pBadFiles = [p,'/',filename];
    if exist(pBadFiles,'dir')~=7
        mkdir(p,filename)
    end
    pData = p;
    
    p = pMWT(r); % % find files with missing MWT files
    a = cellfun(@strrep,p,cellfunexpr(p,pData),cellfunexpr(p,pBadFiles),...
        'UniformOutput',0); % replace pData path with pBadFiles paths
    %makemisspath(cellfun(@fileparts,a,'UniformOutput',0)); % make folders
    cellfun(@movefile,p,a); % move files
    str = '[%d] bad MWT files moved out of Analysis folder';
    display(sprintf(str,numel(a)));
    pMWT = pMWT(~r); % update path
else
    display 'All MWT files contain .blob, .summary & .set';
end


% GET CHOR OPTION
AList = {'LadyGaGa';
        'ShaneSpark';
        'Beethoven';
        'DrunkPosture';
        'AnnaPavlova';
        'Rastor';
        'SwanLake'};


% get option from varargin
i = cellfun(@isstr,Var) & ~cellfun(@isdir,Var);
option = AList{regexpcellout(AList,Var(i))};


% %% chor options list
% %  ------[update as you add more options] ---- 
% AnaList = '(LadyGaGa)|(ShaneSpark)|(Beethoven)|(DrunkPosture)|(AnnaPavlova)|(Rastor)|(SwanLake)';
% %  ------[update as you add more options] ----
% 
% Chor = char(regexp(option,AnaList,'match'));
% if isempty(Chor)==1; % if no match, select options
%     % create display list
%     select = sortrows(AnaList);
%     [b1] = cellfunexpr(AnaList,'['); [b2] = cellfunexpr(AnaList,']');
%     num = cellstr(num2str((1:numel(AnaList))'));
%     display(char(cellfun(@strcat,b1,num,b2,select,'UniformOutput',0)));
%     % ask for analysis id
%     display ' '; answer = input('Select analysis or [Enter] to abort: ');
%     if isempty(answer)==1; return; end
%     Chor = select{answer};
% end

%% JAVA ARGUMENTS--------------------------------------------------
% path to java programs
%javapath = [strrep(userpath,pathsep,''),'/MATLAB MWT/SubFun_Java'];
javapath = [pProgram,'/Java'];

b = blanks(1); % blank
% call java 
javacall = 'java -jar'; javaRAM = '-Xmx8G'; javaRAM7G = '-Xmx7G';
beethoven = ['''',javapath,'/Beethoven_v2.jar','''']; % call beethoven 
chor = ['''',javapath,'/Chore_1.3.0.r1035.jar','''']; % call chor 
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
oconny = '-o 1nee#e*ss#s*SS#S*ll#l*LL#L*ww#w*aa#a*mm#m*MM#M*kk#k*bb#b*pp#p*dd#d'; % Conny's 
obeethoven = '-o nNss*b12M'; % standard for Beethoven
oshanespark = '-O shanespark -o nNss*b12M'; % standard for Beethoven
oevan = '-O evan -o nNss*b12'; % Evan's dat output
oevanall = '-O evanall -N all -o nNss*b12';
oswanlakeall = '-O swanlakeall -N all -o tnNemMawlkcspbd1';
oswanlake = '-O swanlake -o tnNemMawlkcspbd1e#m#M#a#w#l#k#c#s#p#b#d#e-m-M-a-w-l-k-c-s-p-b-d-e*m*M*a*w*l*kvc*s*p*b*d*';




%% CREATE JAVA SYNTAX (chorescript) ---------------------------------------
chorscript = {};
switch option
    case 'LadyGaGa'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oevan,b,preoutline,b,prespine,b,...
            revignortap_sprevs,b]; 
        fval = {'*evan.dat';'*.sprevs'};
    case 'DrunkPosture'
        chorscript{1} = [javacall,b,javaRAM,b,chor,b,pixelsize,b,speed,b,...
            mintime,b,minmove,b,shape,b,oevan,b,odrunkposture,b,....
            preoutline,b,prespine,b]; 
        fval = {'*drunkposture.dat'};
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



%% CHECK IF CHOR HAD BEEN DONE
% DEFINE CHOROUTPUTS AND CHOR CODE
display ' '; display 'Checking chor outputs...'
% check chor ouptputs
val = ones(numel(pMWT),numel(fval));
for v = 1:size(fval,1);
    [fn,~] = cellfun(@dircontentext,pMWT,cellfunexpr(pMWT,fval{v})...
        ,'UniformOutput',0); % search for files
    val(:,v) = cellfun(@isempty,fn);
end

% get files that need chor
i = find(sum(val,2));
if isempty(i) == 0; 
    pMWT = unique(pMWT(i)); 
    display(sprintf('Need to Chore %d MWT files',numel(pMWT)));
else display 'All files contain required Chor outputs'; return;end


%% STEP4C: RUN CHORE
% flexibility with different paths inputs
str = 'Chor-ing MWTfile [%s]...';
for x = 1:numel(pMWT); 
    [~,fn] = fileparts(pMWT{x}); file = strcat('''',pMWT{x},''''); 
    display(sprintf(str,fn));
    for cs = 1:numel(chorscript) 
        system([chorscript{cs} file], '-echo'); 
    end  
end
display 'Chor Finished.';
end % function end
