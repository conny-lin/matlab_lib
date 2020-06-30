function [P,pFun] = getpath_MWTPortaldefault(pFunSave4Later,user,status)
%% Instruction:
% status = 'Grad' or 'Undergrad'

%% check user
% check if user is grad student
graduatestudentlist = {'Conny Lin';'Evan Ardiel'};
a = not(cellfun(@isempty,regexp(graduatestudentlist,user)));

%%
display ' ';

display 'Graduate Stuent list: ');
disp([num2cell((1:numel(graduatestudentlist))') graduatestudentlist]);
switch status
    case 'Grad'
        display 'Select your name';
    case 'Undergrad'
        display 'Select name of your grad supervisor';
end
grad = input('[press ENTRE if name is not listed]: ');
if isempty(grad) ==1;
    % [CODE] create automatic add grad student interface
    disp ' ';
    display('Please ask Conny to ask your name on the list.'); 
    disp ' ';
    return
end

%% check if cd path goes to MWT Portal
datalocation = input('Are your program in the same drive as your MWT Portal (y=1,n=0)? ');
switch datalocation
    case 0;
        display 'Please enter drive name of the MWTPortal containing your data: ';
        datadrivename = input('[e.g. Flame]: ','s');
        datadrivename = strcat('/Volumes/', datadrivename, '/');
        [P] = definepath4diffcomputers2(datadrivename,grad,status); % get predefined paths     
        P.Fun = pFunSave4Later; % adjust pFun location
        pFun = P.Fun;
    case 1;     
        [P] = definepath4diffcomputers2(pFunSave4Later,status); % get predefined paths
        pFun = P.Fun;
end
end


%% Subfunction
function [p] = definepath4diffcomputers2(cd,user,Status)
%% works for grad student only
% Search for [BUG] and [CODE] for development

%% define preset paths
switch Status
    case 'Grad';
        grad = user; % [BUG] only works for grad student 
    case 'Undergrad';
        % [BUG] only works for grad student, can add here to generate a
        % list of undergrad under a grad student
end


%% find hard drive name
path = cd;
n = regexp(path,'/Users/','split');
if numel(n) ==1; % if it is an external hard drive
    n = regexp(path,'/Volumes/','split');
    external = 1; % record external hard drive
else
    external = 0;
end
h = regexp(n{2},'/','split'); 
harddrive = h{1};

%% defining MWT Portal paths
if external ==1; % if it is a external hard drive
    pH = ['/Volumes/',harddrive];
elseif strcmp(harddrive,'connylinlin') ==1; % if it is conny's computer
    pH = '/Users/connylinlin/MatLabTest';
else
    pHt = input('paste the path of MWT Portal folder','s');
    pH = regexprep(pHt,'/MultiWormTrackerPortal');
end
[~,~,~,pf] = dircontent(pH);

a = regexp(pf,'MultiWormTrackerPortal');
if sum(cellfun(@isempty,a)) ==0;
    error ('no MultiWormTrackerPortal found..');
end
p.Portal = pf{not(cellfun(@isempty,a))};

%% get the rest
p.Raw = [p.Portal,'/','MWT_Raw_Data'];
p.Expter = [p.Portal '/' 'MWT_Experimenter_Folders'];
p.Fun = [p.Portal,'/','MWT_Programs'];
p.Setting = [p.Fun '/' 'MatSetfiles'];
p.FunD = [p.Fun '/' 'SubFun_Developer'];
p.FunG = [p.Fun '/' 'SubFun_General'];
p.FunR = [p.Fun '/' 'SubFun_Released'];

%% prep grad student only folder
% [BUG] Needs to pre define this for students
grad = char(regexprep(grad,' ','_'));
p.Grad = [p.Expter,'/',grad];
p.GradA = strcat(p.Grad,'/','MWT_AnalysisReport');
if isdir(p.GradA) ==0;
    cd(p.Grad);
    mkdir('MWT_AnalysisReport');
end
p.GradRaw = strcat(p.Grad,'/','MWT_NewRawReport');
if isdir(p.GradRaw) ==0;
    cd(p.Grad);
    mkdir('MWT_NewRawReport');
end
end
