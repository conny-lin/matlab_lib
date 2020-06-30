function [varargout] = Dance_ShaneSpark2(varargin)

%% instruction
% mean is calculated as ((mean/frame)*samplesize@frame)/sum(samplesize)
% one frame after tap until secondAfterTap
% secondAfterTap = 1;
% timeaftertap = 0;
% N = frame
% standard deviation calculate from mean speed per frame/n frame



%% TESTING CODE
MWTSet = varargin{1};
pMWT = MWTSet.pMWT;

% testfile = '/Users/connylin/Desktop/20110827B_CL_100s30x10s10s_pilot';
% 
% % /Users/connylin/Desktop/20120310C_BM_100s30x10s10s';
% pFunD = '/Users/connylin/Documents/MATLAB/Functions_Developer';
% pJava = '/Users/connylin/Documents/MATLAB/Projects_RankinLab/MWT_Dance/ChoreJava';
% 
% 
% [fn,p] = dircontent(testfile);
% p(ismember(fn,'MatlabAnalysis')) = [];
% [MWTfn,pMWT] = cellfun(@dircontent,p,'UniformOutput',0);
% MWTfn = celltakeout(MWTfn,'multirow');
% pMWT = celltakeout(pMWT,'multirow');

%% SET UP RESTRICTION
secondAfterTap = 1;
timeaftertap = 0;

%% get chorscript output
[chorscript] = chorjavasyntax_swanlake(MWTSet.pJava);
chorscriptval = chorscript{~cellfun(@isempty,regexp(chorscript,...
    '-O swanlake2 '))};
i = strfind(chorscriptval,'-o');
a = regexp(chorscriptval,' ','split');
i = find(~cellfun(@isempty,strfind(a,'-o')));
i = i(end);
script = a{i};

% script = 'tfnN1234e#ee*e-e^m#mm*m-m^M#MM*M-M^w#ww*w-w^l#ll*l-l^a#aa*a-a^k#kk*k-k^c#cc*c-c^s#ss*s-s^b#bb*b-b^p#pp*p-p^d#dd*d-d^x#xx*x-x^y#yy*y-y^u#uu*u-u^v#vv*v-v^o#oo*o-o^r#rr*r-r^';
% ss = 'tfnN1234';
% m = {'e','m','M','w','l','a','k','c','s','b','p','d','x','y','u','v','o','r'};
% st = {'#','','*','-','^'};
% numel(m)*numel(st)+numel(ss)
% 

%% legend reference
%   all -- same as ftnNpsSlLwWaAmkbcd1234 
LL = {
    't', 'time', '-- always the first column unless included again';
'f','frame' '-- the frame number';
'p','persistence', '-- length of time object is tracked ';
'D','id', '-- the object ID';
'n', 'number','-- the number of objects tracked';
'N', 'goodnumber',' -- the number of objects passing the criteria given';
'e','area','';
'm','midline',' -- length measured along the curve of object';
'M','morphwidth','-- mean width of body about midline';
'w','width','';
'W','relwidth',' -- instantaneous width/average width';
'l','length',' -- measured along major axis, not curve of object';
'L','rellength',' -- instantaneous length/average length';
'a','aspect',' -- length/width';
'A','relaspect',' -- instantaneous aspect/average aspect';
'k','kink','-- head/tail angle difference from body (in degrees)';
'c','curve','-- average angle (in degrees) between body split into 5 segments';
's','speed','';
'S','angular','-- angular speed ';
'b','bias',' -- fractional excess of time spent moving one way';
'P','pathlen',' -- distance traveled forwards (backwards=negative)';
'd','dir',' -- consistency of direction of motion';
'x','loc_x',' -- x coordinate of object (mm)';
'y','loc_y',' -- y coordinate of object (mm) ';
'u','vel_x',' -- x velocity (mm/sec)';
'v','vel_y',' -- y velocity (mm/sec) ';
'o','orient',' -- orientation of body (degrees, only guaranteed modulo pi) ';
'r','crab',' -- speed perpendicular to body orientation';
'1','tap',' -- whether a tap (stimulus 1) has occurred ';
'2','puff',' -- whether a puff (stimulus 2) has occurred';
'3','stim3',' -- whether the first custom stimulus has occurred';
'4','stim4',' -- whether the second custom stimulus has occurred.'};

Lstats = {
 '^','max','-- maximum value';
'_','min',' -- minimum value';
'#','number',' -- number of items considered in this statistic';
'-','median',' -- median value ';
'*','std',' -- standard deviation ';
'sem','sem',' -- standard error ';
'var','var',' -- variance ';
'?','exists',' -- 1 if the value exists, 0 otherwise';
'p25','p25',' -- 25th percentile ';
'p75','p75',' -- 75th percentile ';
'jitter','jitter',' -- estimate of measurement precision';
};

%% ChorL: chor legend
h = char(LL(:,1))';
s = char(Lstats(:,1));
names = {};
n2 = {};
c = 0;
for x = 1:numel(script)
    i = strfind(h,script(x));
    if isempty(i) ==0
        c = c+1;
        names(c,1) = LL(i,2);
        
    else
        
        i = regexpcellout(Lstats(:,1),script(x));
        stats = Lstats(i,2);
        if sum(i) == 0
            k = [1:5 8];
            i = strfind(s(k,1)',script(x));
            stats = Lstats(k(i),2);
        end
        names{c,1} = [names{c,1},'_',char(stats)];
%         n2(x,1) = stats;
    end
end

ChorL = names;


      
      
%% import
Import = {};
for x = 1:numel(pMWT)
    [~,pfile] = dircontent(pMWT{x},'*swanlake2.dat');
    [~,n] = fileparts(pMWT{x});
    Import{x,1} = n;
    Import{x,2} = dlmread(pfile{1},' ',0,0);
end


%% DataVal: valid data
% one frame after tap until secondAfterTap


DataVal = {};
tapN = zeros(size(Import,1),1);
for x = 1:size(Import,1)
    A = Import{x,2};
    % restrict time
    tap = A(:,strcmp(ChorL,'tap')) == 1;
    tapN(x) = sum(tap);
    
    taptime = A(tap,strcmp(ChorL,'time'));
    surveyEndtime = taptime + secondAfterTap;
    time = A(:,strcmp(ChorL,'time'));
    
    timeval = false(size(time));
    tapNumber = zeros(size(taptime));
    for t = 1:numel(taptime)
        ti = time > (taptime(t)+ timeaftertap) & time <= surveyEndtime(t);
        timeval(ti,1) = true;
        tapNumber(ti,1) = t;
    end
    tapNumber(tapNumber == 0) = [];
    A = A(timeval,:); % get only valid time
    DataVal{x,1} = Import{x,1};
    DataVal{x,2} = A;
    TapNumber{x,1} = tapNumber;

end

%% VALIDATE EQUALITY OF TAP NUMBER
commontap = mode(tapN);
i = tapN ~= commontap;
if sum(i) >0
    display(sprintf('exclude MWT with different tap number than %d',commontap));
    disp(Import(i,1));
    DataVal = DataVal(~i,:);
else
    display(sprintf('all MWT files have the same tap number: %d',commontap));
end

%% MAKE SENSE OF IMPORT
% N (frame#), mean (weighted mean by frame good number), SD (mean/frame),
% SE (mean/frame, N = frame number)

% s speed
% b bias -- fractional excess of time spent moving one way
% P pathlen -- distance traveled forwards (backwards=negative)
% d dir -- consistency of direction of motion
% t time -- always the first column unless included again
% f frame -- the frame number
% p persistence -- length of time object is tracked
% n number -- the number of objects tracked
% N goodnumber -- the number of objects passing the criteria given

measurelist = {
    'RevSpeed','speed','speed_number';
    'RevBias','bias','bias_number';
    'RevPathlen','pathlen','pathlen_number';
    'RevDir','dir','dir_number';
};

Raw = [];

for m = 1:size(measurelist,1)
    measure = measurelist{m,1};
    chormeanname = measurelist{m,2};
    chorNname = measurelist{m,3};
    
    for x = 1:size(DataVal,1)
        A = DataVal{x,2};
        speed = A(:,strcmp(ChorL,chormeanname));
        samplesize = A(:,strcmp(ChorL,chorNname));

        tap = unique(TapNumber{x,1});

        
        S = [];
        for t = 1:numel(tap)
           i = TapNumber{x,1} == t;
           a = speed(i);
           n = samplesize(i);
           b = [];
           for y = 1:numel(a)
               b = [b;repmat(a(y),n(y),1)];
           end

           S(t,1) = numel(a); % N
           S(t,2) = nanmean(b); % mean
           S(t,3) = nanstd(a); % std
           S(t,4) = nanstd(a)/sqrt(numel(a)); % standard error      
        end
        
        Raw.Y.(measure)(:,x) = S(:,2);
        Raw.X.(measure)(:,x) = tap;
        Raw.E.(measure)(:,x) = S(:,4);
        Raw.SD.(measure)(:,x) = S(:,3);

    end
end

MWTSet.Raw = Raw;
varargout{1} = MWTSet;

end

% 
% 
% 
% 
% 
% 
% %% VARAGOUT
% varargout{1} = {};
% 
% 
% %% VARARGIN
% switch nargin
%     case 1
%        MWTSet = varargin{1};
%         
%     otherwise
%         error('coding');
% end
% 
% 
% 
% %% get field out
% % getstructvar(MWTSet); - function 
% names = fieldnames(MWTSet);
% for x = 1:numel(names)
%    eval([names{x},'= MWTSet.',names{x},';']);
% end
% 
% 
% % validate required input vs. var name
% rinput = {'pMWTchorpass','pMWTf'};
% 
% for x = 1:size(rinput,1)
%     
%     % check if struct name is convereted to varname
%     structname = rinput{x,1};
%     
%     if exist(structname,'var') == 1 % if it is
%         % convert to desired var name
%         varname = rinput{x,2};
%         eval([varname,'= ',structname,';']);
%     else % if it is not
%         error('not enough input from MWTSet');       
%     end    
% end
% 
%         
% %% GET MWT FILE PATH
% % pMWTf = MWTSet.pMWTchorpass;
% [~,MWTfn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);
% 
% 
% %% STEP4A: IMPORT .TRV 
% % revised 20140419
% A = MWTfn;
% for m = 1:size(pMWTf,1);
%     display(sprintf('processing[%d/%d]: %s',m,numel(pMWTf),MWTfn{m}));
%     [~,p] = dircontentext(pMWTf{m},'*.trv'); 
%     % validate trv output format
%     pt = p{1};
%     fileID = fopen(pt,'r');
%     d = textscan(fileID, '%s', 2-1, 'Delimiter', '', 'WhiteSpace', '');
%     fclose(fileID);
%     % read trv
%     if strcmp(d{1}{1}(1),'#') ==1 % if trv file is made by Beethoven
%         a = dlmread(pt,' ',5,0); 
%     else % if trv file is made by Dance
%         a = dlmread(pt,' ',0,0);
% 
%     end
%     A{m,2} = a(:,[1,3:5,8:10,12:16,19:21,23:27]); % index to none zeros
% 
% end
% MWTfnImport = A;
% MWTSet.Import = MWTfnImport;
% 
% %% legend
% L = {'time','N?','N_NoResponse','N_Reversed','?','RevDist'
%     };
%     
% 
% %% STEP4X: CHECK TAP CONSISTENCY
% [r,c] = cellfun(@size,MWTfnImport(:,2),'UniformOutput',0);
% rn = celltakeout(r,'singlenumber');
% rfreq = tabulate(rn);
% rcommon = rfreq(rfreq(:,2) == max(rfreq(:,2)),1);
% str = 'Most common tap number = %d';
% display(sprintf(str,rcommon));
% rproblem = rn ~= rcommon;
% 
% if sum(rproblem)~=0;
%     MWTfnP = MWTfn(rproblem); 
%     pMWTfP = pMWTf(rproblem);
% 
%     str = 'The following MWT did not have the same tap(=%d)';
%     display(sprintf(str,rcommon)); disp(MWTfnP);
%     display 'Removing from analysis...'; 
%     MWTSet.RawBad = MWTfnImport(rproblem,:);
%     MWTfnImport = MWTfnImport(~rproblem,:);
%     MWTfn = MWTfn(~rproblem);
%     pMWTf = pMWTf(~rproblem);    
%     
%     % reconstruct
%     [MWTSet.MWTfG] = reconstructMWTfG(pMWTf);
% 
% end
% 
% 
% 
% %% STEP4B: MAKING SENSE OF TRV 
% % indexes of .trv
% ind.RevDur = 13;
% 
% B = [];
% B.MWTfn = MWTfn;
% A = MWTfnImport;
% for m = 1:size(pMWTf,1);
%     
%     % X = tap time
%     % B.X.TapTime(:,m) = A{m,2}(:,1);
%     B.X(:,m) = A{m,2}(:,1);
%     
%     % basic caluations
%     B.N.NoResponse(:,m) = A{m,2}(:,3);
%     B.N.Reversed(:,m) = A{m,2}(:,4); 
%     
%     B.N.TotalN(:,m) = B.N.Reversed(:,m)+B.N.NoResponse(:,m);
%     
%     % Frequency
%     B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./B.N.TotalN(:,m);
%     % B.Y.RevFreqStd(:,m) = B.Y.RevFreq(:,m)/B.Y.RevFreq(1,m);
%     
%     % Distance
%     B.Y.RevDist(:,m) = A{m,2}(:,5); 
%     % B.Y.RevDistStd(:,m) = B.Y.RevDist(:,m)/B.Y.RevDist(1,m);
%     % B.Y.SumRevDist(:,m) = B.Y.RevDist(:,m).*B.N.Reversed(:,m); 
%     
%     
%     % Reversal Duration
%     B.Y.RevDur(:,m) = A{m,2}(:,ind.RevDur);
%     
%     % Reversal Speed = RevDist/RevDur
%     B.Y.RevSpeed(:,m) = B.Y.RevDist(:,m)./B.Y.RevDur(:,m); 
%     
% end
% 
% 
% Raw = B;
% 
% %% VARARGOUT
% MWTSet.Raw = Raw;
% varargout{1} = MWTSet;

